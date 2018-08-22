import strutils
const sourcePath = currentSourcePath().split({'\\', '/'})[0..^2].join("/")
{.passC: "-I\"" & sourcePath & "headers\"".}
const headermat = sourcePath & "headers/core/mat.hpp"

import types

const
  ACCESS_READ* = 1 shl 24
  ACCESS_WRITE* = 1 shl 25
  ACCESS_RW* = 3 shl 24
  ACCESS_MASK* = ACCESS_RW
  ACCESS_FAST* = 1 shl 26

const
  MAGIC_VAL* = 0x42FF0000
  AUTO_STEP* = 0
  CONTINUOUS_FLAG* = (1 shl 14)
  SUBMATRIX_FLAG* = (1 shl 15)

const
  MAGIC_MASK* = 0xFFFF0000
  TYPE_MASK* = 0x00000FFF
  DEPTH_MASK* = 7

const
  MAX_DIM* = 32
  HASH_SCALE* = 0x5BD1E995
  HASH_BIT* = 0x80000000


type
  UMatUsageFlags* {.size: sizeof(cint), importcpp: "cv::UMatUsageFlags",
                   header: headermat.} = enum
    USAGE_DEFAULT = 0, USAGE_ALLOCATE_HOST_MEMORY = 1 shl 0,
    USAGE_ALLOCATE_DEVICE_MEMORY = 1 shl 1, USAGE_ALLOCATE_SHARED_MEMORY = 1 shl 2,
    UMAT_USAGE_FLAGS_32BIT = 0x7FFFFFFF


discard "forward decl of UMatData"
type
  MatAllocator* {.importcpp: "cv::MatAllocator", header: headermat, bycopy.} = object
  UMatData* {.importcpp: "cv::UMatData", header: headermat, bycopy.} = object
    prevAllocator* {.importc: "prevAllocator".}: ptr MatAllocator
    currAllocator* {.importc: "currAllocator".}: ptr MatAllocator
    urefcount* {.importc: "urefcount".}: cint
    refcount* {.importc: "refcount".}: cint
    data* {.importc: "data".}: ptr byte 
    origdata* {.importc: "origdata".}: ptr byte
    size* {.importc: "size".}: csize
    flags* {.importc: "flags".}: cint
    handle* {.importc: "handle".}: pointer
    userdata* {.importc: "userdata".}: pointer
    allocatorFlags* {.importc: "allocatorFlags_".}: cint
    mapcount* {.importc: "mapcount".}: cint
    originalUMatData* {.importc: "originalUMatData".}: ptr UMatData
  MatCommaInitializer* {.importcpp: "cv::MatCommaInitializer_", header: headermat,
                        bycopy.}[Tp] = object
  MatStep* {.importcpp: "cv::MatStep", header: headermat, bycopy.} = object
    p* {.importc: "p".}: ptr csize
    buf* {.importc: "buf".}: array[2, csize]
  MatSize* {.importcpp: "cv::MatSize", header: headermat, bycopy.} = object
    p* {.importc: "p".}: ptr cint
  MatBase* {.importcpp: "cv::Mat", header: headermat, bycopy.} = object of RootObj
    flags* {.importc: "flags".}: cint
    dims* {.importc: "dims".}: cint
    rows* {.importc: "rows".}: cint
    cols* {.importc: "cols".}: cint
    data* {.importc: "data".}: ptr byte
    datastart* {.importc: "datastart".}: ptr byte
    dataend* {.importc: "dataend".}: ptr byte
    datalimit* {.importc: "datalimit".}: ptr byte
    allocator* {.importc: "allocator".}: ptr MatAllocator
    u* {.importc: "u".}: ptr UMatData
    size* {.importc: "size".}: MatSize
    step* {.importc: "step".}: MatStep
  Mat* {.importcpp: "cv::Mat_", header: headermat, bycopy.}[Tp] = object of MatBase
  UMat* {.importcpp: "cv::UMat", header: headermat, bycopy.} = object
    flags* {.importc: "flags".}: cint
    dims* {.importc: "dims".}: cint
    rows* {.importc: "rows".}: cint
    cols* {.importc: "cols".}: cint
    allocator* {.importc: "allocator".}: ptr MatAllocator
    usageFlags* {.importc: "usageFlags".}: UMatUsageFlags
    u* {.importc: "u".}: ptr UMatData
    offset* {.importc: "offset".}: csize
    size* {.importc: "size".}: MatSize
    step* {.importc: "step".}: MatStep
  MatOp* {.importcpp: "cv::MatOp", header: headermat, bycopy.} = object
  MatExpr* {.importcpp: "cv::MatExpr", header: headermat, bycopy.} = object
    op* {.importc: "op".}: ptr MatOp
    flags* {.importc: "flags".}: cint
    a* {.importc: "a".}: MatBase
    b* {.importc: "b".}: MatBase
    c* {.importc: "c".}: MatBase
    alpha* {.importc: "alpha".}: cdouble
    beta* {.importc: "beta".}: cdouble
    s* {.importc: "s".}: Scalar[cdouble]

  Hdr* {.importcpp: "cv::Hdr", header: headermat, bycopy.} = object
    refcount* {.importc: "refcount".}: cint
    dims* {.importc: "dims".}: cint
    valueOffset* {.importc: "valueOffset".}: cint
    nodeSize* {.importc: "nodeSize".}: csize
    nodeCount* {.importc: "nodeCount".}: csize
    freeList* {.importc: "freeList".}: csize
    pool* {.importc: "pool".}: Vector[byte]
    hashtab* {.importc: "hashtab".}: Vector[csize]
    size* {.importc: "size".}: array[MAX_DIM, cint]

  SparseMat* {.importcpp: "cv::SparseMat", header: headermat, bycopy.} = object
    flags* {.importc: "flags".}: cint
    hdr* {.importc: "hdr".}: ptr Hdr

  SparseMatConstIterator* {.importcpp: "cv::SparseMatConstIterator",
                           header: headermat, bycopy.} = object
    m* {.importc: "m".}: ptr SparseMat
    hashidx* {.importc: "hashidx".}: csize
    `ptr`* {.importc: "ptr".}: ptr byte

  # SparseMatIterator* {.importcpp: "cv::SparseMatIterator", header: headermat, bycopy.} = object of SparseMatConstIterator
  # SparseMatIterator* {.importcpp: "cv::SparseMatIterator_", header: headermat, bycopy.}[Tp] = object of SparseMatConstIterator[Tp]
  
  # IteratorCategory* = ForwardIteratorTag
  # Iterator* = SparseMatIterator
  # ConstIterator* = SparseMatConstIterator
  

  # MatConstIterator* {.importcpp: "cv::MatConstIterator", header: headermat, bycopy.} = object
  #   m* {.importc: "m".}: ptr Mat
  #   elemSize* {.importc: "elemSize".}: csize
  #   `ptr`* {.importc: "ptr".}: ptr byte
  #   sliceStart* {.importc: "sliceStart".}: ptr byte
  #   sliceEnd* {.importc: "sliceEnd".}: ptr byte

  # MatIterator* {.importcpp: "cv::MatIterator_", header: headermat, bycopy.}[Tp] = object of MatConstIterator[Tp]
  # ConstIterator* = MatConstIterator[Tp]

proc constructMatAllocator*(): MatAllocator {.constructor,
    importcpp: "cv::MatAllocator(@)", header: headermat.}
proc destroyMatAllocator*(this: var MatAllocator) {.importcpp: "#.~MatAllocator()",
    header: headermat.}
proc allocate*(this: MatAllocator; dims: cint; sizes: ptr cint; `type`: cint;
              data: pointer; step: ptr csize; flags: cint; usageFlags: UMatUsageFlags): ptr UMatData {.
    noSideEffect, importcpp: "allocate", header: headermat.}
proc allocate*(this: MatAllocator; data: ptr UMatData; accessflags: cint;
              usageFlags: UMatUsageFlags): bool {.noSideEffect,
    importcpp: "allocate", header: headermat.}
proc deallocate*(this: MatAllocator; data: ptr UMatData) {.noSideEffect,
    importcpp: "deallocate", header: headermat.}
proc map*(this: MatAllocator; data: ptr UMatData; accessflags: cint) {.noSideEffect,
    importcpp: "map", header: headermat.}
proc unmap*(this: MatAllocator; data: ptr UMatData) {.noSideEffect, importcpp: "unmap",
    header: headermat.}
proc download*(this: MatAllocator; data: ptr UMatData; dst: pointer; dims: cint;
              sz: ptr csize; srcofs: ptr csize; srcstep: ptr csize; dststep: ptr csize) {.
    noSideEffect, importcpp: "download", header: headermat.}
proc upload*(this: MatAllocator; data: ptr UMatData; src: pointer; dims: cint;
            sz: ptr csize; dstofs: ptr csize; dststep: ptr csize; srcstep: ptr csize) {.
    noSideEffect, importcpp: "upload", header: headermat.}
proc copy*(this: MatAllocator; srcdata: ptr UMatData; dstdata: ptr UMatData; dims: cint;
          sz: ptr csize; srcofs: ptr csize; srcstep: ptr csize; dstofs: ptr csize;
          dststep: ptr csize; sync: bool) {.noSideEffect, importcpp: "copy",
                                       header: headermat.}
# proc getBufferPoolController*(this: MatAllocator; id: cstring = nil): ptr BufferPoolController {.
#     noSideEffect, importcpp: "getBufferPoolController", header: headermat.}


proc constructMatCommaInitializer*[Tp](m: ptr Mat[Tp]): MatCommaInitializer[Tp] {.
    constructor, importcpp: "cv::MatCommaInitializer_(@)", header: headermat.}
proc `comma`*[Tp; T2](this: var MatCommaInitializer[Tp]; v: T2): var MatCommaInitializer[Tp] {.
    importcpp: "#,@", header: headermat.}
converter `mat`*[Tp](this: MatCommaInitializer[Tp]): Mat[Tp] {.noSideEffect,
    importcpp: "MatCommaInitializer_::operator Mat_", header: headermat.}

const
  COPY_ON_MAP* = 1
  HOST_COPY_OBSOLETE* = 2
  DEVICE_COPY_OBSOLETE* = 4
  TEMP_UMAT* = 8
  TEMP_COPIED_UMAT* = 24
  USER_ALLOCATED* = 32
  DEVICE_MEM_MAPPED* = 64
  ASYNC_CLEANUP* = 128

proc constructUMatData*(allocator: ptr MatAllocator): UMatData {.constructor,
    importcpp: "cv::UMatData(@)", header: headermat.}
proc destroyUMatData*(this: var UMatData) {.importcpp: "#.~UMatData()",
                                        header: headermat.}
proc lock*(this: var UMatData) {.importcpp: "lock", header: headermat.}
proc unlock*(this: var UMatData) {.importcpp: "unlock", header: headermat.}
proc hostCopyObsolete*(this: UMatData): bool {.noSideEffect,
    importcpp: "hostCopyObsolete", header: headermat.}
proc deviceCopyObsolete*(this: UMatData): bool {.noSideEffect,
    importcpp: "deviceCopyObsolete", header: headermat.}
proc deviceMemMapped*(this: UMatData): bool {.noSideEffect,
    importcpp: "deviceMemMapped", header: headermat.}
proc copyOnMap*(this: UMatData): bool {.noSideEffect, importcpp: "copyOnMap",
                                    header: headermat.}
proc tempUMat*(this: UMatData): bool {.noSideEffect, importcpp: "tempUMat",
                                   header: headermat.}
proc tempCopiedUMat*(this: UMatData): bool {.noSideEffect,
    importcpp: "tempCopiedUMat", header: headermat.}
proc markHostCopyObsolete*(this: var UMatData; flag: bool) {.
    importcpp: "markHostCopyObsolete", header: headermat.}
proc markDeviceCopyObsolete*(this: var UMatData; flag: bool) {.
    importcpp: "markDeviceCopyObsolete", header: headermat.}
proc markDeviceMemMapped*(this: var UMatData; flag: bool) {.
    importcpp: "markDeviceMemMapped", header: headermat.}


proc constructMatSize*(p: ptr cint): MatSize {.constructor,
    importcpp: "cv::MatSize(@)", header: headermat.}

{.experimental: "callOperator".}
proc `()`*(this: MatSize): Size {.noSideEffect, importcpp: "#(@)", header: headermat.}
proc `[]`*(this: MatSize; i: cint): cint {.noSideEffect, importcpp: "#[@]",
                                     header: headermat.}
