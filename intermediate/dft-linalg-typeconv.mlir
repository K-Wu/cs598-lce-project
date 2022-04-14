#map0 = affine_map<(d0) -> (d0)>
#map1 = affine_map<(d0, d1) -> (d0, 0)>
#map2 = affine_map<(d0, d1) -> (d0, d1)>
#map3 = affine_map<(d0, d1) -> (d1)>
module attributes {torch.debug_module_name = "DftModule"} {
  func @forward(%arg0: tensor<?xf32>) -> tensor<?xf32> {
    %0 = torch_c.from_builtin_tensor %arg0 : tensor<?xf32> -> !torch.vtensor<[?],f32>
    %1 = torch_c.to_builtin_tensor %0 : !torch.vtensor<[?],f32> -> tensor<?xf32>
    %float-6.283190e00 = torch.constant.float -6.2831853071795862
    %2 = torch_c.to_f64 %float-6.283190e00
    %none = torch.constant.none
    %int6 = torch.constant.int 6
    %int0 = torch.constant.int 0
    %3 = torch_c.to_i64 %int0
    %int1 = torch.constant.int 1
    %c1_i64 = arith.constant 1 : i64
    %4 = arith.addi %3, %c1_i64 : i64
    %c0_i64 = arith.constant 0 : i64
    %5 = arith.cmpi sge, %3, %c0_i64 : i64
    %6 = arith.select %5, %3, %4 : i64
    %c0_i64_0 = arith.constant 0 : i64
    %7 = arith.cmpi sge, %6, %c0_i64_0 : i64
    cf.assert %7, "dim must be greater or equal to zero"
    %8 = arith.cmpi slt, %6, %c1_i64 : i64
    cf.assert %8, "dim must be smaller than inputRank"
    %9 = arith.index_cast %6 : i64 to index
    %10 = tensor.dim %1, %9 : tensor<?xf32>
    %11 = arith.index_cast %10 : index to i64
    %12 = torch_c.from_i64 %11
    %int0_1 = torch.constant.int 0
    %13 = torch_c.to_i64 %int0_1
    %int1_2 = torch.constant.int 1
    %14 = torch_c.to_i64 %int1_2
    %15 = arith.sitofp %13 : i64 to f32
    %16 = arith.sitofp %11 : i64 to f32
    %17 = arith.sitofp %14 : i64 to f32
    %18 = arith.subf %16, %15 : f32
    %19 = arith.divf %18, %17 : f32
    %20 = math.ceil %19 : f32
    %21 = arith.fptoui %20 : f32 to i64
    %22 = arith.index_cast %21 : i64 to index
    %23 = linalg.init_tensor [%22] : tensor<?xf32>
    %24 = linalg.generic {indexing_maps = [#map0], iterator_types = ["parallel"]} outs(%23 : tensor<?xf32>) {
    ^bb0(%arg1: f32):
      %64 = linalg.index 0 : index
      %65 = arith.index_cast %64 : index to i64
      %66 = arith.sitofp %65 : i64 to f32
      %67 = arith.mulf %17, %66 : f32
      %68 = arith.addf %15, %67 : f32
      linalg.yield %68 : f32
    } -> tensor<?xf32>
    %25 = tensor.cast %24 : tensor<?xf32> to tensor<?xf32>
    %26 = torch.prim.ListConstruct %12, %int1 : (!torch.int, !torch.int) -> !torch.list<!torch.int>
    %27 = torch_c.to_i64 %12
    %28 = torch_c.to_i64 %int1
    %c0 = arith.constant 0 : index
    %29 = tensor.dim %24, %c0 : tensor<?xf32>
    %30 = tensor.cast %25 : tensor<?xf32> to tensor<?xf32>
    %31 = tensor.expand_shape %30 [[0, 1]] : tensor<?xf32> into tensor<?x1xf32>
    %32 = tensor.cast %31 : tensor<?x1xf32> to tensor<?x1xf32>
    %c1 = arith.constant 1 : index
    %c0_3 = arith.constant 0 : index
    %33 = tensor.dim %31, %c0_3 : tensor<?x1xf32>
    %34 = linalg.init_tensor [%33, 1] : tensor<?x1xf32>
    %35 = linalg.generic {indexing_maps = [#map1, #map2], iterator_types = ["parallel", "parallel"]} ins(%32 : tensor<?x1xf32>) outs(%34 : tensor<?x1xf32>) {
    ^bb0(%arg1: f32, %arg2: f32):
      %64 = arith.truncf %2 : f64 to f32
      %65 = arith.mulf %arg1, %64 : f32
      linalg.yield %65 : f32
    } -> tensor<?x1xf32>
    %36 = tensor.cast %35 : tensor<?x1xf32> to tensor<?x1xf32>
    %c1_4 = arith.constant 1 : index
    %c0_5 = arith.constant 0 : index
    %37 = tensor.dim %35, %c0_5 : tensor<?x1xf32>
    %c0_6 = arith.constant 0 : index
    %38 = tensor.dim %24, %c0_6 : tensor<?xf32>
    %39 = linalg.init_tensor [%37, %38] : tensor<?x?xf32>
    %40 = linalg.generic {indexing_maps = [#map1, #map3, #map2], iterator_types = ["parallel", "parallel"]} ins(%36, %25 : tensor<?x1xf32>, tensor<?xf32>) outs(%39 : tensor<?x?xf32>) {
    ^bb0(%arg1: f32, %arg2: f32, %arg3: f32):
      %64 = arith.mulf %arg1, %arg2 : f32
      linalg.yield %64 : f32
    } -> tensor<?x?xf32>
    %41 = tensor.cast %40 : tensor<?x?xf32> to tensor<?x?xf32>
    %c1_7 = arith.constant 1 : index
    %c0_8 = arith.constant 0 : index
    %42 = tensor.dim %40, %c0_8 : tensor<?x?xf32>
    %c1_9 = arith.constant 1 : index
    %43 = tensor.dim %40, %c1_9 : tensor<?x?xf32>
    %44 = linalg.init_tensor [%42, %43] : tensor<?x?xf32>
    %45 = linalg.generic {indexing_maps = [#map2, #map2], iterator_types = ["parallel", "parallel"]} ins(%41 : tensor<?x?xf32>) outs(%44 : tensor<?x?xf32>) {
    ^bb0(%arg1: f32, %arg2: f32):
      %64 = arith.sitofp %11 : i64 to f32
      %65 = arith.divf %arg1, %64 : f32
      linalg.yield %65 : f32
    } -> tensor<?x?xf32>
    %46 = tensor.cast %45 : tensor<?x?xf32> to tensor<?x?xf32>
    %c1_10 = arith.constant 1 : index
    %c0_11 = arith.constant 0 : index
    %47 = tensor.dim %45, %c0_11 : tensor<?x?xf32>
    %c1_12 = arith.constant 1 : index
    %48 = tensor.dim %45, %c1_12 : tensor<?x?xf32>
    %49 = linalg.init_tensor [%47, %48] : tensor<?x?xf32>
    %50 = linalg.generic {indexing_maps = [#map2, #map2], iterator_types = ["parallel", "parallel"]} ins(%46 : tensor<?x?xf32>) outs(%49 : tensor<?x?xf32>) {
    ^bb0(%arg1: f32, %arg2: f32):
      %64 = math.exp %arg1 : f32
      linalg.yield %64 : f32
    } -> tensor<?x?xf32>
    %51 = tensor.cast %50 : tensor<?x?xf32> to tensor<?x?xf32>
    %c0_13 = arith.constant 0 : index
    %52 = tensor.dim %50, %c0_13 : tensor<?x?xf32>
    %c1_14 = arith.constant 1 : index
    %53 = tensor.dim %50, %c1_14 : tensor<?x?xf32>
    %c0_15 = arith.constant 0 : index
    %54 = tensor.dim %1, %c0_15 : tensor<?xf32>
    %55 = arith.index_cast %53 : index to i64
    %56 = arith.index_cast %54 : index to i64
    %57 = arith.cmpi eq, %55, %56 : i64
    cf.assert %57, "mismatching contracting dimension"
    %58 = linalg.init_tensor [%52] : tensor<?xf32>
    %cst = arith.constant 0.000000e+00 : f32
    %59 = linalg.fill(%cst, %58) : f32, tensor<?xf32> -> tensor<?xf32> 
    %60 = linalg.matvec ins(%51, %1 : tensor<?x?xf32>, tensor<?xf32>) outs(%59 : tensor<?xf32>) -> tensor<?xf32>
    %61 = tensor.cast %60 : tensor<?xf32> to tensor<?xf32>
    %62 = torch_c.from_builtin_tensor %61 : tensor<?xf32> -> !torch.vtensor<[?],f32>
    %63 = torch_c.to_builtin_tensor %62 : !torch.vtensor<[?],f32> -> tensor<?xf32>
    return %63 : tensor<?xf32>
  }
}

