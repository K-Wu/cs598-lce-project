import torch
import numpy as np
# import fft

from torch_mlir.eager_mode.ir_building import build_module
from torch_mlir.dialects.torch.importer.jit_ir.torchscript_annotations import extract_annotations
from torch_mlir.dialects.torch.importer.jit_ir import ClassAnnotator, ModuleBuilder
from torch_mlir_e2e_test.linalg_on_tensors_backends.refbackend import RefBackendLinalgOnTensorsBackend
from torch_mlir.passmanager import PassManager
from torch_mlir_e2e_test.torchscript.annotations import annotate_args, export

class DftModule(torch.nn.Module):
    def __init__(self):
        super().__init__()

    def dft(self, x:torch.Tensor):
        N = x.shape[0]
        n = torch.arange(N, dtype=torch.complex64)
        k = n.reshape((N,1))
        M = torch.exp(-2 * np.pi * k * n / N)
        return torch.matmul(M.type(torch.complex64), x.type(torch.complex64))

    @export
    @annotate_args([
        None,
        ([-1], torch.float32, True),
    ])
    def forward(self, x):
        return self.dft(x)

BACKEND = RefBackendLinalgOnTensorsBackend()
def compile_module(program: torch.nn.Module):
    """Compiles a torch.nn.Module into an compiled artifact.
    This artifact is suitable for inclusion in a user's application. It only
depends on the rebackend runtime.
    """
    ## Script the program.
    scripted = torch.jit.script(program)
    ## Extract annotations.
    class_annotator = ClassAnnotator()
    extract_annotations(program, scripted, class_annotator)
    ## Import the TorchScript module into MLIR.
    mb = ModuleBuilder()
    mb.import_module(scripted._c, class_annotator)
    ## Lower the MLIR from TorchScript to RefBackend, passing through linalg-on-tensors.
    ### KWU: only keep the first pass
    pm = PassManager.parse('torchscript-module-to-torch-backend-pipeline', mb.module.context)
    pm.run(mb.module)
    ## Invoke RefBackend to compile to compiled artifact form.
    ### KWU: return mb.module instead of the compiled one by BACKEND
    return mb.module #BACKEND.compile(mb.module

with open("dft.mlir", "w") as out:
    out.write(str(compile_module(DftModule())))
