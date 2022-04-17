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
        n = torch.arange(N, dtype=torch.float32)
        k = n.reshape((N,1))
        M = torch.exp(-2 * np.pi * k * n / N)
        return torch.matmul(M.type(torch.float32), x.type(torch.float32))

    @export
    @annotate_args([
        None,
        ([32], torch.float32, True),
    ])
    def forward(self, x):
        return self.dft(x)

class FftModule(torch.nn.Module):
    def __init__(self):
        super().__init__()

    @staticmethod
    def dft(x:torch.Tensor):
        N = x.shape[0]
        n = torch.arange(N, dtype=torch.float32)
        k = n.reshape((N,1))
        _M = np.pi * k * n / N
        M = np.array([np.zeros(_M.shape), torch.exp(-2j * _M)])
        return torch.matmul(M.type(torch.float32), x.type(torch.float32))

    @staticmethod
    def fft(x:torch.Tensor):
        N = x.shape[0]

        if N %2 > 0:
            raise ValueError("must be a power of 2")
        elif N <= 2:
            return FftModule.dft(x)
        else:
            x_even = FftModule.fft(x[::2])
            
            x_odd = FftModule.fft(x[1::2])
            terms = torch.exp(-2j * np.pi * torch.arange(N, dtype=torch.float32) / N) 
            return torch.cat( [x_even + terms[:int(N/2)] * x_odd,
                                x_even + terms[int(N/2):] * x_odd])

    @export
    @annotate_args([
        None,
        ([-1], torch.float32, True),
    ])
    def forward(self, x):
        return self.fft(x)

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
    passes = [
        'torchscript-module-to-torch-backend-pipeline',
        'builtin.func(convert-torch-to-linalg)',
        'builtin.func(linalg-bufferize)',
        # 'builtin.module(linalg-comprehensive-module-bufferize)',
        # 'builtin.func(refback-munge-memref-copy)',
        'builtin.module(func-bufferize)',
        'builtin.module(buffer-results-to-out-params)',
        'func.func(canonicalize)',
        'builtin.func(convert-linalg-to-affine-loops)',
        'builtin.func(convert-torch-to-std)',
        'builtin.module(torch-func-backend-type-conversion)',
    ]
    pm = PassManager.parse(",".join(passes), mb.module.context)
    pm.run(mb.module)
    return mb.module

print(compile_module(DftModule()))
