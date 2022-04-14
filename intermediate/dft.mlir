module attributes {torch.debug_module_name = "DftModule"} {
  func @forward(%arg0: !torch.vtensor<[?],f32>) -> !torch.vtensor<[?],unk> {
    %false = torch.constant.bool false
    %float-6.283190e00 = torch.constant.float -6.2831853071795862
    %cc = torch.constant.complex %float-6.283190e00, %float-6.283190e00
    %none = torch.constant.none
    %int9 = torch.constant.int 9
    %int0 = torch.constant.int 0
    %int1 = torch.constant.int 1
    %0 = torch.aten.size.int %arg0, %int0 : !torch.vtensor<[?],f32>, !torch.int -> !torch.int
    %int0_0 = torch.constant.int 0
    %int1_1 = torch.constant.int 1
    %1 = torch.aten.arange.start_step %int0_0, %0, %int1_1, %int9, %none, %none, %none : !torch.int, !torch.int, !torch.int, !torch.int, !torch.none, !torch.none, !torch.none -> !torch.vtensor<[?],unk>
    %2 = torch.prim.ListConstruct %0, %int1 : (!torch.int, !torch.int) -> !torch.list<int>
    %3 = torch.aten.view %1, %2 : !torch.vtensor<[?],unk>, !torch.list<int> -> !torch.vtensor<[?,1],unk>
    %4 = torch.aten.mul.Scalar %3, %cc : !torch.vtensor<[?,1],unk>, !torch.float -> !torch.vtensor<[?,1],unk>
    %5 = torch.aten.mul.Tensor %4, %1 : !torch.vtensor<[?,1],unk>, !torch.vtensor<[?],unk> -> !torch.vtensor<[?,?],unk>
    %6 = torch.aten.div.Scalar %5, %0 : !torch.vtensor<[?,?],unk>, !torch.int -> !torch.vtensor<[?,?],unk>
    %7 = torch.aten.exp %6 : !torch.vtensor<[?,?],unk> -> !torch.vtensor<[?,?],unk>
    %8 = torch.aten.to.dtype %7, %int9, %false, %false, %none : !torch.vtensor<[?,?],unk>, !torch.int, !torch.bool, !torch.bool, !torch.none -> !torch.vtensor<[?,?],unk>
    %9 = torch.aten.to.dtype %arg0, %int9, %false, %false, %none : !torch.vtensor<[?],f32>, !torch.int, !torch.bool, !torch.bool, !torch.none -> !torch.vtensor<[?],unk>
    %10 = torch.aten.matmul %8, %9 : !torch.vtensor<[?,?],unk>, !torch.vtensor<[?],unk> -> !torch.vtensor<[?],unk>
    return %10 : !torch.vtensor<[?],unk>
  }
}
