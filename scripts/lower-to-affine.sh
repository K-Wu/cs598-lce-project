python3 convert.py | torch-mlir-opt --torch-func-backend-type-conversion \
    --torch-finalizing-backend-type-conversion --torch-refine-types --canonicalize \
    --linalg-bufferize --func-bufferize --buffer-results-to-out-params --refback-munge-memref-copy \
    --canonicalize --convert-linalg-to-affine-loops --fold-memref-subview-ops \
    --affine-loop-normalize --affine-simplify-structures
# TODO `tensor.expand_shape` not converted automatically
