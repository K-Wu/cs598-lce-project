module attributes {torch.debug_module_name = "DftModule"} {
  func @forward(%arg0: !torch.vtensor<[?],f32>) -> !torch.vtensor<[?],f32> {
    %float-6.283190e00 = torch.constant.float -6.2831853071795862
    %int0 = torch.constant.int 0
    %int1 = torch.constant.int 1
    %c1_i64 = arith.constant 1 : i64
    %c0_i64 = arith.constant 0 : i64
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %cst = arith.constant 0.000000e+00 : f32
    %0 = torch_c.to_builtin_tensor %arg0 : !torch.vtensor<[?],f32> -> tensor<?xf32>
    %1 = bufferization.to_memref %0 : memref<?xf32>
    %2 = torch_c.to_f64 %float-6.283190e00
    %3 = torch_c.to_i64 %int0
    %4 = arith.addi %3, %c1_i64 : i64
    %5 = arith.cmpi sge, %3, %c0_i64 : i64
    %6 = arith.select %5, %3, %4 : i64
    %7 = arith.cmpi sge, %6, %c0_i64 : i64
    cf.assert %7, "dim must be greater or equal to zero"
    %8 = arith.cmpi slt, %6, %c1_i64 : i64
    cf.assert %8, "dim must be smaller than inputRank"
    %9 = arith.index_cast %6 : i64 to index
    %10 = tensor.dim %0, %9 : tensor<?xf32>
    %11 = arith.index_cast %10 : index to i64
    %12 = torch_c.from_i64 %11
    %13 = torch_c.to_i64 %int0
    %14 = torch_c.to_i64 %int1
    %15 = arith.sitofp %13 : i64 to f32
    %16 = arith.sitofp %11 : i64 to f32
    %17 = arith.sitofp %14 : i64 to f32
    %18 = arith.subf %16, %15 : f32
    %19 = arith.divf %18, %17 : f32
    %20 = math.ceil %19 : f32
    %21 = arith.fptoui %20 : f32 to i64
    %22 = arith.index_cast %21 : i64 to index
    %23 = memref.alloc(%22) : memref<?xf32>
    affine.for %arg1 = 0 to %22 {
      %55 = arith.index_cast %arg1 : index to i64
      %56 = arith.sitofp %55 : i64 to f32
      %57 = arith.mulf %17, %56 : f32
      %58 = arith.addf %15, %57 : f32
      affine.store %58, %23[%arg1] : memref<?xf32>
    }
    %24 = bufferization.to_tensor %23 : memref<?xf32>
    %25 = torch_c.to_i64 %12
    %26 = torch_c.to_i64 %int1
    %27 = memref.expand_shape %23 [[0, 1]] : memref<?xf32> into memref<?x1xf32>
    %28 = bufferization.to_tensor %27 : memref<?x1xf32>
    %29 = tensor.dim %28, %c0 : tensor<?x1xf32>
    %30 = memref.alloc(%29) : memref<?x1xf32>
    %31 = memref.dim %27, %c0 : memref<?x1xf32>
    affine.for %arg1 = 0 to %31 {
      affine.for %arg2 = 0 to 1 {
        %55 = affine.load %27[%arg1, %c0] : memref<?x1xf32>
        %56 = arith.truncf %2 : f64 to f32
        %57 = arith.mulf %55, %56 : f32
        affine.store %57, %30[%arg1, %arg2] : memref<?x1xf32>
      }
    }
    %32 = bufferization.to_tensor %30 : memref<?x1xf32>
    %33 = tensor.dim %32, %c0 : tensor<?x1xf32>
    %34 = tensor.dim %24, %c0 : tensor<?xf32>
    %35 = memref.alloc(%33, %34) : memref<?x?xf32>
    affine.for %arg1 = 0 to %29 {
      affine.for %arg2 = 0 to %22 {
        %55 = affine.load %30[%arg1, %c0] : memref<?x1xf32>
        %56 = affine.load %23[%arg2] : memref<?xf32>
        %57 = arith.mulf %55, %56 : f32
        affine.store %57, %35[%arg1, %arg2] : memref<?x?xf32>
      }
    }
    %36 = bufferization.to_tensor %35 : memref<?x?xf32>
    %37 = tensor.dim %36, %c0 : tensor<?x?xf32>
    %38 = tensor.dim %36, %c1 : tensor<?x?xf32>
    %39 = memref.alloc(%37, %38) : memref<?x?xf32>
    affine.for %arg1 = 0 to %33 {
      affine.for %arg2 = 0 to %34 {
        %55 = affine.load %35[%arg1, %arg2] : memref<?x?xf32>
        %56 = arith.sitofp %11 : i64 to f32
        %57 = arith.divf %55, %56 : f32
        affine.store %57, %39[%arg1, %arg2] : memref<?x?xf32>
      }
    }
    %40 = bufferization.to_tensor %39 : memref<?x?xf32>
    %41 = tensor.dim %40, %c0 : tensor<?x?xf32>
    %42 = tensor.dim %40, %c1 : tensor<?x?xf32>
    %43 = memref.alloc(%41, %42) : memref<?x?xf32>
    affine.for %arg1 = 0 to %37 {
      affine.for %arg2 = 0 to %38 {
        %55 = affine.load %39[%arg1, %arg2] : memref<?x?xf32>
        %56 = math.exp %55 : f32
        affine.store %56, %43[%arg1, %arg2] : memref<?x?xf32>
      }
    }
    %44 = bufferization.to_tensor %43 : memref<?x?xf32>
    %45 = tensor.dim %44, %c0 : tensor<?x?xf32>
    %46 = tensor.dim %44, %c1 : tensor<?x?xf32>
    %47 = tensor.dim %0, %c0 : tensor<?xf32>
    %48 = arith.index_cast %46 : index to i64
    %49 = arith.index_cast %47 : index to i64
    %50 = arith.cmpi eq, %48, %49 : i64
    cf.assert %50, "mismatching contracting dimension"
    %51 = memref.alloc(%45) : memref<?xf32>
    affine.for %arg1 = 0 to %45 {
      affine.store %cst, %51[%arg1] : memref<?xf32>
    }
    %52 = memref.alloc(%45) : memref<?xf32>
    memref.copy %51, %52 : memref<?xf32> to memref<?xf32>
    affine.for %arg1 = 0 to %41 {
      affine.for %arg2 = 0 to %42 {
        %55 = affine.load %43[%arg1, %arg2] : memref<?x?xf32>
        %56 = affine.load %1[%arg2] : memref<?xf32>
        %57 = affine.load %52[%arg1] : memref<?xf32>
        %58 = arith.mulf %55, %56 : f32
        %59 = arith.addf %57, %58 : f32
        affine.store %59, %52[%arg1] : memref<?xf32>
      }
    }
    %53 = bufferization.to_tensor %52 : memref<?xf32>
    %54 = torch_c.from_builtin_tensor %53 : tensor<?xf32> -> !torch.vtensor<[?],f32>
    return %54 : !torch.vtensor<[?],f32>
  }
}