proc `[]`*(this: var MatSize; i: cint): var cint {.importcpp: "#[@]", header: headermat.}
converter `constint*`*(this: MatSize): ptr cint {.noSideEffect,
    importcpp: "MatSize::operator constint*", header: headermat.}
proc `==`*(this: MatSize; sz: MatSize): bool {.noSideEffect, importcpp: "(# == #)",
    header: headermat.}

proc constructMatStep*(): MatStep {.constructor, importcpp: "cv::MatStep(@)",
                                 header: headermat.}
proc constructMatStep*(s: csize): MatStep {.constructor, importcpp: "cv::MatStep(@)",
                                        header: headermat.}
proc `[]`*(this: MatStep; i: cint): csize {.noSideEffect, importcpp: "#[@]",
                                      header: headermat.}
proc `[]`*(this: var MatStep; i: cint): var csize {.importcpp: "#[@]", header: headermat.}
converter `sizeT`*(this: MatStep): csize {.noSideEffect,
                                       importcpp: "MatStep::operator size_t",
                                       header: headermat.}

proc constructMat*(): MatBase {.constructor, importcpp: "cv::Mat(@)", header: headermat.}
proc constructMat*(rows: cint; cols: cint; `type`: cint): MatBase {.constructor,
    importcpp: "cv::Mat(@)", header: headermat.}
proc constructMat*(size: Size; `type`: cint): MatBase {.constructor,
    importcpp: "cv::Mat(@)", header: headermat.}
proc constructMat*(rows: cint; cols: cint; `type`: cint; s: Scalar): MatBase {.constructor,
    importcpp: "cv::Mat(@)", header: headermat.}
proc constructMat*(size: Size; `type`: cint; s: Scalar): MatBase {.constructor,
    importcpp: "cv::Mat(@)", header: headermat.}
proc constructMat*(ndims: cint; sizes: ptr cint; `type`: cint): MatBase {.constructor,
    importcpp: "cv::Mat(@)", header: headermat.}
proc constructMat*(sizes: Vector[cint]; `type`: cint): MatBase {.constructor,
    importcpp: "cv::Mat(@)", header: headermat.}
proc constructMat*(ndims: cint; sizes: ptr cint; `type`: cint; s: Scalar): MatBase {.
    constructor, importcpp: "cv::Mat(@)", header: headermat.}
proc constructMat*(sizes: Vector[cint]; `type`: cint; s: Scalar): MatBase {.constructor,
    importcpp: "cv::Mat(@)", header: headermat.}
proc constructMat*(m: MatBase): MatBase {.constructor, importcpp: "cv::Mat(@)",
                              header: headermat.}
proc constructMat*(rows: cint; cols: cint; `type`: cint; data: pointer;
                  step: csize = AUTO_STEP): MatBase {.constructor,
    importcpp: "cv::Mat(@)", header: headermat.}
proc constructMat*(size: Size; `type`: cint; data: pointer; step: csize = AUTO_STEP): MatBase {.
    constructor, importcpp: "cv::Mat(@)", header: headermat.}
proc constructMat*(ndims: cint; sizes: ptr cint; `type`: cint; data: pointer;
                  steps: ptr csize = nil): MatBase {.constructor, importcpp: "cv::Mat(@)",
    header: headermat.}
proc constructMat*(sizes: Vector[cint]; `type`: cint; data: pointer;
                  steps: ptr csize = nil): Mat {.constructor, importcpp: "cv::Mat(@)",
    header: headermat.}
proc constructMat*(m: MatBase; rowRange: Range; colRange: Range = all()): MatBase {.constructor,
    importcpp: "cv::Mat(@)", header: headermat.}
proc constructMat*(m: MatBase; roi: Rect): MatBase {.constructor, importcpp: "cv::Mat(@)",
                                       header: headermat.}
proc constructMat*(m: MatBase; ranges: ptr Range): MatBase {.constructor,
    importcpp: "cv::Mat(@)", header: headermat.}
proc constructMat*(m: MatBase; ranges: Vector[Range]): MatBase {.constructor,
    importcpp: "cv::Mat(@)", header: headermat.}
proc constructMatBase*[Tp](vec: Vector[Tp]; copyData: bool = false): MatBase {.constructor,
    importcpp: "cv::Mat(@)", header: headermat.}
proc constructMat*[Tp; N: static[cint]](vec: Vec[Tp, N]; copyData: bool = true): MatBase {.
    constructor, importcpp: "cv::Mat(@)", header: headermat.}
# proc constructMat*[Tp; M: static[cint]; N: static[cint]](mtx: Matx[Tp, M, N];
#     copyData: bool = true): MatBase {.constructor, importcpp: "cv::Mat(@)",
#                              header: headermat.}
proc constructMat*[Tp](pt: Point[Tp]; copyData: bool = true): MatBase {.constructor,
    importcpp: "cv::Mat(@)", header: headermat.}
proc constructMat*[Tp](pt: Point3[Tp]; copyData: bool = true): MatBase {.constructor,
    importcpp: "cv::Mat(@)", header: headermat.}
proc constructMatBase*[Tp](commaInitializer: MatCommaInitializer[Tp]): MatBase {.
    constructor, importcpp: "cv::Mat(@)", header: headermat.}
# proc constructMat*(m: GpuMat): MatBase {.constructor, importcpp: "cv::Mat(@)",
#                                  header: headermat.}
proc destroyMat*(this: var MatBase) {.importcpp: "#.~Mat()", header: headermat.}
proc getUMat*(this: MatBase; accessFlags: cint;
             usageFlags: UMatUsageFlags = USAGE_DEFAULT): UMat {.noSideEffect,
    importcpp: "getUMat", header: headermat.}
proc row*(this: MatBase; y: cint): MatBase {.noSideEffect, importcpp: "row", header: headermat.}
proc col*(this: MatBase; x: cint): MatBase {.noSideEffect, importcpp: "col", header: headermat.}
proc rowRange*(this: MatBase; startrow: cint; endrow: cint): MatBase {.noSideEffect,
    importcpp: "rowRange", header: headermat.}
proc rowRange*(this: MatBase; r: Range): MatBase {.noSideEffect, importcpp: "rowRange",
                                     header: headermat.}
proc colRange*(this: MatBase; startcol: cint; endcol: cint): MatBase {.noSideEffect,
    importcpp: "colRange", header: headermat.}
proc colRange*(this: MatBase; r: Range): MatBase {.noSideEffect, importcpp: "colRange",
                                     header: headermat.}
proc diag*(this: MatBase; d: cint = 0): MatBase {.noSideEffect, importcpp: "diag",
                                  header: headermat.}
proc diag*(d: MatBase): MatBase {.importcpp: "cv::Mat::diag(@)", header: headermat.}
proc clone*(this: MatBase): MatBase {.noSideEffect, importcpp: "clone", header: headermat.}
# proc copyTo*(this: MatBase; m: OutputArray) {.noSideEffect, importcpp: "copyTo",
#                                      header: headermat.}
# proc copyTo*(this: MatBase; m: OutputArray; mask: InputArray) {.noSideEffect,
#     importcpp: "copyTo", header: headermat.}
# proc convertTo*(this: MatBase; m: OutputArray; rtype: cint; alpha: cdouble = 1;
#                beta: cdouble = 0) {.noSideEffect, importcpp: "convertTo",
#                                 header: headermat.}
proc assignTo*(this: MatBase; m: var MatBase; `type`: cint = -1) {.noSideEffect,
    importcpp: "assignTo", header: headermat.}
# proc setTo*(this: var MatBase; value: InputArray; mask: InputArray = noArray()): var MatBase {.
#     importcpp: "setTo", header: headermat.}
proc reshape*(this: MatBase; cn: cint; rows: cint = 0): MatBase {.noSideEffect,
    importcpp: "reshape", header: headermat.}
proc reshape*(this: MatBase; cn: cint; newndims: cint; newsz: ptr cint): MatBase {.noSideEffect,
    importcpp: "reshape", header: headermat.}
proc reshape*(this: MatBase; cn: cint; newshape: Vector[cint]): MatBase {.noSideEffect,
    importcpp: "reshape", header: headermat.}
proc t*(this: MatBase): MatExpr {.noSideEffect, importcpp: "t", header: headermat.}
# proc inv*(this: MatBase; `method`: cint = decomp_Lu): MatExpr {.noSideEffect,
#     importcpp: "inv", header: headermat.}
# proc mul*(this: MatBase; m: InputArray; scale: cdouble = 1): MatExpr {.noSideEffect,
#     importcpp: "mul", header: headermat.}
# proc cross*(this: MatBase; m: InputArray): MatBase {.noSideEffect, importcpp: "cross",
#                                        header: headermat.}
# proc dot*(this: MatBase; m: InputArray): cdouble {.noSideEffect, importcpp: "dot",
#     header: headermat.}
# proc zeros*(rows: cint; cols: cint; `type`: cint): MatExpr {.
#     importcpp: "cv::Mat::zeros(@)", header: headermat.}
# proc zeros*(size: Size; `type`: cint): MatExpr {.importcpp: "cv::Mat::zeros(@)",
#     header: headermat.}
# proc zeros*(ndims: cint; sz: ptr cint; `type`: cint): MatExpr {.
#     importcpp: "cv::Mat::zeros(@)", header: headermat.}
proc ones*(rows: cint; cols: cint; `type`: cint): MatExpr {.
    importcpp: "cv::Mat::ones(@)", header: headermat.}
proc ones*(size: Size; `type`: cint): MatExpr {.importcpp: "cv::Mat::ones(@)",
    header: headermat.}
proc ones*(ndims: cint; sz: ptr cint; `type`: cint): MatExpr {.
    importcpp: "cv::Mat::ones(@)", header: headermat.}
proc eye*(rows: cint; cols: cint; `type`: cint): MatExpr {.importcpp: "cv::Mat::eye(@)",
    header: headermat.}
proc eye*(size: Size; `type`: cint): MatExpr {.importcpp: "cv::Mat::eye(@)",
    header: headermat.}
proc create*(this: var MatBase; rows: cint; cols: cint; `type`: cint) {.importcpp: "create",
    header: headermat.}
proc create*(this: var MatBase; size: Size; `type`: cint) {.importcpp: "create",
    header: headermat.}
proc create*(this: var MatBase; ndims: cint; sizes: ptr cint; `type`: cint) {.
    importcpp: "create", header: headermat.}
proc create*(this: var MatBase; sizes: Vector[cint]; `type`: cint) {.importcpp: "create",
    header: headermat.}
proc addref*(this: var MatBase) {.importcpp: "addref", header: headermat.}
proc release*(this: var MatBase) {.importcpp: "release", header: headermat.}
proc deallocate*(this: var MatBase) {.importcpp: "deallocate", header: headermat.}
proc copySize*(this: var MatBase; m: MatBase) {.importcpp: "copySize", header: headermat.}
proc reserve*(this: var MatBase; sz: csize) {.importcpp: "reserve", header: headermat.}
proc reserveBuffer*(this: var MatBase; sz: csize) {.importcpp: "reserveBuffer",
    header: headermat.}
proc resize*(this: var MatBase; sz: csize) {.importcpp: "resize", header: headermat.}
proc resize*(this: var MatBase; sz: csize; s: Scalar) {.importcpp: "resize", header: headermat.}
proc pushBack*(this: var MatBase; elem: pointer) {.importcpp: "push_back_",
    header: headermat.}
proc pushBack*[Tp](this: var MatBase; elem: Tp) {.importcpp: "push_back", header: headermat.}
proc pushBack*[Tp](this: var MatBase; elem: Mat[Tp]) {.importcpp: "push_back",
    header: headermat.}
proc pushBack*[Tp](this: var MatBase; elem: Vector[Tp]) {.importcpp: "push_back",
    header: headermat.}
proc pushBack*(this: var MatBase; m: MatBase) {.importcpp: "push_back", header: headermat.}
proc popBack*(this: var MatBase; nelems: csize = 1) {.importcpp: "pop_back", header: headermat.}
proc locateROI*(this: MatBase; wholeSize: var Size; ofs: var Point) {.noSideEffect,
    importcpp: "locateROI", header: headermat.}
proc adjustROI*(this: var MatBase; dtop: cint; dbottom: cint; dleft: cint; dright: cint): var MatBase {.
    importcpp: "adjustROI", header: headermat.}
proc `()`*(this: MatBase; rowRange: Range; colRange: Range): MatBase {.noSideEffect,
    importcpp: "#(@)", header: headermat.}
proc `()`*(this: MatBase; roi: Rect): MatBase {.noSideEffect, importcpp: "#(@)",
                                  header: headermat.}
