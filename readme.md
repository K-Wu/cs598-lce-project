# 21Spring CS598-LCE Project

This repo is the repo of our 22Spring CS598-LCE course project.

## Environments

This repo is developed and tested under Linux, especially Ubuntu 18.04.5.

## Troubleshooting for Building polyAIE and its dependencies.

For polyaie, you should be able to compile the whole dependencies and itself by following the commands in its readme.md.

* Make sure anaconda is not in your $LD_LIBRARY_PATH. You may ensure this by 1) isolate the conda initialization logic from ~/.bashrc and 2)restart current terminal. If you are using tmux, the change may not take effort for new tmux sessions before all tmux sessions are closed.
* You do not need to install phism for this repo. ~~`sudo apt-get install bison flex libclang-dev` for phism.~~
* `sudo ln -s /usr/bin/llvm-config-10  /usr/bin/llvm-config` if `/usr/bin/llvm-config` does not exist.
* `sudo ln -s /usr/bin/FileCheck-10  /usr/bin/FileCheck`  if `/usr/bin/FileCheck` does not exist.
* Instead of using the llvm+mlir from circt for step 4 installing mlir-aie, use mlir-aie/utils/clone-llvm.sh and mlir-aie/utils/build-llvm.sh to install the dependencies. To specify that as the dependency, check the reference command at https://github.com/Xilinx/mlir-aie/blob/main/.github/workflows/buildAndTest.yml#L65. Notice that you need to specify absolute path, though the command in CI uses relative ones, for `-DMLIR_DIR` and `-DLLVM_DIR`. Thus it should be `-DMLIR_DIR=$PWD/../llvm/install/lib/cmake/mlir` and `-DLLVM_DIR=$PWD/../llvm/install/lib/cmake/llvm`.
* Try gcc9 if there is error when using gcc as the compiler.

## Build Dependencies

This project relies on MLIR and Torch-MLIR. For the sake of writing scripts, they are set as submodules in the /3rdparty directory.

Please first initiate them by `git submodule update --init` if you haven't set the recursive option when cloning this repo.

Then go to the corresponding subdirectories in /3rdparty and follow the MLIR and torch-mlir build instructions list as follows.

* Follow the instructions from **Check out the code** to **Build** at [Torch MLIR](https://github.com/llvm/torch-mlir/blob/main/README.md#check-out-the-code).
* Follow the instruction in **Unix-like compile/testing** at [Getting Started - MLIR](https://mlir.llvm.org/getting_started/).

## Cases
A few cases are at https://github.com/pizhimeng/598-lce and are currently under migration into this repo.

## Dialect Conversion
Many dialect conversions can be done by invoking the passes in `torch-mlir-opt` and `mlir-opt`.

A few command examples can be found at `/3rdparty/torch-mlir/test/Conversion/TorchToLinalg/basic.mlir` and `3rdparty/llvm-project/mlir/test/Conversion/TosaToLinalg/tosa-to-linalg.mlir`.

1. Numpy to TorchScript is done by handwritten pytorch code. Notice that TorchScript only accepts a restricted subset of Pytorch/Torch code, but that covers a majority.
2. TorchScript to Linalg can be done by `torch-mlir-opt -convert-torch-to-linalg`.
3. Linalg to Affine can be done by `mlir-opt --convert-linalg-to-affine-loops`. A similar test case of `aie-opt` can be found at mlir-aie/test/aievec/linalg_conv2d_f32.mlir.