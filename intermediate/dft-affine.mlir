module attributes {torch.debug_module_name = "DftModule"} {
  func @forward(%arg0: tensor<32xf32>) -> tensor<32xf32> {
    %cst = arith.constant -6.2831853071795862 : f64
    %c32_i64 = arith.constant 32 : i64
    %c0_i64 = arith.constant 0 : i64
    %c1_i64 = arith.constant 1 : i64
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c32 = arith.constant 32 : index
    %c32_i64_0 = arith.constant 32 : i64
    %cst_1 = arith.constant 0.000000e+00 : f32
    %0 = memref.alloc() {alignment = 128 : i64} : memref<32x1xf32>
    %1 = bufferization.to_memref %arg0 : memref<32xf32>
    %2 = arith.sitofp %c0_i64 : i64 to f32
    %3 = arith.sitofp %c32_i64 : i64 to f32
    %4 = arith.sitofp %c1_i64 : i64 to f32
    %5 = arith.subf %3, %2 : f32
    %6 = arith.divf %5, %4 : f32
    %7 = math.ceil %6 : f32
    %8 = arith.fptoui %7 : f32 to i64
    %9 = arith.index_cast %8 : i64 to index
    %10 = memref.alloc(%9) {alignment = 128 : i64} : memref<?xf32>
    affine.for %arg1 = 0 to %9 {
      %31 = arith.index_cast %arg1 : index to i64
      %32 = arith.sitofp %31 : i64 to f32
      %33 = arith.mulf %4, %32 : f32
      %34 = arith.addf %2, %33 : f32
      affine.store %34, %10[%arg1] : memref<?xf32>
    }
    %11 = bufferization.to_tensor %10 : memref<?xf32>
    %12 = tensor.cast %11 : tensor<?xf32> to tensor<32xf32>
    %13 = tensor.expand_shape %12 [[0, 1]] : tensor<32xf32> into tensor<32x1xf32>
    %14 = bufferization.to_memref %13 : memref<32x1xf32>
    affine.for %arg1 = 0 to 32 {
      affine.for %arg2 = 0 to 1 {
        %31 = affine.load %14[%arg1, %c0] : memref<32x1xf32>
        %32 = arith.truncf %cst : f64 to f32
        %33 = arith.mulf %31, %32 : f32
        affine.store %33, %0[%arg1, %arg2] : memref<32x1xf32>
      }
    }
    %15 = tensor.dim %11, %c0 : tensor<?xf32>
    %16 = memref.alloc(%15) {alignment = 128 : i64} : memref<32x?xf32>
    affine.for %arg1 = 0 to 32 {
      affine.for %arg2 = 0 to %9 {
        %31 = affine.load %0[%arg1, %c0] : memref<32x1xf32>
        %32 = affine.load %10[%arg2] : memref<?xf32>
        %33 = arith.mulf %31, %32 : f32
        affine.store %33, %16[%arg1, %arg2] : memref<32x?xf32>
      }
    }
    %17 = bufferization.to_tensor %16 : memref<32x?xf32>
    %18 = tensor.dim %17, %c1 : tensor<32x?xf32>
    %19 = memref.alloc(%18) {alignment = 128 : i64} : memref<32x?xf32>
    affine.for %arg1 = 0 to 32 {
      affine.for %arg2 = 0 to %15 {
        %31 = affine.load %16[%arg1, %arg2] : memref<32x?xf32>
        %32 = arith.sitofp %c32_i64 : i64 to f32
        %33 = arith.divf %31, %32 : f32
        affine.store %33, %19[%arg1, %arg2] : memref<32x?xf32>
      }
    }
    %20 = bufferization.to_tensor %19 : memref<32x?xf32>
    %21 = tensor.dim %20, %c1 : tensor<32x?xf32>
    %22 = memref.alloc(%21) {alignment = 128 : i64} : memref<32x?xf32>
    affine.for %arg1 = 0 to 32 {
      affine.for %arg2 = 0 to %18 {
        %31 = affine.load %19[%arg1, %arg2] : memref<32x?xf32>
        %32 = math.exp %31 : f32
        affine.store %32, %22[%arg1, %arg2] : memref<32x?xf32>
      }
    }
    %23 = bufferization.to_tensor %22 : memref<32x?xf32>
    %24 = tensor.dim %23, %c1 : tensor<32x?xf32>
    %25 = arith.index_cast %24 : index to i64
    %26 = arith.cmpi eq, %25, %c32_i64_0 : i64
    %27 = memref.alloc(%c32) {alignment = 128 : i64} : memref<?xf32>
    affine.for %arg1 = 0 to 32 {
      affine.store %cst_1, %27[%arg1] : memref<?xf32>
    }
    %28 = memref.alloc(%c32) {alignment = 128 : i64} : memref<?xf32>
    memref.copy %27, %28 : memref<?xf32> to memref<?xf32>
    affine.for %arg1 = 0 to 32 {
      affine.for %arg2 = 0 to %21 {
        %31 = affine.load %22[%arg1, %arg2] : memref<32x?xf32>
        %32 = affine.load %1[%arg2] : memref<32xf32>
        %33 = affine.load %28[%arg1] : memref<?xf32>
        %34 = arith.mulf %31, %32 : f32
        %35 = arith.addf %33, %34 : f32
        affine.store %35, %28[%arg1] : memref<?xf32>
      }
    }
    %29 = bufferization.to_tensor %28 : memref<?xf32>
    %30 = tensor.cast %29 : tensor<?xf32> to tensor<32xf32>
    return %30 : tensor<32xf32>
  }
}