proc `()`*(this: MatBase; ranges: ptr Range): MatBase {.noSideEffect, importcpp: "#(@)",
    header: headermat.}
proc `()`*(this: MatBase; ranges: Vector[Range]): MatBase {.noSideEffect, importcpp: "#(@)",
    header: headermat.}
converter `std`*[Tp](this: MatBase): Vector[Tp] {.noSideEffect,
    importcpp: "Mat::operator std", header: headermat.}
converter `vec`*[Tp; N: static[cint]](this: MatBase): Vec[Tp, N] {.noSideEffect,
    importcpp: "Mat::operator Vec", header: headermat.}
# converter `matx`*[Tp; M: static[cint]; N: static[cint]](this: MatBase): Matx[Tp, M, N] {.
#     noSideEffect, importcpp: "Mat::operator Matx", header: headermat.}
proc isContinuous*(this: MatBase): bool {.noSideEffect, importcpp: "isContinuous",
                                  header: headermat.}
proc isSubmatrix*(this: MatBase): bool {.noSideEffect, importcpp: "isSubmatrix",
                                 header: headermat.}
proc elemSize*(this: MatBase): csize {.noSideEffect, importcpp: "elemSize",
                               header: headermat.}
proc elemSize1*(this: MatBase): csize {.noSideEffect, importcpp: "elemSize1",
                                header: headermat.}
proc `type`*(this: MatBase): cint {.noSideEffect, importcpp: "type", header: headermat.}
proc depth*(this: MatBase): cint {.noSideEffect, importcpp: "depth", header: headermat.}
proc channels*(this: MatBase): cint {.noSideEffect, importcpp: "channels",
                              header: headermat.}
proc step1*(this: MatBase; i: cint = 0): csize {.noSideEffect, importcpp: "step1",
                                     header: headermat.}
proc empty*(this: MatBase): bool {.noSideEffect, importcpp: "empty", header: headermat.}
proc total*(this: MatBase): csize {.noSideEffect, importcpp: "total", header: headermat.}
proc total*(this: MatBase; startDim: cint; endDim: cint = 0x7FFFFFFF): csize {.noSideEffect,
    importcpp: "total", header: headermat.}
proc checkVector*(this: MatBase; elemChannels: cint; depth: cint = -1;
                 requireContinuous: bool = true): cint {.noSideEffect,
    importcpp: "checkVector", header: headermat.}
proc `ptr`*(this: var MatBase; i0: cint = 0): ptr byte {.importcpp: "ptr", header: headermat.}
proc `ptr`*(this: MatBase; i0: cint = 0): ptr byte {.noSideEffect, importcpp: "ptr",
    header: headermat.}
proc `ptr`*(this: var MatBase; row: cint; col: cint): ptr byte {.importcpp: "ptr",
    header: headermat.}
# proc `ptr`*(this: MatBase; row: cint; col: cint): ptr byte {.noSideEffect, importcpp: "ptr",
#     header: headermat.}
# proc `ptr`*(this: var MatBase; i0: cint; i1: cint; i2: cint): ptr byte {.importcpp: "ptr",
#     header: headermat.}
# proc `ptr`*(this: MatBase; i0: cint; i1: cint; i2: cint): ptr byte {.noSideEffect,
#     importcpp: "ptr", header: headermat.}
proc `ptr`*(this: var MatBase; idx: ptr cint): ptr byte {.importcpp: "ptr", header: headermat.}
# proc `ptr`*(this: MatBase; idx: ptr cint): ptr byte {.noSideEffect, importcpp: "ptr",
    # header: headermat.}
# proc `ptr`*[N: static[cint]](this: var MatBase; idx: Vec[cint, N]): ptr byte {.
#     importcpp: "ptr", header: headermat.}
# proc `ptr`*[N: static[cint]](this: MatBase; idx: Vec[cint, N]): ptr byte {.noSideEffect,
#     importcpp: "ptr", header: headermat.}
# proc `ptr`*[Tp](this: var MatBase; i0: cint = 0): ptr Tp {.importcpp: "ptr", header: headermat.}
# proc `ptr`*[Tp](this: MatBase; i0: cint = 0): ptr Tp {.noSideEffect, importcpp: "ptr",
#     header: headermat.}
# proc `ptr`*[Tp](this: var MatBase; row: cint; col: cint): ptr Tp {.importcpp: "ptr",
#     header: headermat.}
# proc `ptr`*[Tp](this: MatBase; row: cint; col: cint): ptr Tp {.noSideEffect, importcpp: "ptr",
#     header: headermat.}
# proc `ptr`*[Tp](this: var MatBase; i0: cint; i1: cint; i2: cint): ptr Tp {.importcpp: "ptr",
#     header: headermat.}
# proc `ptr`*[Tp](this: MatBase; i0: cint; i1: cint; i2: cint): ptr Tp {.noSideEffect,
#     importcpp: "ptr", header: headermat.}
# proc `ptr`*[Tp](this: var MatBase; idx: ptr cint): ptr Tp {.importcpp: "ptr", header: headermat.}
# proc `ptr`*[Tp](this: MatBase; idx: ptr cint): ptr Tp {.noSideEffect, importcpp: "ptr",
#     header: headermat.}
# proc `ptr`*[Tp; N: static[cint]](this: var MatBase; idx: Vec[cint, N]): ptr Tp {.
#     importcpp: "ptr", header: headermat.}
# proc `ptr`*[Tp; N: static[cint]](this: MatBase; idx: Vec[cint, N]): ptr Tp {.noSideEffect,
#     importcpp: "ptr", header: headermat.}
proc at*[Tp](this: var MatBase; i0: cint = 0): var Tp {.importcpp: "at", header: headermat.}
proc at*[Tp](this: MatBase; i0: cint = 0): Tp {.noSideEffect, importcpp: "at",
                                    header: headermat.}
proc at*[Tp](this: var MatBase; row: cint; col: cint): var Tp {.importcpp: "at",
    header: headermat.}
proc at*[Tp](this: MatBase; row: cint; col: cint): Tp {.noSideEffect, importcpp: "at",
    header: headermat.}
proc at*[Tp](this: var MatBase; i0: cint; i1: cint; i2: cint): var Tp {.importcpp: "at",
    header: headermat.}
proc at*[Tp](this: MatBase; i0: cint; i1: cint; i2: cint): Tp {.noSideEffect, importcpp: "at",
    header: headermat.}
proc at*[Tp](this: var MatBase; idx: ptr cint): var Tp {.importcpp: "at", header: headermat.}
proc at*[Tp](this: MatBase; idx: ptr cint): Tp {.noSideEffect, importcpp: "at",
                                      header: headermat.}
# proc at*[Tp; N: static[cint]](this: var MatBase; idx: Vec[cint, N]): var Tp {.importcpp: "at",
#     header: headermat.}
# proc at*[Tp; N: static[cint]](this: MatBase; idx: Vec[cint, N]): Tp {.noSideEffect,
#     importcpp: "at", header: headermat.}
proc at*[Tp](this: var MatBase; pt: Point): var Tp {.importcpp: "at", header: headermat.}
proc at*[Tp](this: MatBase; pt: Point): Tp {.noSideEffect, importcpp: "at", header: headermat.}
# proc begin*[Tp](this: var MatBase): MatIterator[Tp] {.importcpp: "begin", header: headermat.}
# proc begin*[Tp](this: MatBase): MatConstIterator[Tp] {.noSideEffect, importcpp: "begin",
#     header: headermat.}
# proc `end`*[Tp](this: var MatBase): MatIterator[Tp] {.importcpp: "end", header: headermat.}
# proc `end`*[Tp](this: MatBase): MatConstIterator[Tp] {.noSideEffect, importcpp: "end",
#     header: headermat.}
proc forEach*[Tp; Functor](this: var MatBase; operation: Functor) {.importcpp: "forEach",
    header: headermat.}
proc forEach*[Tp; Functor](this: MatBase; operation: Functor) {.noSideEffect,
    importcpp: "forEach", header: headermat.}
proc constructMat*(m: var MatBase): MatBase {.constructor, importcpp: "cv::Mat(@)",
                                 header: headermat.}

proc getStdAllocator*(): ptr MatAllocator {.importcpp: "cv::Mat::getStdAllocator(@)",
                                        header: headermat.}
proc getDefaultAllocator*(): ptr MatAllocator {.
    importcpp: "cv::Mat::getDefaultAllocator(@)", header: headermat.}
proc setDefaultAllocator*(allocator: ptr MatAllocator) {.
    importcpp: "cv::Mat::setDefaultAllocator(@)", header: headermat.}

# proc constructMat*[Tp](): Mat[Tp] {.constructor, importcpp: "cv::Mat_(@)",
#                                  header: headermat.}
proc constructMat*[Tp](rows: cint; cols: cint): Mat[Tp] {.constructor,
    importcpp: "cv::Mat_(@)", header: headermat.}
proc constructMat*[Tp](rows: cint; cols: cint; value: Tp): Mat[Tp] {.constructor,
    importcpp: "cv::Mat_(@)", header: headermat.}
proc constructMat*[Tp](size: Size): Mat[Tp] {.constructor, importcpp: "cv::Mat_(@)",
    header: headermat.}
proc constructMat*[Tp](size: Size; value: Tp): Mat[Tp] {.constructor,
    importcpp: "cv::Mat_(@)", header: headermat.}
proc constructMat*[Tp](ndims: cint; sizes: ptr cint): Mat[Tp] {.constructor,
    importcpp: "cv::Mat_(@)", header: headermat.}
proc constructMat*[Tp](ndims: cint; sizes: ptr cint; value: Tp): Mat[Tp] {.constructor,
    importcpp: "cv::Mat_(@)", header: headermat.}
proc constructMat*[Tp](m: Mat): Mat[Tp] {.constructor, importcpp: "cv::Mat_(@)",
                                      header: headermat.}
# proc constructMat*[Tp](m: Mat): Mat[Tp] {.constructor, importcpp: "cv::Mat_(@)",
#                                       header: headermat.}
proc constructMat*[Tp](rows: cint; cols: cint; data: ptr Tp; step: csize = AUTO_STEP): Mat[
    Tp] {.constructor, importcpp: "cv::Mat_(@)", header: headermat.}
proc constructMat*[Tp](ndims: cint; sizes: ptr cint; data: ptr Tp; steps: ptr csize = nil): Mat[
    Tp] {.constructor, importcpp: "cv::Mat_(@)", header: headermat.}
proc constructMat*[Tp](m: Mat; rowRange: Range; colRange: Range = all()): Mat[Tp] {.
    constructor, importcpp: "cv::Mat_(@)", header: headermat.}
proc constructMat*[Tp](m: Mat; roi: Rect): Mat[Tp] {.constructor,
    importcpp: "cv::Mat_(@)", header: headermat.}
proc constructMat*[Tp](m: Mat; ranges: ptr Range): Mat[Tp] {.constructor,
    importcpp: "cv::Mat_(@)", header: headermat.}
proc constructMat*[Tp](m: Mat; ranges: Vector[Range]): Mat[Tp] {.constructor,
    importcpp: "cv::Mat_(@)", header: headermat.}
proc constructMat*[Tp](e: MatExpr): Mat[Tp] {.constructor, importcpp: "cv::Mat_(@)",
    header: headermat.}
proc constructMat*[Tp](vec: Vector[Tp]; copyData: bool = false): Mat[Tp] {.constructor,
    importcpp: "cv::Mat_(@)", header: headermat.}
proc constructMat*[Tp](commaInitializer: MatCommaInitializer[Tp]): Mat[Tp] {.
    constructor, importcpp: "cv::Mat_(@)", header: headermat.}
# proc begin*[Tp](this: var Mat[Tp]): Iterator {.importcpp: "begin", header: headermat.}
# proc `end`*[Tp](this: var Mat[Tp]): Iterator {.importcpp: "end", header: headermat.}
# proc begin*[Tp](this: Mat[Tp]): ConstIterator {.noSideEffect, importcpp: "begin",
#     header: headermat.}
# proc `end`*[Tp](this: Mat[Tp]): ConstIterator {.noSideEffect, importcpp: "end",
#     header: headermat.}
proc forEach*[Tp; Functor](this: var Mat[Tp]; operation: Functor) {.
    importcpp: "forEach", header: headermat.}
proc forEach*[Tp; Functor](this: Mat[Tp]; operation: Functor) {.noSideEffect,
    importcpp: "forEach", header: headermat.}
proc create*[Tp](this: var Mat[Tp]; rows: cint; cols: cint) {.importcpp: "create",
    header: headermat.}
