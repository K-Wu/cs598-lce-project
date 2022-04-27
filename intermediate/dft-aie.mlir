module @forward attributes {torch.debug_module_name = "DftModule"} {
  %0 = memref.alloc() : memref<32xf32>
  %1 = memref.alloc() : memref<32xf32>
  %2 = memref.alloc() {alignment = 128 : i64} : memref<32xf32>
  %3 = memref.alloc() {alignment = 128 : i64} : memref<32x1xf32>
  %4 = memref.alloc() {alignment = 128 : i64} : memref<32x32xf32>
  %5 = memref.alloc() {alignment = 128 : i64} : memref<32x32xf32>
  %6 = memref.alloc() {alignment = 128 : i64} : memref<32x32xf32>
  %7 = memref.alloc() {alignment = 128 : i64} : memref<32xf32>
  %8 = memref.alloc() {alignment = 128 : i64} : memref<32xf32>
  %9 = memref.alloc() {alignment = 128 : i64} : memref<32x1xf32>
  %10 = AIE.tile(25, 3)
  %11 = AIE.buffer(%10) {polyaie.iter_num_buf, sym_name = "buf0"} : memref<1xi32>
  %12 = AIE.buffer(%10) {sym_name = "buf1"} : memref<32xf32>
  "dataflow.runtime.host_dma"(%12, %2) {kind = 1 : i64, offsets = [0], sizes = [32], strides = [1]} : (memref<32xf32>, memref<32xf32>) -> ()
  %13 = AIE.core(%10) {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %60 = memref.load %11[%c0] : memref<1xi32>
    %61 = arith.index_cast %60 : i32 to index
    scf.for %arg0 = %c0 to %61 step %c1 {
      %c2 = arith.constant 2 : index
      %62 = arith.remui %arg0, %c2 : index
      %c0_0 = arith.constant 0 : index
      %63 = arith.cmpi eq, %62, %c0_0 : index
      scf.if %63 {
        %cst = arith.constant 0.000000e+00 : f32
        affine.for %arg1 = 0 to 32 {
          %64 = arith.index_cast %arg1 : index to i64
          %65 = arith.sitofp %64 : i64 to f32
          %66 = arith.addf %65, %cst : f32
          affine.store %66, %12[%arg1] : memref<32xf32>
        }
      } else {
        %cst = arith.constant 0.000000e+00 : f32
        affine.for %arg1 = 0 to 32 {
          %64 = arith.index_cast %arg1 : index to i64
          %65 = arith.sitofp %64 : i64 to f32
          %66 = arith.addf %65, %cst : f32
          affine.store %66, %12[%arg1] : memref<32xf32>
        }
      }
    }
    AIE.end
  }
  %14 = AIE.tile(25, 5)
  %15 = AIE.buffer(%14) {polyaie.iter_num_buf, sym_name = "buf2"} : memref<1xi32>
  %16 = AIE.buffer(%14) {sym_name = "buf3"} : memref<32xf32>
  "dataflow.runtime.host_dma"(%16, %2) {kind = 1 : i64, offsets = [0], sizes = [32], strides = [1]} : (memref<32xf32>, memref<32xf32>) -> ()
  %17 = AIE.buffer(%14) {sym_name = "buf4"} : memref<32x1xf32>
  "dataflow.runtime.host_dma"(%17, %9) {kind = 1 : i64, offsets = [0, 0], sizes = [32, 1], strides = [1, 1]} : (memref<32x1xf32>, memref<32x1xf32>) -> ()
  %18 = AIE.core(%14) {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %60 = memref.load %15[%c0] : memref<1xi32>
    %61 = arith.index_cast %60 : i32 to index
    scf.for %arg0 = %c0 to %61 step %c1 {
      %c2 = arith.constant 2 : index
      %62 = arith.remui %arg0, %c2 : index
      %c0_0 = arith.constant 0 : index
      %63 = arith.cmpi eq, %62, %c0_0 : index
      scf.if %63 {
        affine.for %arg1 = 0 to 32 {
          %64 = affine.load %16[%arg1] : memref<32xf32>
          affine.store %64, %17[%arg1, 0] : memref<32x1xf32>
        }
      } else {
        affine.for %arg1 = 0 to 32 {
          %64 = affine.load %16[%arg1] : memref<32xf32>
          affine.store %64, %17[%arg1, 0] : memref<32x1xf32>
        }
      }
    }
    AIE.end
  }
  %19 = AIE.tile(24, 2)
  %20 = AIE.buffer(%19) {polyaie.iter_num_buf, sym_name = "buf5"} : memref<1xi32>
  %21 = AIE.buffer(%19) {sym_name = "buf6"} : memref<32x1xf32>
  "dataflow.runtime.host_dma"(%21, %9) {kind = 1 : i64, offsets = [0, 0], sizes = [32, 1], strides = [1, 1]} : (memref<32x1xf32>, memref<32x1xf32>) -> ()
  %22 = AIE.buffer(%19) {sym_name = "buf7"} : memref<32x1xf32>
  "dataflow.runtime.host_dma"(%22, %3) {kind = 1 : i64, offsets = [0, 0], sizes = [32, 1], strides = [1, 1]} : (memref<32x1xf32>, memref<32x1xf32>) -> ()
  %23 = AIE.core(%19) {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %60 = memref.load %20[%c0] : memref<1xi32>
    %61 = arith.index_cast %60 : i32 to index
    scf.for %arg0 = %c0 to %61 step %c1 {
      %c2 = arith.constant 2 : index
      %62 = arith.remui %arg0, %c2 : index
      %c0_0 = arith.constant 0 : index
      %63 = arith.cmpi eq, %62, %c0_0 : index
      scf.if %63 {
        %cst = arith.constant -6.2831853071795862 : f64
        affine.for %arg1 = 0 to 32 {
          %64 = affine.load %21[%arg1, 0] : memref<32x1xf32>
          %65 = arith.truncf %cst : f64 to f32
          %66 = arith.mulf %64, %65 : f32
          affine.store %66, %22[%arg1, 0] : memref<32x1xf32>
        }
      } else {
        %cst = arith.constant -6.2831853071795862 : f64
        affine.for %arg1 = 0 to 32 {
          %64 = affine.load %21[%arg1, 0] : memref<32x1xf32>
          %65 = arith.truncf %cst : f64 to f32
          %66 = arith.mulf %64, %65 : f32
          affine.store %66, %22[%arg1, 0] : memref<32x1xf32>
        }
      }
    }
    AIE.end
  }
  %24 = AIE.tile(26, 4)
  %25 = AIE.buffer(%24) {polyaie.iter_num_buf, sym_name = "buf8"} : memref<1xi32>
  %26 = AIE.buffer(%24) {sym_name = "buf9"} : memref<32x1xf32>
  "dataflow.runtime.host_dma"(%26, %3) {kind = 1 : i64, offsets = [0, 0], sizes = [32, 1], strides = [1, 1]} : (memref<32x1xf32>, memref<32x1xf32>) -> ()
  %27 = AIE.buffer(%24) {sym_name = "buf10"} : memref<32xf32>
  "dataflow.runtime.host_dma"(%27, %2) {kind = 1 : i64, offsets = [0], sizes = [32], strides = [1]} : (memref<32xf32>, memref<32xf32>) -> ()
  %28 = AIE.buffer(%24) {sym_name = "buf11"} : memref<32x32xf32>
  "dataflow.runtime.host_dma"(%28, %4) {kind = 1 : i64, offsets = [0, 0], sizes = [32, 32], strides = [1, 1]} : (memref<32x32xf32>, memref<32x32xf32>) -> ()
  %29 = AIE.core(%24) {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %60 = memref.load %25[%c0] : memref<1xi32>
    %61 = arith.index_cast %60 : i32 to index
    scf.for %arg0 = %c0 to %61 step %c1 {
      %c2 = arith.constant 2 : index
      %62 = arith.remui %arg0, %c2 : index
      %c0_0 = arith.constant 0 : index
      %63 = arith.cmpi eq, %62, %c0_0 : index
      scf.if %63 {
        affine.for %arg1 = 0 to 32 {
          affine.for %arg2 = 0 to 32 {
            %64 = affine.load %26[%arg1, 0] : memref<32x1xf32>
            %65 = affine.load %27[%arg2] : memref<32xf32>
            %66 = arith.mulf %64, %65 : f32
            affine.store %66, %28[%arg1, %arg2] : memref<32x32xf32>
          }
        }
      } else {
        affine.for %arg1 = 0 to 32 {
          affine.for %arg2 = 0 to 32 {
            %64 = affine.load %26[%arg1, 0] : memref<32x1xf32>
            %65 = affine.load %27[%arg2] : memref<32xf32>
            %66 = arith.mulf %64, %65 : f32
            affine.store %66, %28[%arg1, %arg2] : memref<32x32xf32>
          }
        }
      }
    }
    AIE.end
  }
  %30 = AIE.tile(24, 3)
  %31 = AIE.buffer(%30) {polyaie.iter_num_buf, sym_name = "buf12"} : memref<1xi32>
  %32 = AIE.buffer(%30) {sym_name = "buf13"} : memref<32x32xf32>
  "dataflow.runtime.host_dma"(%32, %4) {kind = 1 : i64, offsets = [0, 0], sizes = [32, 32], strides = [1, 1]} : (memref<32x32xf32>, memref<32x32xf32>) -> ()
  %33 = AIE.buffer(%30) {sym_name = "buf14"} : memref<32x32xf32>
  "dataflow.runtime.host_dma"(%33, %5) {kind = 1 : i64, offsets = [0, 0], sizes = [32, 32], strides = [1, 1]} : (memref<32x32xf32>, memref<32x32xf32>) -> ()
  %34 = AIE.core(%30) {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %60 = memref.load %31[%c0] : memref<1xi32>
    %61 = arith.index_cast %60 : i32 to index
    scf.for %arg0 = %c0 to %61 step %c1 {
      %c2 = arith.constant 2 : index
      %62 = arith.remui %arg0, %c2 : index
      %c0_0 = arith.constant 0 : index
      %63 = arith.cmpi eq, %62, %c0_0 : index
      scf.if %63 {
        %cst = arith.constant 3.200000e+01 : f32
        affine.for %arg1 = 0 to 32 {
          affine.for %arg2 = 0 to 32 {
            %64 = affine.load %32[%arg1, %arg2] : memref<32x32xf32>
            %65 = arith.divf %64, %cst : f32
            affine.store %65, %33[%arg1, %arg2] : memref<32x32xf32>
          }
        }
      } else {
        %cst = arith.constant 3.200000e+01 : f32
        affine.for %arg1 = 0 to 32 {
          affine.for %arg2 = 0 to 32 {
            %64 = affine.load %32[%arg1, %arg2] : memref<32x32xf32>
            %65 = arith.divf %64, %cst : f32
            affine.store %65, %33[%arg1, %arg2] : memref<32x32xf32>
          }
        }
      }
    }
    AIE.end
  }
  %35 = AIE.tile(26, 2)
  %36 = AIE.buffer(%35) {polyaie.iter_num_buf, sym_name = "buf15"} : memref<1xi32>
  %37 = AIE.buffer(%35) {sym_name = "buf16"} : memref<32x32xf32>
  "dataflow.runtime.host_dma"(%37, %5) {kind = 1 : i64, offsets = [0, 0], sizes = [32, 32], strides = [1, 1]} : (memref<32x32xf32>, memref<32x32xf32>) -> ()
  %38 = AIE.buffer(%35) {sym_name = "buf17"} : memref<32x32xf32>
  "dataflow.runtime.host_dma"(%38, %6) {kind = 1 : i64, offsets = [0, 0], sizes = [32, 32], strides = [1, 1]} : (memref<32x32xf32>, memref<32x32xf32>) -> ()
  %39 = AIE.core(%35) {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %60 = memref.load %36[%c0] : memref<1xi32>
    %61 = arith.index_cast %60 : i32 to index
    scf.for %arg0 = %c0 to %61 step %c1 {
      %c2 = arith.constant 2 : index
      %62 = arith.remui %arg0, %c2 : index
      %c0_0 = arith.constant 0 : index
      %63 = arith.cmpi eq, %62, %c0_0 : index
      scf.if %63 {
        affine.for %arg1 = 0 to 32 {
          affine.for %arg2 = 0 to 32 {
            %64 = affine.load %37[%arg1, %arg2] : memref<32x32xf32>
            %65 = math.exp %64 : f32
            affine.store %65, %38[%arg1, %arg2] : memref<32x32xf32>
          }
        }
      } else {
        affine.for %arg1 = 0 to 32 {
          affine.for %arg2 = 0 to 32 {
            %64 = affine.load %37[%arg1, %arg2] : memref<32x32xf32>
            %65 = math.exp %64 : f32
            affine.store %65, %38[%arg1, %arg2] : memref<32x32xf32>
          }
        }
      }
    }
    AIE.end
  }
  %40 = AIE.tile(25, 2)
  %41 = AIE.buffer(%40) {polyaie.iter_num_buf, sym_name = "buf18"} : memref<1xi32>
  %42 = AIE.buffer(%40) {sym_name = "buf19"} : memref<32xf32>
  "dataflow.runtime.host_dma"(%42, %7) {kind = 1 : i64, offsets = [0], sizes = [32], strides = [1]} : (memref<32xf32>, memref<32xf32>) -> ()
  %43 = AIE.core(%40) {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %60 = memref.load %41[%c0] : memref<1xi32>
    %61 = arith.index_cast %60 : i32 to index
    scf.for %arg0 = %c0 to %61 step %c1 {
      %c2 = arith.constant 2 : index
      %62 = arith.remui %arg0, %c2 : index
      %c0_0 = arith.constant 0 : index
      %63 = arith.cmpi eq, %62, %c0_0 : index
      scf.if %63 {
        %cst = arith.constant 0.000000e+00 : f32
        affine.for %arg1 = 0 to 32 {
          affine.store %cst, %42[%arg1] : memref<32xf32>
        }
      } else {
        %cst = arith.constant 0.000000e+00 : f32
        affine.for %arg1 = 0 to 32 {
          affine.store %cst, %42[%arg1] : memref<32xf32>
        }
      }
    }
    AIE.end
  }
  %44 = AIE.tile(25, 4)
  %45 = AIE.buffer(%44) {polyaie.iter_num_buf, sym_name = "buf20"} : memref<1xi32>
  %46 = AIE.buffer(%44) {sym_name = "buf21"} : memref<32xf32>
  "dataflow.runtime.host_dma"(%46, %7) {kind = 1 : i64, offsets = [0], sizes = [32], strides = [1]} : (memref<32xf32>, memref<32xf32>) -> ()
  %47 = AIE.buffer(%44) {sym_name = "buf22"} : memref<32xf32>
  "dataflow.runtime.host_dma"(%47, %8) {kind = 1 : i64, offsets = [0], sizes = [32], strides = [1]} : (memref<32xf32>, memref<32xf32>) -> ()
  %48 = AIE.core(%44) {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %60 = memref.load %45[%c0] : memref<1xi32>
    %61 = arith.index_cast %60 : i32 to index
    scf.for %arg0 = %c0 to %61 step %c1 {
      %c2 = arith.constant 2 : index
      %62 = arith.remui %arg0, %c2 : index
      %c0_0 = arith.constant 0 : index
      %63 = arith.cmpi eq, %62, %c0_0 : index
      scf.if %63 {
        affine.for %arg1 = 0 to 32 {
          %64 = affine.load %46[%arg1] : memref<32xf32>
          affine.store %64, %47[%arg1] : memref<32xf32>
        }
      } else {
        affine.for %arg1 = 0 to 32 {
          %64 = affine.load %46[%arg1] : memref<32xf32>
          affine.store %64, %47[%arg1] : memref<32xf32>
        }
      }
    }
    AIE.end
  }
  %49 = AIE.tile(23, 2)
  %50 = AIE.buffer(%49) {polyaie.iter_num_buf, sym_name = "buf23"} : memref<1xi32>
  %51 = AIE.buffer(%49) {sym_name = "buf24"} : memref<32x32xf32>
  "dataflow.runtime.host_dma"(%51, %6) {kind = 1 : i64, offsets = [0, 0], sizes = [32, 32], strides = [1, 1]} : (memref<32x32xf32>, memref<32x32xf32>) -> ()
  %52 = AIE.buffer(%49) {sym_name = "buf25"} : memref<32xf32>
  "dataflow.runtime.host_dma"(%52, %0) {kind = 1 : i64, offsets = [0], sizes = [32], strides = [1]} : (memref<32xf32>, memref<32xf32>) -> ()
  %53 = AIE.buffer(%49) {sym_name = "buf26"} : memref<32xf32>
  "dataflow.runtime.host_dma"(%53, %8) {kind = 1 : i64, offsets = [0], sizes = [32], strides = [1]} : (memref<32xf32>, memref<32xf32>) -> ()
  %54 = AIE.core(%49) {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %60 = memref.load %50[%c0] : memref<1xi32>
    %61 = arith.index_cast %60 : i32 to index
    scf.for %arg0 = %c0 to %61 step %c1 {
      %c2 = arith.constant 2 : index
      %62 = arith.remui %arg0, %c2 : index
      %c0_0 = arith.constant 0 : index
      %63 = arith.cmpi eq, %62, %c0_0 : index
      scf.if %63 {
        affine.for %arg1 = 0 to 32 {
          affine.for %arg2 = 0 to 32 {
            %64 = affine.load %51[%arg1, %arg2] : memref<32x32xf32>
            %65 = affine.load %52[%arg2] : memref<32xf32>
            %66 = affine.load %53[%arg1] : memref<32xf32>
            %67 = arith.mulf %64, %65 : f32
            %68 = arith.addf %66, %67 : f32
            affine.store %68, %53[%arg1] : memref<32xf32>
          }
        }
      } else {
        affine.for %arg1 = 0 to 32 {
          affine.for %arg2 = 0 to 32 {
            %64 = affine.load %51[%arg1, %arg2] : memref<32x32xf32>
            %65 = affine.load %52[%arg2] : memref<32xf32>
            %66 = affine.load %53[%arg1] : memref<32xf32>
            %67 = arith.mulf %64, %65 : f32
            %68 = arith.addf %66, %67 : f32
            affine.store %68, %53[%arg1] : memref<32xf32>
          }
        }
      }
    }
    AIE.end
  }
  %55 = AIE.tile(26, 3)
  %56 = AIE.buffer(%55) {polyaie.iter_num_buf, sym_name = "buf27"} : memref<1xi32>
  %57 = AIE.buffer(%55) {sym_name = "buf28"} : memref<32xf32>
  "dataflow.runtime.host_dma"(%57, %8) {kind = 1 : i64, offsets = [0], sizes = [32], strides = [1]} : (memref<32xf32>, memref<32xf32>) -> ()
  %58 = AIE.buffer(%55) {sym_name = "buf29"} : memref<32xf32>
  "dataflow.runtime.host_dma"(%58, %1) {kind = 1 : i64, offsets = [0], sizes = [32], strides = [1]} : (memref<32xf32>, memref<32xf32>) -> ()
  %59 = AIE.core(%55) {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %60 = memref.load %56[%c0] : memref<1xi32>
    %61 = arith.index_cast %60 : i32 to index
    scf.for %arg0 = %c0 to %61 step %c1 {
      %c2 = arith.constant 2 : index
      %62 = arith.remui %arg0, %c2 : index
      %c0_0 = arith.constant 0 : index
      %63 = arith.cmpi eq, %62, %c0_0 : index
      scf.if %63 {
        affine.for %arg1 = 0 to 32 {
          %64 = affine.load %57[%arg1] : memref<32xf32>
          affine.store %64, %58[%arg1] : memref<32xf32>
        }
      } else {
        affine.for %arg1 = 0 to 32 {
          %64 = affine.load %57[%arg1] : memref<32xf32>
          affine.store %64, %58[%arg1] : memref<32xf32>
        }
      }
    }
    AIE.end
  }
}

