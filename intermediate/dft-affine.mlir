module attributes {torch.debug_module_name = "DftModule"} {
  func @forward(%arg0: memref<32xf32>, %arg1: memref<32xf32>) {
    %c0 = arith.constant 0 : index
    %cst = arith.constant -6.2831853071795862 : f64
    %cst_0 = arith.constant 0.000000e+00 : f32
    %cst_1 = arith.constant 3.200000e+01 : f32
    %c0_2 = arith.constant 0 : index
    %0 = memref.alloc() {alignment = 128 : i64} : memref<32xf32>
    %1 = memref.alloc() {alignment = 128 : i64} : memref<32x1xf32>
    %2 = memref.alloc() {alignment = 128 : i64} : memref<32x32xf32>
    %3 = memref.alloc() {alignment = 128 : i64} : memref<32x32xf32>
    %4 = memref.alloc() {alignment = 128 : i64} : memref<32x32xf32>
    %5 = memref.alloc() {alignment = 128 : i64} : memref<32xf32>
    %6 = memref.alloc() {alignment = 128 : i64} : memref<32xf32>
    %8 = memref.alloc() {alignment = 128 : i64} : memref<32x1xf32>
    affine.for %arg2 = 0 to 32 {
      %10 = arith.index_cast %arg2 : index to i64
      %11 = arith.sitofp %10 : i64 to f32
      %12 = arith.addf %11, %cst_0 : f32
      affine.store %12, %0[%arg2] : memref<32xf32>
    }
    //%7 = bufferization.to_tensor %0 : memref<32xf32>
    //%8 = memref.expand_shape %0 [[0, 1]] : memref<32xf32> into memref<32x1xf32>
    affine.for %arg2 = 0 to 32 {
      %10 = affine.load %0[%arg2] : memref<32xf32>
      affine.store %10, %8[%arg2, %c0] : memref<32x1xf32>
    }
    affine.for %arg2 = 0 to 32 {
      %10 = affine.load %8[%arg2, %c0_2] : memref<32x1xf32>
      %11 = arith.truncf %cst : f64 to f32
      %12 = arith.mulf %10, %11 : f32
      affine.store %12, %1[%arg2, %c0] : memref<32x1xf32>
    }
    affine.for %arg2 = 0 to 32 {
      affine.for %arg3 = 0 to 32 {
        %10 = affine.load %1[%arg2, %c0_2] : memref<32x1xf32>
        %11 = affine.load %0[%arg3] : memref<32xf32>
        %12 = arith.mulf %10, %11 : f32
        affine.store %12, %2[%arg2, %arg3] : memref<32x32xf32>
      }
    }
    affine.for %arg2 = 0 to 32 {
      affine.for %arg3 = 0 to 32 {
        %10 = affine.load %2[%arg2, %arg3] : memref<32x32xf32>
        %11 = arith.divf %10, %cst_1 : f32
        affine.store %11, %3[%arg2, %arg3] : memref<32x32xf32>
      }
    }
    affine.for %arg2 = 0 to 32 {
      affine.for %arg3 = 0 to 32 {
        %10 = affine.load %3[%arg2, %arg3] : memref<32x32xf32>
        %11 = math.exp %10 : f32
        affine.store %11, %4[%arg2, %arg3] : memref<32x32xf32>
      }
    }
    affine.for %arg2 = 0 to 32 {
      affine.store %cst_0, %5[%arg2] : memref<32xf32>
    }
    affine.for %arg2 = 0 to 32 {
      %10 = affine.load %5[%arg2] : memref<32xf32>
      affine.store %10, %6[%arg2] : memref<32xf32>
    }
    affine.for %arg2 = 0 to 32 {
      affine.for %arg3 = 0 to 32 {
        %10 = affine.load %4[%arg2, %arg3] : memref<32x32xf32>
        %11 = affine.load %arg0[%arg3] : memref<32xf32>
        %12 = affine.load %6[%arg2] : memref<32xf32>
        %13 = arith.mulf %10, %11 : f32
        %14 = arith.addf %12, %13 : f32
        affine.store %14, %6[%arg2] : memref<32xf32>
      }
    }
    affine.for %arg2 = 0 to 32 {
      %10 = affine.load %6[%arg2] : memref<32xf32>
      affine.store %10, %arg1[%arg2] : memref<32xf32>
    }
    return
  }
}