proc create*[Tp](this: var Mat[Tp]; size: Size) {.importcpp: "create", header: headermat.}
proc create*[Tp](this: var Mat[Tp]; ndims: cint; sizes: ptr cint) {.importcpp: "create",
    header: headermat.}
proc release*[Tp](this: var Mat[Tp]) {.importcpp: "release", header: headermat.}
proc cross*[Tp](this: Mat[Tp]; m: Mat): Mat {.noSideEffect, importcpp: "cross",
                                        header: headermat.}
converter `mat`*[Tp; T2](this: Mat[Tp]): Mat[T2] {.noSideEffect,
    importcpp: "Mat_::operator Mat_", header: headermat.}
proc row*[Tp](this: Mat[Tp]; y: cint): Mat {.noSideEffect, importcpp: "row",
                                       header: headermat.}
proc col*[Tp](this: Mat[Tp]; x: cint): Mat {.noSideEffect, importcpp: "col",
                                       header: headermat.}
proc diag*[Tp](this: Mat[Tp]; d: cint = 0): Mat {.noSideEffect, importcpp: "diag",
    header: headermat.}
proc clone*[Tp](this: Mat[Tp]): Mat {.noSideEffect, importcpp: "clone",
                                  header: headermat.}
proc elemSize*[Tp](this: Mat[Tp]): csize {.noSideEffect, importcpp: "elemSize",
                                       header: headermat.}
proc elemSize1*[Tp](this: Mat[Tp]): csize {.noSideEffect, importcpp: "elemSize1",
                                        header: headermat.}
proc `type`*[Tp](this: Mat[Tp]): cint {.noSideEffect, importcpp: "type",
                                    header: headermat.}
proc depth*[Tp](this: Mat[Tp]): cint {.noSideEffect, importcpp: "depth",
                                   header: headermat.}
proc channels*[Tp](this: Mat[Tp]): cint {.noSideEffect, importcpp: "channels",
                                      header: headermat.}
proc step1*[Tp](this: Mat[Tp]; i: cint = 0): csize {.noSideEffect, importcpp: "step1",
    header: headermat.}
proc stepT*[Tp](this: Mat[Tp]; i: cint = 0): csize {.noSideEffect, importcpp: "stepT",
    header: headermat.}
# proc zeros*[Tp](rows: cint; cols: cint): MatExpr {.importcpp: "cv::Mat_::zeros(@)",
#     header: headermat.}
# proc zeros*[Tp](size: Size): MatExpr {.importcpp: "cv::Mat_::zeros(@)",
#                                    header: headermat.}
# proc zeros*[Tp](ndims: cint; sizes: ptr cint): MatExpr {.
#     importcpp: "cv::Mat_::zeros(@)", header: headermat.}
proc ones*[Tp](rows: cint; cols: cint): MatExpr {.importcpp: "cv::Mat_::ones(@)",
    header: headermat.}
proc ones*[Tp](size: Size): MatExpr {.importcpp: "cv::Mat_::ones(@)",
                                  header: headermat.}
proc ones*[Tp](ndims: cint; sizes: ptr cint): MatExpr {.importcpp: "cv::Mat_::ones(@)",
    header: headermat.}
proc eye*[Tp](rows: cint; cols: cint): MatExpr {.importcpp: "cv::Mat_::eye(@)",
    header: headermat.}
proc eye*[Tp](size: Size): MatExpr {.importcpp: "cv::Mat_::eye(@)", header: headermat.}
proc adjustROI*[Tp](this: var Mat[Tp]; dtop: cint; dbottom: cint; dleft: cint;
                   dright: cint): var Mat {.importcpp: "adjustROI", header: headermat.}
proc `()`*[Tp](this: Mat[Tp]; rowRange: Range; colRange: Range): Mat {.noSideEffect,
    importcpp: "#(@)", header: headermat.}
proc `()`*[Tp](this: Mat[Tp]; roi: Rect): Mat {.noSideEffect, importcpp: "#(@)",
    header: headermat.}
proc `()`*[Tp](this: Mat[Tp]; ranges: ptr Range): Mat {.noSideEffect, importcpp: "#(@)",
    header: headermat.}
proc `()`*[Tp](this: Mat[Tp]; ranges: Vector[Range]): Mat {.noSideEffect,
    importcpp: "#(@)", header: headermat.}
proc `[]`*[Tp](this: var Mat[Tp]; y: cint): ptr Tp {.importcpp: "#[@]", header: headermat.}
proc `[]`*[Tp](this: Mat[Tp]; y: cint): ptr Tp {.noSideEffect, importcpp: "#[@]",
    header: headermat.}
proc `()`*[Tp](this: var Mat[Tp]; idx: ptr cint): var Tp {.importcpp: "#(@)",
    header: headermat.}
proc `()`*[Tp](this: Mat[Tp]; idx: ptr cint): Tp {.noSideEffect, importcpp: "#(@)",
    header: headermat.}
# proc `()`*[Tp; N: static[cint]](this: var Mat[Tp]; idx: Vec[cint, N]): var Tp {.
#     importcpp: "#(@)", header: headermat.}
# proc `()`*[Tp; N: static[cint]](this: Mat[Tp]; idx: Vec[cint, N]): Tp {.noSideEffect,
#     importcpp: "#(@)", header: headermat.}
proc `()`*[Tp](this: var Mat[Tp]; idx0: cint): var Tp {.importcpp: "#(@)",
    header: headermat.}
proc `()`*[Tp](this: Mat[Tp]; idx0: cint): Tp {.noSideEffect, importcpp: "#(@)",
    header: headermat.}
proc `()`*[Tp](this: var Mat[Tp]; row: cint; col: cint): var Tp {.importcpp: "#(@)",
    header: headermat.}
proc `()`*[Tp](this: Mat[Tp]; row: cint; col: cint): Tp {.noSideEffect,
    importcpp: "#(@)", header: headermat.}
proc `()`*[Tp](this: var Mat[Tp]; idx0: cint; idx1: cint; idx2: cint): var Tp {.
    importcpp: "#(@)", header: headermat.}
proc `()`*[Tp](this: Mat[Tp]; idx0: cint; idx1: cint; idx2: cint): Tp {.noSideEffect,
    importcpp: "#(@)", header: headermat.}
proc `()`*[Tp](this: var Mat[Tp]; pt: Point): var Tp {.importcpp: "#(@)",
    header: headermat.}
proc `()`*[Tp](this: Mat[Tp]; pt: Point): Tp {.noSideEffect, importcpp: "#(@)",
    header: headermat.}
converter `std`*[Tp](this: Mat[Tp]): Vector[Tp] {.noSideEffect,
    importcpp: "Mat_::operator std", header: headermat.}
proc constructMat*[Tp](m: var Mat): Mat[Tp] {.constructor, importcpp: "cv::Mat_(@)",
    header: headermat.}
# proc constructMat*[Tp](m: var Mat): Mat[Tp] {.constructor, importcpp: "cv::Mat_(@)",
#     header: headermat.}
proc constructMat*[Tp](e: var MatExpr): Mat[Tp] {.constructor,
    importcpp: "cv::Mat_(@)", header: headermat.}
type
  Mat1b* = Mat[byte]
  # Mat2b* = Mat[Vec2b]
  # Mat3b* = Mat[Vec3b]
  # Mat4b* = Mat[Vec4b]
  # Mat1s* = Mat[cshort]
  # Mat2s* = Mat[Vec2s]
  # Mat3s* = Mat[Vec3s]
  # Mat4s* = Mat[Vec4s]
  # Mat1w* = Mat[Ushort]
  # Mat2w* = Mat[Vec2w]
  # Mat3w* = Mat[Vec3w]
  # Mat4w* = Mat[Vec4w]
  # Mat1i* = Mat[cint]
  # Mat2i* = Mat[Vec2i]
  # Mat3i* = Mat[Vec3i]
  # Mat4i* = Mat[Vec4i]
  # Mat1f* = Mat[cfloat]
  # Mat2f* = Mat[Vec2f]
  # Mat3f* = Mat[Vec3f]
  # Mat4f* = Mat[Vec4f]
  # Mat1d* = Mat[cdouble]
  # Mat2d* = Mat[Vec2d]
  # Mat3d* = Mat[Vec3d]
  # Mat4d* = Mat[Vec4d]

proc constructUMat*(usageFlags: UMatUsageFlags = USAGE_DEFAULT): UMat {.constructor,
    importcpp: "cv::UMat(@)", header: headermat.}
proc constructUMat*(rows: cint; cols: cint; `type`: cint;
                   usageFlags: UMatUsageFlags = USAGE_DEFAULT): UMat {.constructor,
    importcpp: "cv::UMat(@)", header: headermat.}
proc constructUMat*(size: Size; `type`: cint;
                   usageFlags: UMatUsageFlags = USAGE_DEFAULT): UMat {.constructor,
    importcpp: "cv::UMat(@)", header: headermat.}
proc constructUMat*(rows: cint; cols: cint; `type`: cint; s: Scalar;
                   usageFlags: UMatUsageFlags = USAGE_DEFAULT): UMat {.constructor,
    importcpp: "cv::UMat(@)", header: headermat.}
proc constructUMat*(size: Size; `type`: cint; s: Scalar;
                   usageFlags: UMatUsageFlags = USAGE_DEFAULT): UMat {.constructor,
    importcpp: "cv::UMat(@)", header: headermat.}
proc constructUMat*(ndims: cint; sizes: ptr cint; `type`: cint;
                   usageFlags: UMatUsageFlags = USAGE_DEFAULT): UMat {.constructor,
    importcpp: "cv::UMat(@)", header: headermat.}
proc constructUMat*(ndims: cint; sizes: ptr cint; `type`: cint; s: Scalar;
                   usageFlags: UMatUsageFlags = USAGE_DEFAULT): UMat {.constructor,
    importcpp: "cv::UMat(@)", header: headermat.}
proc constructUMat*(m: UMat): UMat {.constructor, importcpp: "cv::UMat(@)",
                                 header: headermat.}
proc constructUMat*(m: UMat; rowRange: Range; colRange: Range = all()): UMat {.
    constructor, importcpp: "cv::UMat(@)", header: headermat.}
proc constructUMat*(m: UMat; roi: Rect): UMat {.constructor, importcpp: "cv::UMat(@)",
    header: headermat.}
proc constructUMat*(m: UMat; ranges: ptr Range): UMat {.constructor,
    importcpp: "cv::UMat(@)", header: headermat.}
proc constructUMat*(m: UMat; ranges: Vector[Range]): UMat {.constructor,
    importcpp: "cv::UMat(@)", header: headermat.}
proc constructUMat*[Tp](vec: Vector[Tp]; copyData: bool = false): UMat {.constructor,
    importcpp: "cv::UMat(@)", header: headermat.}
proc constructUMat*[Tp; N: static[cint]](vec: Vec[Tp, N]; copyData: bool = true): UMat {.
    constructor, importcpp: "cv::UMat(@)", header: headermat.}
# proc constructUMat*[Tp; M: static[cint]; N: static[cint]](mtx: Matx[Tp, M, N];
#     copyData: bool = true): UMat {.constructor, importcpp: "cv::UMat(@)",
#                               header: headermat.}
proc constructUMat*[Tp](pt: Point[Tp]; copyData: bool = true): UMat {.constructor,
    importcpp: "cv::UMat(@)", header: headermat.}
proc constructUMat*[Tp](pt: Point3[Tp]; copyData: bool = true): UMat {.constructor,
    importcpp: "cv::UMat(@)", header: headermat.}
proc constructUMat*[Tp](commaInitializer: MatCommaInitializer[Tp]): UMat {.
    constructor, importcpp: "cv::UMat(@)", header: headermat.}
proc destroyUMat*(this: var UMat) {.importcpp: "#.~UMat()", header: headermat.}
proc getMat*(this: UMat; flags: cint): Mat {.noSideEffect, importcpp: "getMat",
                                       header: headermat.}
proc row*(this: UMat; y: cint): UMat {.noSideEffect, importcpp: "row", header: headermat.}
proc col*(this: UMat; x: cint): UMat {.noSideEffect, importcpp: "col", header: headermat.}
proc rowRange*(this: UMat; startrow: cint; endrow: cint): UMat {.noSideEffect,
    importcpp: "rowRange", header: headermat.}
proc rowRange*(this: UMat; r: Range): UMat {.noSideEffect, importcpp: "rowRange",
                                       header: headermat.}
proc colRange*(this: UMat; startcol: cint; endcol: cint): UMat {.noSideEffect,
    importcpp: "colRange", header: headermat.}
proc colRange*(this: UMat; r: Range): UMat {.noSideEffect, importcpp: "colRange",
                                       header: headermat.}
