# source /scripts/set_env.sh
TORCH_MLIR_PATH=$PWD/3rdparty/torch_mlir
LLVM_PATH=$PWD/3rdparty/llvm-project
export PATH=$TORCH_MLIR_PATH/bin:$LLVM_PATH/bin:$PATH