proc diag*(this: UMat; d: cint = 0): UMat {.noSideEffect, importcpp: "diag",
                                    header: headermat.}
proc diag*(d: UMat): UMat {.importcpp: "cv::UMat::diag(@)", header: headermat.}
proc clone*(this: UMat): UMat {.noSideEffect, importcpp: "clone", header: headermat.}
# proc copyTo*(this: UMat; m: OutputArray) {.noSideEffect, importcpp: "copyTo",
#                                       header: headermat.}
# proc copyTo*(this: UMat; m: OutputArray; mask: InputArray) {.noSideEffect,
#     importcpp: "copyTo", header: headermat.}
# proc convertTo*(this: UMat; m: OutputArray; rtype: cint; alpha: cdouble = 1;
#                beta: cdouble = 0) {.noSideEffect, importcpp: "convertTo",
#                                 header: headermat.}
proc assignTo*(this: UMat; m: var UMat; `type`: cint = -1) {.noSideEffect,
    importcpp: "assignTo", header: headermat.}
# proc setTo*(this: var UMat; value: InputArray; mask: InputArray = noArray()): var UMat {.
#     importcpp: "setTo", header: headermat.}
proc reshape*(this: UMat; cn: cint; rows: cint = 0): UMat {.noSideEffect,
    importcpp: "reshape", header: headermat.}
proc reshape*(this: UMat; cn: cint; newndims: cint; newsz: ptr cint): UMat {.noSideEffect,
    importcpp: "reshape", header: headermat.}
proc t*(this: UMat): UMat {.noSideEffect, importcpp: "t", header: headermat.}
# proc inv*(this: UMat; `method`: cint = decomp_Lu): UMat {.noSideEffect, importcpp: "inv",
#     header: headermat.}
# proc mul*(this: UMat; m: InputArray; scale: cdouble = 1): UMat {.noSideEffect,
#     importcpp: "mul", header: headermat.}
# proc dot*(this: UMat; m: InputArray): cdouble {.noSideEffect, importcpp: "dot",
#     header: headermat.}
proc zeros*(rows: cint; cols: cint; `type`: cint): UMat {.
    importcpp: "cv::UMat::zeros(@)", header: headermat.}
proc zeros*(size: Size; `type`: cint): UMat {.importcpp: "cv::umat::zeros(@)",
                                        header: headermat.}
proc zeros*(ndims: cint; sz: ptr cint; `type`: cint): UMat {.
    importcpp: "cv::UMat::zeros(@)", header: headermat.}
proc ones*(rows: cint; cols: cint; `type`: cint): UMat {.importcpp: "cv::UMat::ones(@)",
    header: headermat.}
proc ones*(size: Size; `type`: cint): UMat {.importcpp: "cv::UMat::ones(@)",
                                       header: headermat.}
proc ones*(ndims: cint; sz: ptr cint; `type`: cint): UMat {.
    importcpp: "cv::UMat::ones(@)", header: headermat.}
proc eye*(rows: cint; cols: cint; `type`: cint): UMat {.importcpp: "cv::UMat::eye(@)",
    header: headermat.}
proc eye*(size: Size; `type`: cint): UMat {.importcpp: "cv::UMat::eye(@)",
                                      header: headermat.}
proc create*(this: var UMat; rows: cint; cols: cint; `type`: cint;
            usageFlags: UMatUsageFlags = USAGE_DEFAULT) {.importcpp: "create",
    header: headermat.}
proc create*(this: var UMat; size: Size; `type`: cint;
            usageFlags: UMatUsageFlags = USAGE_DEFAULT) {.importcpp: "create",
    header: headermat.}
proc create*(this: var UMat; ndims: cint; sizes: ptr cint; `type`: cint;
            usageFlags: UMatUsageFlags = USAGE_DEFAULT) {.importcpp: "create",
    header: headermat.}
proc create*(this: var UMat; sizes: Vector[cint]; `type`: cint;
            usageFlags: UMatUsageFlags = USAGE_DEFAULT) {.importcpp: "create",
    header: headermat.}
proc addref*(this: var UMat) {.importcpp: "addref", header: headermat.}
proc release*(this: var UMat) {.importcpp: "release", header: headermat.}
proc deallocate*(this: var UMat) {.importcpp: "deallocate", header: headermat.}
proc copySize*(this: var UMat; m: UMat) {.importcpp: "copySize", header: headermat.}
proc locateROI*(this: UMat; wholeSize: var Size; ofs: var Point) {.noSideEffect,
    importcpp: "locateROI", header: headermat.}
proc adjustROI*(this: var UMat; dtop: cint; dbottom: cint; dleft: cint; dright: cint): var UMat {.
    importcpp: "adjustROI", header: headermat.}
proc `()`*(this: UMat; rowRange: Range; colRange: Range): UMat {.noSideEffect,
    importcpp: "#(@)", header: headermat.}
proc `()`*(this: UMat; roi: Rect): UMat {.noSideEffect, importcpp: "#(@)",
                                    header: headermat.}
proc `()`*(this: UMat; ranges: ptr Range): UMat {.noSideEffect, importcpp: "#(@)",
    header: headermat.}
proc `()`*(this: UMat; ranges: Vector[Range]): UMat {.noSideEffect, importcpp: "#(@)",
    header: headermat.}
proc isContinuous*(this: UMat): bool {.noSideEffect, importcpp: "isContinuous",
                                   header: headermat.}
proc isSubmatrix*(this: UMat): bool {.noSideEffect, importcpp: "isSubmatrix",
                                  header: headermat.}
proc elemSize*(this: UMat): csize {.noSideEffect, importcpp: "elemSize",
                                header: headermat.}
proc elemSize1*(this: UMat): csize {.noSideEffect, importcpp: "elemSize1",
                                 header: headermat.}
proc `type`*(this: UMat): cint {.noSideEffect, importcpp: "type", header: headermat.}
proc depth*(this: UMat): cint {.noSideEffect, importcpp: "depth", header: headermat.}
proc channels*(this: UMat): cint {.noSideEffect, importcpp: "channels",
                               header: headermat.}
proc step1*(this: UMat; i: cint = 0): csize {.noSideEffect, importcpp: "step1",
                                      header: headermat.}
proc empty*(this: UMat): bool {.noSideEffect, importcpp: "empty", header: headermat.}
proc total*(this: UMat): csize {.noSideEffect, importcpp: "total", header: headermat.}
proc checkVector*(this: UMat; elemChannels: cint; depth: cint = -1;
                 requireContinuous: bool = true): cint {.noSideEffect,
    importcpp: "checkVector", header: headermat.}
proc constructUMat*(m: var UMat): UMat {.constructor, importcpp: "cv::UMat(@)",
                                    header: headermat.}
proc handle*(this: UMat; accessFlags: cint): pointer {.noSideEffect,
    importcpp: "handle", header: headermat.}
proc ndoffset*(this: UMat; ofs: ptr csize) {.noSideEffect, importcpp: "ndoffset",
                                       header: headermat.}
const
  MAGIC_VAL* = 0x42FF0000
  AUTO_STEP* = 0
  CONTINUOUS_FLAG* = (1 shl 14)
  SUBMATRIX_FLAG* = (1 shl 15)

const
  MAGIC_MASK* = 0xFFFF0000
  TYPE_MASK* = 0x00000FFF
  DEPTH_MASK* = 7

proc getStdAllocator*(): ptr MatAllocator {.importcpp: "cv::UMat::getStdAllocator(@)",
                                        header: headermat.}


proc constructHdr*(dims: cint; sizes: ptr cint; `type`: cint): Hdr {.constructor,
    importcpp: "cv::Hdr(@)", header: headermat.}
proc clear*(this: var Hdr) {.importcpp: "clear", header: headermat.}
type
  Node* {.importcpp: "cv::Node", header: headermat, bycopy.} = object
    hashval* {.importc: "hashval".}: csize
    next* {.importc: "next".}: csize
    idx* {.importc: "idx".}: array[max_Dim, cint]


proc constructSparseMat*(): SparseMat {.constructor, importcpp: "cv::SparseMat(@)",
                                     header: headermat.}
proc constructSparseMat*(dims: cint; sizes: ptr cint; `type`: cint): SparseMat {.
    constructor, importcpp: "cv::SparseMat(@)", header: headermat.}
proc constructSparseMat*(m: SparseMat): SparseMat {.constructor,
    importcpp: "cv::SparseMat(@)", header: headermat.}
proc constructSparseMat*(m: Mat): SparseMat {.constructor,
    importcpp: "cv::SparseMat(@)", header: headermat.}
proc destroySparseMat*(this: var SparseMat) {.importcpp: "#.~SparseMat()",
    header: headermat.}
proc clone*(this: SparseMat): SparseMat {.noSideEffect, importcpp: "clone",
                                      header: headermat.}
proc copyTo*(this: SparseMat; m: var SparseMat) {.noSideEffect, importcpp: "copyTo",
    header: headermat.}
proc copyTo*(this: SparseMat; m: var Mat) {.noSideEffect, importcpp: "copyTo",
                                      header: headermat.}
proc convertTo*(this: SparseMat; m: var SparseMat; rtype: cint; alpha: cdouble = 1) {.
    noSideEffect, importcpp: "convertTo", header: headermat.}
proc convertTo*(this: SparseMat; m: var Mat; rtype: cint; alpha: cdouble = 1;
               beta: cdouble = 0) {.noSideEffect, importcpp: "convertTo",
                                header: headermat.}
proc assignTo*(this: SparseMat; m: var SparseMat; `type`: cint = -1) {.noSideEffect,
    importcpp: "assignTo", header: headermat.}
proc create*(this: var SparseMat; dims: cint; sizes: ptr cint; `type`: cint) {.
    importcpp: "create", header: headermat.}
proc clear*(this: var SparseMat) {.importcpp: "clear", header: headermat.}
proc addref*(this: var SparseMat) {.importcpp: "addref", header: headermat.}
proc release*(this: var SparseMat) {.importcpp: "release", header: headermat.}
proc elemSize*(this: SparseMat): csize {.noSideEffect, importcpp: "elemSize",
                                     header: headermat.}
proc elemSize1*(this: SparseMat): csize {.noSideEffect, importcpp: "elemSize1",
                                      header: headermat.}
proc `type`*(this: SparseMat): cint {.noSideEffect, importcpp: "type",
                                  header: headermat.}
proc depth*(this: SparseMat): cint {.noSideEffect, importcpp: "depth",
                                 header: headermat.}
proc channels*(this: SparseMat): cint {.noSideEffect, importcpp: "channels",
                                    header: headermat.}
proc size*(this: SparseMat): ptr cint {.noSideEffect, importcpp: "size",
                                   header: headermat.}
proc size*(this: SparseMat; i: cint): cint {.noSideEffect, importcpp: "size",
                                       header: headermat.}
proc dims*(this: SparseMat): cint {.noSideEffect, importcpp: "dims", header: headermat.}
proc nzcount*(this: SparseMat): csize {.noSideEffect, importcpp: "nzcount",
                                    header: headermat.}
proc hash*(this: SparseMat; i0: cint): csize {.noSideEffect, importcpp: "hash",
    header: headermat.}
proc hash*(this: SparseMat; i0: cint; i1: cint): csize {.noSideEffect, importcpp: "hash",
    header: headermat.}
proc hash*(this: SparseMat; i0: cint; i1: cint; i2: cint): csize {.noSideEffect,
    importcpp: "hash", header: headermat.}
proc hash*(this: SparseMat; idx: ptr cint): csize {.noSideEffect, importcpp: "hash",
    header: headermat.}
proc `ptr`*(this: var SparseMat; i0: cint; createMissing: bool; hashval: ptr csize = nil): ptr byte {.
    importcpp: "ptr", header: headermat.}
proc `ptr`*(this: var SparseMat; i0: cint; i1: cint; createMissing: bool;
           hashval: ptr csize = nil): ptr byte {.importcpp: "ptr", header: headermat.}
proc `ptr`*(this: var SparseMat; i0: cint; i1: cint; i2: cint; createMissing: bool;
           hashval: ptr csize = nil): ptr byte {.importcpp: "ptr", header: headermat.}
proc `ptr`*(this: var SparseMat; idx: ptr cint; createMissing: bool;
           hashval: ptr csize = nil): ptr byte {.importcpp: "ptr", header: headermat.}
proc `ref`*[Tp](this: var SparseMat; i0: cint; hashval: ptr csize = nil): var Tp {.
    importcpp: "ref", header: headermat.}
proc `ref`*[Tp](this: var SparseMat; i0: cint; i1: cint; hashval: ptr csize = nil): var Tp {.
    importcpp: "ref", header: headermat.}
proc `ref`*[Tp](this: var SparseMat; i0: cint; i1: cint; i2: cint; hashval: ptr csize = nil): var Tp {.
    importcpp: "ref", header: headermat.}
proc `ref`*[Tp](this: var SparseMat; idx: ptr cint; hashval: ptr csize = nil): var Tp {.
    importcpp: "ref", header: headermat.}
proc value*[Tp](this: SparseMat; i0: cint; hashval: ptr csize = nil): Tp {.noSideEffect,
    importcpp: "value", header: headermat.}
proc value*[Tp](this: SparseMat; i0: cint; i1: cint; hashval: ptr csize = nil): Tp {.
    noSideEffect, importcpp: "value", header: headermat.}
proc value*[Tp](this: SparseMat; i0: cint; i1: cint; i2: cint; hashval: ptr csize = nil): Tp {.
    noSideEffect, importcpp: "value", header: headermat.}
proc value*[Tp](this: SparseMat; idx: ptr cint; hashval: ptr csize = nil): Tp {.noSideEffect,
    importcpp: "value", header: headermat.}
proc find*[Tp](this: SparseMat; i0: cint; hashval: ptr csize = nil): ptr Tp {.noSideEffect,
    importcpp: "find", header: headermat.}
proc find*[Tp](this: SparseMat; i0: cint; i1: cint; hashval: ptr csize = nil): ptr Tp {.
    noSideEffect, importcpp: "find", header: headermat.}
proc find*[Tp](this: SparseMat; i0: cint; i1: cint; i2: cint; hashval: ptr csize = nil): ptr Tp {.
    noSideEffect, importcpp: "find", header: headermat.}
proc find*[Tp](this: SparseMat; idx: ptr cint; hashval: ptr csize = nil): ptr Tp {.
    noSideEffect, importcpp: "find", header: headermat.}
proc erase*(this: var SparseMat; i0: cint; i1: cint; hashval: ptr csize = nil) {.
    importcpp: "erase", header: headermat.}
proc erase*(this: var SparseMat; i0: cint; i1: cint; i2: cint; hashval: ptr csize = nil) {.
    importcpp: "erase", header: headermat.}
proc erase*(this: var SparseMat; idx: ptr cint; hashval: ptr csize = nil) {.
    importcpp: "erase", header: headermat.}
proc begin*(this: var SparseMat): SparseMatIterator {.importcpp: "begin",
    header: headermat.}
proc begin*[Tp](this: var SparseMat): SparseMatIterator[Tp] {.importcpp: "begin",
    header: headermat.}
proc begin*(this: SparseMat): SparseMatConstIterator {.noSideEffect,
    importcpp: "begin", header: headermat.}
proc begin*[Tp](this: SparseMat): SparseMatConstIterator[Tp] {.noSideEffect,
    importcpp: "begin", header: headermat.}
proc `end`*(this: var SparseMat): SparseMatIterator {.importcpp: "end",
    header: headermat.}
proc `end`*(this: SparseMat): SparseMatConstIterator {.noSideEffect,
    importcpp: "end", header: headermat.}
proc `end`*[Tp](this: var SparseMat): SparseMatIterator[Tp] {.importcpp: "end",
    header: headermat.}
proc `end`*[Tp](this: SparseMat): SparseMatConstIterator[Tp] {.noSideEffect,
    importcpp: "end", header: headermat.}
proc value*[Tp](this: var SparseMat; n: ptr Node): var Tp {.importcpp: "value",
    header: headermat.}
proc value*[Tp](this: SparseMat; n: ptr Node): Tp {.noSideEffect, importcpp: "value",
    header: headermat.}
proc node*(this: var SparseMat; nidx: csize): ptr Node {.importcpp: "node",
    header: headermat.}
proc node*(this: SparseMat; nidx: csize): ptr Node {.noSideEffect, importcpp: "node",
    header: headermat.}
proc newNode*(this: var SparseMat; idx: ptr cint; hashval: csize): ptr byte {.
    importcpp: "newNode", header: headermat.}
proc removeNode*(this: var SparseMat; hidx: csize; nidx: csize; previdx: csize) {.
    importcpp: "removeNode", header: headermat.}
proc resizeHashTab*(this: var SparseMat; newsize: csize) {.importcpp: "resizeHashTab",
    header: headermat.}
type
  SparseMat* {.importcpp: "cv::SparseMat_", header: headermat, bycopy.}[Tp] = object of SparseMat
  
  Iterator* = SparseMatIterator[Tp]
  ConstIterator* = SparseMatConstIterator[Tp]

proc constructSparseMat*[Tp](): SparseMat[Tp] {.constructor,
    importcpp: "cv::SparseMat_(@)", header: headermat.}
proc constructSparseMat*[Tp](dims: cint; sizes: ptr cint): SparseMat[Tp] {.constructor,
    importcpp: "cv::SparseMat_(@)", header: headermat.}
proc constructSparseMat*[Tp](m: SparseMat): SparseMat[Tp] {.constructor,
    importcpp: "cv::SparseMat_(@)", header: headermat.}
proc constructSparseMat*[Tp](m: SparseMat): SparseMat[Tp] {.constructor,
    importcpp: "cv::SparseMat_(@)", header: headermat.}
proc constructSparseMat*[Tp](m: Mat): SparseMat[Tp] {.constructor,
    importcpp: "cv::SparseMat_(@)", header: headermat.}
proc clone*[Tp](this: SparseMat[Tp]): SparseMat {.noSideEffect, importcpp: "clone",
    header: headermat.}
proc create*[Tp](this: var SparseMat[Tp]; dims: cint; sizes: ptr cint) {.
    importcpp: "create", header: headermat.}
proc `type`*[Tp](this: SparseMat[Tp]): cint {.noSideEffect, importcpp: "type",
    header: headermat.}
proc depth*[Tp](this: SparseMat[Tp]): cint {.noSideEffect, importcpp: "depth",
    header: headermat.}
proc channels*[Tp](this: SparseMat[Tp]): cint {.noSideEffect, importcpp: "channels",
    header: headermat.}
proc `ref`*[Tp](this: var SparseMat[Tp]; i0: cint; hashval: ptr csize = nil): var Tp {.
    importcpp: "ref", header: headermat.}
proc `ref`*[Tp](this: var SparseMat[Tp]; i0: cint; i1: cint; hashval: ptr csize = nil): var Tp {.
    importcpp: "ref", header: headermat.}
proc `ref`*[Tp](this: var SparseMat[Tp]; i0: cint; i1: cint; i2: cint;
               hashval: ptr csize = nil): var Tp {.importcpp: "ref", header: headermat.}
proc `ref`*[Tp](this: var SparseMat[Tp]; idx: ptr cint; hashval: ptr csize = nil): var Tp {.
    importcpp: "ref", header: headermat.}
proc `()`*[Tp](this: SparseMat[Tp]; i0: cint; hashval: ptr csize = nil): Tp {.noSideEffect,
    importcpp: "#(@)", header: headermat.}
proc `()`*[Tp](this: SparseMat[Tp]; i0: cint; i1: cint; hashval: ptr csize = nil): Tp {.
    noSideEffect, importcpp: "#(@)", header: headermat.}
proc `()`*[Tp](this: SparseMat[Tp]; i0: cint; i1: cint; i2: cint; hashval: ptr csize = nil): Tp {.
    noSideEffect, importcpp: "#(@)", header: headermat.}
proc `()`*[Tp](this: SparseMat[Tp]; idx: ptr cint; hashval: ptr csize = nil): Tp {.
    noSideEffect, importcpp: "#(@)", header: headermat.}
proc begin*[Tp](this: var SparseMat[Tp]): SparseMatIterator[Tp] {.importcpp: "begin",
    header: headermat.}
proc begin*[Tp](this: SparseMat[Tp]): SparseMatConstIterator[Tp] {.noSideEffect,
    importcpp: "begin", header: headermat.}
proc `end`*[Tp](this: var SparseMat[Tp]): SparseMatIterator[Tp] {.importcpp: "end",
    header: headermat.}
proc `end`*[Tp](this: SparseMat[Tp]): SparseMatConstIterator[Tp] {.noSideEffect,
    importcpp: "end", header: headermat.}
type
  ValueType* = ptr byte
  DifferenceType* = PtrdiffT
  pointer* = ptr ptr byte
  Reference* = ptr byte
  IteratorCategory* = RandomAccessIteratorTag

proc constructMatConstIterator*(): MatConstIterator {.constructor,
    importcpp: "cv::MatConstIterator(@)", header: headermat.}
proc constructMatConstIterator*(m: ptr Mat): MatConstIterator {.constructor,
    importcpp: "cv::MatConstIterator(@)", header: headermat.}
proc constructMatConstIterator*(m: ptr Mat; row: cint; col: cint = 0): MatConstIterator {.
    constructor, importcpp: "cv::MatConstIterator(@)", header: headermat.}
proc constructMatConstIterator*(m: ptr Mat; pt: Point): MatConstIterator {.constructor,
    importcpp: "cv::MatConstIterator(@)", header: headermat.}
proc constructMatConstIterator*(m: ptr Mat; idx: ptr cint): MatConstIterator {.
    constructor, importcpp: "cv::MatConstIterator(@)", header: headermat.}
proc constructMatConstIterator*(it: MatConstIterator): MatConstIterator {.
    constructor, importcpp: "cv::MatConstIterator(@)", header: headermat.}
proc `*`*(this: MatConstIterator): ptr byte {.noSideEffect, importcpp: "(* #)",
    header: headermat.}
proc `[]`*(this: MatConstIterator; i: PtrdiffT): ptr byte {.noSideEffect,
    importcpp: "#[@]", header: headermat.}
proc `+=`*(this: var MatConstIterator; ofs: PtrdiffT) {.importcpp: "(# += #)",
    header: headermat.}
proc `-=`*(this: var MatConstIterator; ofs: PtrdiffT) {.importcpp: "(# -= #)",
    header: headermat.}
proc `--`*(this: var MatConstIterator): var MatConstIterator {.importcpp: "(-- #)",
    header: headermat.}
proc `--`*(this: var MatConstIterator; a3: cint): MatConstIterator {.
    importcpp: "(-- #)", header: headermat.}
proc `++`*(this: var MatConstIterator): var MatConstIterator {.importcpp: "(++ #)",
    header: headermat.}
proc `++`*(this: var MatConstIterator; a3: cint): MatConstIterator {.
    importcpp: "(++ #)", header: headermat.}
proc pos*(this: MatConstIterator): Point {.noSideEffect, importcpp: "pos",
                                       header: headermat.}
proc pos*(this: MatConstIterator; idx: ptr cint) {.noSideEffect, importcpp: "pos",
    header: headermat.}
proc lpos*(this: MatConstIterator): PtrdiffT {.noSideEffect, importcpp: "lpos",
    header: headermat.}
proc seek*(this: var MatConstIterator; ofs: PtrdiffT; relative: bool = false) {.
    importcpp: "seek", header: headermat.}
proc seek*(this: var MatConstIterator; idx: ptr cint; relative: bool = false) {.
    importcpp: "seek", header: headermat.}
type
  MatConstIterator* {.importcpp: "cv::MatConstIterator_", header: headermat, bycopy.}[
      Tp] = object of MatConstIterator
  
  ValueType* = Tp
  DifferenceType* = PtrdiffT
  pointer* = ptr Tp
  Reference* = Tp
  IteratorCategory* = RandomAccessIteratorTag

proc constructMatConstIterator*[Tp](): MatConstIterator[Tp] {.constructor,
    importcpp: "cv::MatConstIterator_(@)", header: headermat.}
proc constructMatConstIterator*[Tp](m: ptr Mat[Tp]): MatConstIterator[Tp] {.
    constructor, importcpp: "cv::MatConstIterator_(@)", header: headermat.}
proc constructMatConstIterator*[Tp](m: ptr Mat[Tp]; row: cint; col: cint = 0): MatConstIterator[
    Tp] {.constructor, importcpp: "cv::MatConstIterator_(@)", header: headermat.}
proc constructMatConstIterator*[Tp](m: ptr Mat[Tp]; pt: Point): MatConstIterator[Tp] {.
    constructor, importcpp: "cv::MatConstIterator_(@)", header: headermat.}
proc constructMatConstIterator*[Tp](m: ptr Mat[Tp]; idx: ptr cint): MatConstIterator[Tp] {.
    constructor, importcpp: "cv::MatConstIterator_(@)", header: headermat.}
proc constructMatConstIterator*[Tp](it: MatConstIterator): MatConstIterator[Tp] {.
    constructor, importcpp: "cv::MatConstIterator_(@)", header: headermat.}
proc `*`*[Tp](this: MatConstIterator[Tp]): Tp {.noSideEffect, importcpp: "(* #)",
    header: headermat.}
proc `[]`*[Tp](this: MatConstIterator[Tp]; i: PtrdiffT): Tp {.noSideEffect,
    importcpp: "#[@]", header: headermat.}
proc `+=`*[Tp](this: var MatConstIterator[Tp]; ofs: PtrdiffT) {.importcpp: "(# += #)",
    header: headermat.}
proc `-=`*[Tp](this: var MatConstIterator[Tp]; ofs: PtrdiffT) {.importcpp: "(# -= #)",
    header: headermat.}
proc `--`*[Tp](this: var MatConstIterator[Tp]): var MatConstIterator {.
    importcpp: "(-- #)", header: headermat.}
proc `--`*[Tp](this: var MatConstIterator[Tp]; a3: cint): MatConstIterator {.
    importcpp: "(-- #)", header: headermat.}
proc `++`*[Tp](this: var MatConstIterator[Tp]): var MatConstIterator {.
    importcpp: "(++ #)", header: headermat.}
proc `++`*[Tp](this: var MatConstIterator[Tp]; a3: cint): MatConstIterator {.
    importcpp: "(++ #)", header: headermat.}
proc pos*[Tp](this: MatConstIterator[Tp]): Point {.noSideEffect, importcpp: "pos",
    header: headermat.}
type
  IteratorCategory* = RandomAccessIteratorTag

proc constructMatIterator*[Tp](): MatIterator[Tp] {.constructor,
    importcpp: "cv::MatIterator_(@)", header: headermat.}
proc constructMatIterator*[Tp](m: ptr Mat[Tp]): MatIterator[Tp] {.constructor,
    importcpp: "cv::MatIterator_(@)", header: headermat.}
proc constructMatIterator*[Tp](m: ptr Mat[Tp]; row: cint; col: cint = 0): MatIterator[Tp] {.
    constructor, importcpp: "cv::MatIterator_(@)", header: headermat.}
proc constructMatIterator*[Tp](m: ptr Mat[Tp]; pt: Point): MatIterator[Tp] {.
    constructor, importcpp: "cv::MatIterator_(@)", header: headermat.}
proc constructMatIterator*[Tp](m: ptr Mat[Tp]; idx: ptr cint): MatIterator[Tp] {.
    constructor, importcpp: "cv::MatIterator_(@)", header: headermat.}
proc constructMatIterator*[Tp](it: MatIterator): MatIterator[Tp] {.constructor,
    importcpp: "cv::MatIterator_(@)", header: headermat.}
proc `*`*[Tp](this: MatIterator[Tp]): var Tp {.noSideEffect, importcpp: "(* #)",
    header: headermat.}
proc `[]`*[Tp](this: MatIterator[Tp]; i: PtrdiffT): var Tp {.noSideEffect,
    importcpp: "#[@]", header: headermat.}
proc `+=`*[Tp](this: var MatIterator[Tp]; ofs: PtrdiffT) {.importcpp: "(# += #)",
    header: headermat.}
proc `-=`*[Tp](this: var MatIterator[Tp]; ofs: PtrdiffT) {.importcpp: "(# -= #)",
    header: headermat.}
proc `--`*[Tp](this: var MatIterator[Tp]): var MatIterator {.importcpp: "(-- #)",
    header: headermat.}
proc `--`*[Tp](this: var MatIterator[Tp]; a3: cint): MatIterator {.importcpp: "(-- #)",
    header: headermat.}
proc `++`*[Tp](this: var MatIterator[Tp]): var MatIterator {.importcpp: "(++ #)",
    header: headermat.}
proc `++`*[Tp](this: var MatIterator[Tp]; a3: cint): MatIterator {.importcpp: "(++ #)",
    header: headermat.}

proc constructSparseMatConstIterator*(): SparseMatConstIterator {.constructor,
    importcpp: "cv::SparseMatConstIterator(@)", header: headermat.}
proc constructSparseMatConstIterator*(m: ptr SparseMat): SparseMatConstIterator {.
    constructor, importcpp: "cv::SparseMatConstIterator(@)", header: headermat.}
proc constructSparseMatConstIterator*(it: SparseMatConstIterator): SparseMatConstIterator {.
    constructor, importcpp: "cv::SparseMatConstIterator(@)", header: headermat.}
proc value*[Tp](this: SparseMatConstIterator): Tp {.noSideEffect, importcpp: "value",
    header: headermat.}
proc node*(this: SparseMatConstIterator): ptr Node {.noSideEffect, importcpp: "node",
    header: headermat.}
proc `--`*(this: var SparseMatConstIterator): var SparseMatConstIterator {.
    importcpp: "(-- #)", header: headermat.}
proc `--`*(this: var SparseMatConstIterator; a3: cint): SparseMatConstIterator {.
    importcpp: "(-- #)", header: headermat.}
proc `++`*(this: var SparseMatConstIterator): var SparseMatConstIterator {.
    importcpp: "(++ #)", header: headermat.}
proc `++`*(this: var SparseMatConstIterator; a3: cint): SparseMatConstIterator {.
    importcpp: "(++ #)", header: headermat.}
proc seekEnd*(this: var SparseMatConstIterator) {.importcpp: "seekEnd",
    header: headermat.}

proc constructSparseMatIterator*(): SparseMatIterator {.constructor,
    importcpp: "cv::SparseMatIterator(@)", header: headermat.}
proc constructSparseMatIterator*(m: ptr SparseMat): SparseMatIterator {.constructor,
    importcpp: "cv::SparseMatIterator(@)", header: headermat.}
proc constructSparseMatIterator*(m: ptr SparseMat; idx: ptr cint): SparseMatIterator {.
    constructor, importcpp: "cv::SparseMatIterator(@)", header: headermat.}
proc constructSparseMatIterator*(it: SparseMatIterator): SparseMatIterator {.
    constructor, importcpp: "cv::SparseMatIterator(@)", header: headermat.}
proc value*[Tp](this: SparseMatIterator): var Tp {.noSideEffect, importcpp: "value",
    header: headermat.}
proc node*(this: SparseMatIterator): ptr Node {.noSideEffect, importcpp: "node",
    header: headermat.}
proc `++`*(this: var SparseMatIterator): var SparseMatIterator {.importcpp: "(++ #)",
    header: headermat.}
proc `++`*(this: var SparseMatIterator; a3: cint): SparseMatIterator {.
    importcpp: "(++ #)", header: headermat.}
type
  SparseMatConstIterator* {.importcpp: "cv::SparseMatConstIterator_",
                           header: headermat, bycopy.}[Tp] = object of SparseMatConstIterator
  
  IteratorCategory* = ForwardIteratorTag

proc constructSparseMatConstIterator*[Tp](): SparseMatConstIterator[Tp] {.
    constructor, importcpp: "cv::SparseMatConstIterator_(@)", header: headermat.}
proc constructSparseMatConstIterator*[Tp](m: ptr SparseMat[Tp]): SparseMatConstIterator[
    Tp] {.constructor, importcpp: "cv::SparseMatConstIterator_(@)",
         header: headermat.}
proc constructSparseMatConstIterator*[Tp](m: ptr SparseMat): SparseMatConstIterator[
    Tp] {.constructor, importcpp: "cv::SparseMatConstIterator_(@)",
         header: headermat.}
proc constructSparseMatConstIterator*[Tp](it: SparseMatConstIterator): SparseMatConstIterator[
    Tp] {.constructor, importcpp: "cv::SparseMatConstIterator_(@)",
         header: headermat.}
proc `*`*[Tp](this: SparseMatConstIterator[Tp]): Tp {.noSideEffect,
    importcpp: "(* #)", header: headermat.}
proc `++`*[Tp](this: var SparseMatConstIterator[Tp]): var SparseMatConstIterator {.
    importcpp: "(++ #)", header: headermat.}
proc `++`*[Tp](this: var SparseMatConstIterator[Tp]; a3: cint): SparseMatConstIterator {.
    importcpp: "(++ #)", header: headermat.}

proc constructSparseMatIterator*[Tp](): SparseMatIterator[Tp] {.constructor,
    importcpp: "cv::SparseMatIterator_(@)", header: headermat.}
proc constructSparseMatIterator*[Tp](m: ptr SparseMat[Tp]): SparseMatIterator[Tp] {.
    constructor, importcpp: "cv::SparseMatIterator_(@)", header: headermat.}
proc constructSparseMatIterator*[Tp](m: ptr SparseMat): SparseMatIterator[Tp] {.
    constructor, importcpp: "cv::SparseMatIterator_(@)", header: headermat.}
proc constructSparseMatIterator*[Tp](it: SparseMatIterator): SparseMatIterator[Tp] {.
    constructor, importcpp: "cv::SparseMatIterator_(@)", header: headermat.}
proc `*`*[Tp](this: SparseMatIterator[Tp]): var Tp {.noSideEffect, importcpp: "(* #)",
    header: headermat.}
proc `++`*[Tp](this: var SparseMatIterator[Tp]): var SparseMatIterator {.
    importcpp: "(++ #)", header: headermat.}
proc `++`*[Tp](this: var SparseMatIterator[Tp]; a3: cint): SparseMatIterator {.
    importcpp: "(++ #)", header: headermat.}
type
  NAryMatIterator* {.importcpp: "cv::NAryMatIterator", header: headermat, bycopy.} = object
    arrays* {.importc: "arrays".}: ptr ptr Mat
    planes* {.importc: "planes".}: ptr Mat
    ptrs* {.importc: "ptrs".}: ptr ptr byte
    narrays* {.importc: "narrays".}: cint
    nplanes* {.importc: "nplanes".}: csize
    size* {.importc: "size".}: csize
  

proc constructNAryMatIterator*(): NAryMatIterator {.constructor,
    importcpp: "cv::NAryMatIterator(@)", header: headermat.}
proc constructNAryMatIterator*(arrays: ptr ptr Mat; ptrs: ptr ptr byte;
                              narrays: cint = -1): NAryMatIterator {.constructor,
    importcpp: "cv::NAryMatIterator(@)", header: headermat.}
proc constructNAryMatIterator*(arrays: ptr ptr Mat; planes: ptr Mat; narrays: cint = -1): NAryMatIterator {.
    constructor, importcpp: "cv::NAryMatIterator(@)", header: headermat.}
proc init*(this: var NAryMatIterator; arrays: ptr ptr Mat; planes: ptr Mat;
          ptrs: ptr ptr byte; narrays: cint = -1) {.importcpp: "init", header: headermat.}
proc `++`*(this: var NAryMatIterator): var NAryMatIterator {.importcpp: "(++ #)",
    header: headermat.}
proc `++`*(this: var NAryMatIterator; a3: cint): NAryMatIterator {.importcpp: "(++ #)",
    header: headermat.}

proc constructMatOp*(): MatOp {.constructor, importcpp: "cv::MatOp(@)",
                             header: headermat.}
proc destroyMatOp*(this: var MatOp) {.importcpp: "#.~MatOp()", header: headermat.}
proc elementWise*(this: MatOp; expr: MatExpr): bool {.noSideEffect,
    importcpp: "elementWise", header: headermat.}
proc assign*(this: MatOp; expr: MatExpr; m: var Mat; `type`: cint = -1) {.noSideEffect,
    importcpp: "assign", header: headermat.}
proc roi*(this: MatOp; expr: MatExpr; rowRange: Range; colRange: Range; res: var MatExpr) {.
    noSideEffect, importcpp: "roi", header: headermat.}
proc diag*(this: MatOp; expr: MatExpr; d: cint; res: var MatExpr) {.noSideEffect,
    importcpp: "diag", header: headermat.}
proc augAssignAdd*(this: MatOp; expr: MatExpr; m: var Mat) {.noSideEffect,
    importcpp: "augAssignAdd", header: headermat.}
proc augAssignSubtract*(this: MatOp; expr: MatExpr; m: var Mat) {.noSideEffect,
    importcpp: "augAssignSubtract", header: headermat.}
proc augAssignMultiply*(this: MatOp; expr: MatExpr; m: var Mat) {.noSideEffect,
    importcpp: "augAssignMultiply", header: headermat.}
proc augAssignDivide*(this: MatOp; expr: MatExpr; m: var Mat) {.noSideEffect,
    importcpp: "augAssignDivide", header: headermat.}
proc augAssignAnd*(this: MatOp; expr: MatExpr; m: var Mat) {.noSideEffect,
    importcpp: "augAssignAnd", header: headermat.}
proc augAssignOr*(this: MatOp; expr: MatExpr; m: var Mat) {.noSideEffect,
    importcpp: "augAssignOr", header: headermat.}
proc augAssignXor*(this: MatOp; expr: MatExpr; m: var Mat) {.noSideEffect,
    importcpp: "augAssignXor", header: headermat.}
proc add*(this: MatOp; expr1: MatExpr; expr2: MatExpr; res: var MatExpr) {.noSideEffect,
    importcpp: "add", header: headermat.}
proc add*(this: MatOp; expr1: MatExpr; s: Scalar; res: var MatExpr) {.noSideEffect,
    importcpp: "add", header: headermat.}
proc subtract*(this: MatOp; expr1: MatExpr; expr2: MatExpr; res: var MatExpr) {.
    noSideEffect, importcpp: "subtract", header: headermat.}
proc subtract*(this: MatOp; s: Scalar; expr: MatExpr; res: var MatExpr) {.noSideEffect,
    importcpp: "subtract", header: headermat.}
proc multiply*(this: MatOp; expr1: MatExpr; expr2: MatExpr; res: var MatExpr;
              scale: cdouble = 1) {.noSideEffect, importcpp: "multiply",
                                header: headermat.}
proc multiply*(this: MatOp; expr1: MatExpr; s: cdouble; res: var MatExpr) {.noSideEffect,
    importcpp: "multiply", header: headermat.}
proc divide*(this: MatOp; expr1: MatExpr; expr2: MatExpr; res: var MatExpr;
            scale: cdouble = 1) {.noSideEffect, importcpp: "divide", header: headermat.}
proc divide*(this: MatOp; s: cdouble; expr: MatExpr; res: var MatExpr) {.noSideEffect,
    importcpp: "divide", header: headermat.}
proc abs*(this: MatOp; expr: MatExpr; res: var MatExpr) {.noSideEffect, importcpp: "abs",
    header: headermat.}
proc transpose*(this: MatOp; expr: MatExpr; res: var MatExpr) {.noSideEffect,
    importcpp: "transpose", header: headermat.}
proc matmul*(this: MatOp; expr1: MatExpr; expr2: MatExpr; res: var MatExpr) {.
    noSideEffect, importcpp: "matmul", header: headermat.}
proc invert*(this: MatOp; expr: MatExpr; `method`: cint; res: var MatExpr) {.noSideEffect,
    importcpp: "invert", header: headermat.}
proc size*(this: MatOp; expr: MatExpr): Size {.noSideEffect, importcpp: "size",
    header: headermat.}
proc `type`*(this: MatOp; expr: MatExpr): cint {.noSideEffect, importcpp: "type",
    header: headermat.}

proc constructMatExpr*(): MatExpr {.constructor, importcpp: "cv::MatExpr(@)",
                                 header: headermat.}
proc constructMatExpr*(m: Mat): MatExpr {.constructor, importcpp: "cv::MatExpr(@)",
                                      header: headermat.}
proc constructMatExpr*(op: ptr MatOp; flags: cint; a: Mat = constructMat();
                      b: Mat = constructMat(); c: Mat = constructMat();
                      alpha: cdouble = 1; beta: cdouble = 1; s: Scalar = scalar()): MatExpr {.
    constructor, importcpp: "cv::MatExpr(@)", header: headermat.}
converter `mat`*(this: MatExpr): Mat {.noSideEffect,
                                   importcpp: "MatExpr::operator Mat",
                                   header: headermat.}
converter `mat`*[Tp](this: MatExpr): Mat[Tp] {.noSideEffect,
    importcpp: "MatExpr::operator Mat_", header: headermat.}
proc size*(this: MatExpr): Size {.noSideEffect, importcpp: "size", header: headermat.}
proc `type`*(this: MatExpr): cint {.noSideEffect, importcpp: "type", header: headermat.}
proc row*(this: MatExpr; y: cint): MatExpr {.noSideEffect, importcpp: "row",
                                       header: headermat.}
proc col*(this: MatExpr; x: cint): MatExpr {.noSideEffect, importcpp: "col",
                                       header: headermat.}
proc diag*(this: MatExpr; d: cint = 0): MatExpr {.noSideEffect, importcpp: "diag",
    header: headermat.}
proc `()`*(this: MatExpr; rowRange: Range; colRange: Range): MatExpr {.noSideEffect,
    importcpp: "#(@)", header: headermat.}
proc `()`*(this: MatExpr; roi: Rect): MatExpr {.noSideEffect, importcpp: "#(@)",
    header: headermat.}
proc t*(this: MatExpr): MatExpr {.noSideEffect, importcpp: "t", header: headermat.}
# proc inv*(this: MatExpr; `method`: cint = decomp_Lu): MatExpr {.noSideEffect,
#     importcpp: "inv", header: headermat.}
proc mul*(this: MatExpr; e: MatExpr; scale: cdouble = 1): MatExpr {.noSideEffect,
    importcpp: "mul", header: headermat.}
proc mul*(this: MatExpr; m: Mat; scale: cdouble = 1): MatExpr {.noSideEffect,
    importcpp: "mul", header: headermat.}
proc cross*(this: MatExpr; m: Mat): Mat {.noSideEffect, importcpp: "cross",
                                    header: headermat.}
proc dot*(this: MatExpr; m: Mat): cdouble {.noSideEffect, importcpp: "dot",
                                      header: headermat.}
proc `+`*(a: Mat; b: Mat): MatExpr {.importcpp: "(# + #)", header: headermat.}
proc `+`*(a: Mat; s: Scalar): MatExpr {.importcpp: "(# + #)", header: headermat.}
proc `+`*(s: Scalar; a: Mat): MatExpr {.importcpp: "(# + #)", header: headermat.}
proc `+`*(e: MatExpr; m: Mat): MatExpr {.importcpp: "(# + #)", header: headermat.}
proc `+`*(m: Mat; e: MatExpr): MatExpr {.importcpp: "(# + #)", header: headermat.}
proc `+`*(e: MatExpr; s: Scalar): MatExpr {.importcpp: "(# + #)", header: headermat.}
proc `+`*(s: Scalar; e: MatExpr): MatExpr {.importcpp: "(# + #)", header: headermat.}
proc `+`*(e1: MatExpr; e2: MatExpr): MatExpr {.importcpp: "(# + #)", header: headermat.}
proc `-`*(a: Mat; b: Mat): MatExpr {.importcpp: "(# - #)", header: headermat.}
proc `-`*(a: Mat; s: Scalar): MatExpr {.importcpp: "(# - #)", header: headermat.}
proc `-`*(s: Scalar; a: Mat): MatExpr {.importcpp: "(# - #)", header: headermat.}
proc `-`*(e: MatExpr; m: Mat): MatExpr {.importcpp: "(# - #)", header: headermat.}
proc `-`*(m: Mat; e: MatExpr): MatExpr {.importcpp: "(# - #)", header: headermat.}
proc `-`*(e: MatExpr; s: Scalar): MatExpr {.importcpp: "(# - #)", header: headermat.}
proc `-`*(s: Scalar; e: MatExpr): MatExpr {.importcpp: "(# - #)", header: headermat.}
proc `-`*(e1: MatExpr; e2: MatExpr): MatExpr {.importcpp: "(# - #)", header: headermat.}
proc `-`*(m: Mat): MatExpr {.importcpp: "(- #)", header: headermat.}
proc `-`*(e: MatExpr): MatExpr {.importcpp: "(- #)", header: headermat.}
proc `*`*(a: Mat; b: Mat): MatExpr {.importcpp: "(# * #)", header: headermat.}
proc `*`*(a: Mat; s: cdouble): MatExpr {.importcpp: "(# * #)", header: headermat.}
proc `*`*(s: cdouble; a: Mat): MatExpr {.importcpp: "(# * #)", header: headermat.}
proc `*`*(e: MatExpr; m: Mat): MatExpr {.importcpp: "(# * #)", header: headermat.}
proc `*`*(m: Mat; e: MatExpr): MatExpr {.importcpp: "(# * #)", header: headermat.}
proc `*`*(e: MatExpr; s: cdouble): MatExpr {.importcpp: "(# * #)", header: headermat.}
proc `*`*(s: cdouble; e: MatExpr): MatExpr {.importcpp: "(# * #)", header: headermat.}
proc `*`*(e1: MatExpr; e2: MatExpr): MatExpr {.importcpp: "(# * #)", header: headermat.}
proc `/`*(a: Mat; b: Mat): MatExpr {.importcpp: "(# / #)", header: headermat.}
proc `/`*(a: Mat; s: cdouble): MatExpr {.importcpp: "(# / #)", header: headermat.}
proc `/`*(s: cdouble; a: Mat): MatExpr {.importcpp: "(# / #)", header: headermat.}
proc `/`*(e: MatExpr; m: Mat): MatExpr {.importcpp: "(# / #)", header: headermat.}
proc `/`*(m: Mat; e: MatExpr): MatExpr {.importcpp: "(# / #)", header: headermat.}
proc `/`*(e: MatExpr; s: cdouble): MatExpr {.importcpp: "(# / #)", header: headermat.}
proc `/`*(s: cdouble; e: MatExpr): MatExpr {.importcpp: "(# / #)", header: headermat.}
proc `/`*(e1: MatExpr; e2: MatExpr): MatExpr {.importcpp: "(# / #)", header: headermat.}
proc `<`*(a: Mat; b: Mat): MatExpr {.importcpp: "(# < #)", header: headermat.}
proc `<`*(a: Mat; s: cdouble): MatExpr {.importcpp: "(# < #)", header: headermat.}
proc `<`*(s: cdouble; a: Mat): MatExpr {.importcpp: "(# < #)", header: headermat.}
proc `<=`*(a: Mat; b: Mat): MatExpr {.importcpp: "(# <= #)", header: headermat.}
proc `<=`*(a: Mat; s: cdouble): MatExpr {.importcpp: "(# <= #)", header: headermat.}
proc `<=`*(s: cdouble; a: Mat): MatExpr {.importcpp: "(# <= #)", header: headermat.}
proc `==`*(a: Mat; b: Mat): MatExpr {.importcpp: "(# == #)", header: headermat.}
proc `==`*(a: Mat; s: cdouble): MatExpr {.importcpp: "(# == #)", header: headermat.}
proc `==`*(s: cdouble; a: Mat): MatExpr {.importcpp: "(# == #)", header: headermat.}
proc `&`*(a: Mat; b: Mat): MatExpr {.importcpp: "(# & #)", header: headermat.}
proc `&`*(a: Mat; s: Scalar): MatExpr {.importcpp: "(# & #)", header: headermat.}
proc `&`*(s: Scalar; a: Mat): MatExpr {.importcpp: "(# & #)", header: headermat.}
proc `|`*(a: Mat; b: Mat): MatExpr {.importcpp: "(# | #)", header: headermat.}
proc `|`*(a: Mat; s: Scalar): MatExpr {.importcpp: "(# | #)", header: headermat.}
proc `|`*(s: Scalar; a: Mat): MatExpr {.importcpp: "(# | #)", header: headermat.}
proc `^`*(a: Mat; b: Mat): MatExpr {.importcpp: "(# ^ #)", header: headermat.}
proc `^`*(a: Mat; s: Scalar): MatExpr {.importcpp: "(# ^ #)", header: headermat.}
proc `^`*(s: Scalar; a: Mat): MatExpr {.importcpp: "(# ^ #)", header: headermat.}
proc `~`*(m: Mat): MatExpr {.importcpp: "(~ #)", header: headermat.}
proc min*(a: Mat; b: Mat): MatExpr {.importcpp: "cv::min(@)", header: headermat.}
proc min*(a: Mat; s: cdouble): MatExpr {.importcpp: "cv::min(@)", header: headermat.}
proc min*(s: cdouble; a: Mat): MatExpr {.importcpp: "cv::min(@)", header: headermat.}
proc max*(a: Mat; b: Mat): MatExpr {.importcpp: "cv::max(@)", header: headermat.}
proc max*(a: Mat; s: cdouble): MatExpr {.importcpp: "cv::max(@)", header: headermat.}
proc max*(s: cdouble; a: Mat): MatExpr {.importcpp: "cv::max(@)", header: headermat.}
proc abs*(m: Mat): MatExpr {.importcpp: "cv::abs(@)", header: headermat.}
proc abs*(e: MatExpr): MatExpr {.importcpp: "cv::abs(@)", header: headermat.}