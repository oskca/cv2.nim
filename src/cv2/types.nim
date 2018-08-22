import strutils
const sourcePath = currentSourcePath().split({'\\', '/'})[0..^2].join("/")
{.passC: "-I\"" & sourcePath & "headers\"".}
const headertypes = sourcePath & "headers/core/types.hpp"
type
  Complex* {.importcpp: "cv::Complex", header: headertypes, bycopy.}[Tp] = object
    re* {.importc: "re".}: Tp
    im* {.importc: "im".}: Tp


proc constructComplex*[Tp](): Complex[Tp] {.constructor,
    importcpp: "cv::Complex(@)", header: headertypes.}
proc constructComplex*[Tp](re: Tp; im: Tp = 0): Complex[Tp] {.constructor,
    importcpp: "cv::Complex(@)", header: headertypes.}
converter `complex`*[Tp; T2](this: Complex[Tp]): Complex[T2] {.noSideEffect,
    importcpp: "Complex::operator Complex", header: headertypes.}
proc conj*[Tp](this: Complex[Tp]): Complex {.noSideEffect, importcpp: "conj",
    header: headertypes.}
type
  Complexf* = Complex[cfloat]
  Complexd* = Complex[cdouble]
  Rect* {.importcpp: "cv::Rect_", header: headertypes, bycopy.}[Tp] = object
    x* {.importc: "x".}: Tp
    y* {.importc: "y".}: Tp
    width* {.importc: "width".}: Tp
    height* {.importc: "height".}: Tp
  Size* {.importcpp: "cv::Size_", header: headertypes, bycopy.}[Tp] = object
    width* {.importc: "width".}: Tp
    height* {.importc: "height".}: Tp
  Vec* {.importcpp: "cv::Vec", header: headertypes, bycopy.}[Tp:any, Tp2:static[int]] = object of RootObj
  Vector* {.importcpp: "std::vector".} [Tp] = object
  Point* {.importcpp: "cv::Point_", header: headertypes, bycopy.}[Tp] = object
    x* {.importc: "x".}: Tp
    y* {.importc: "y".}: Tp

  

proc constructPoint*[Tp](): Point[Tp] {.constructor, importcpp: "cv::Point_(@)",
                                     header: headertypes.}
proc constructPoint*[Tp](x: Tp; y: Tp): Point[Tp] {.constructor,
    importcpp: "cv::Point_(@)", header: headertypes.}
proc constructPoint*[Tp](pt: Point): Point[Tp] {.constructor,
    importcpp: "cv::Point_(@)", header: headertypes.}
proc constructPoint*[Tp](sz: Size[Tp]): Point[Tp] {.constructor,
    importcpp: "cv::Point_(@)", header: headertypes.}
proc constructPoint*[Tp](v: Vec[Tp, 2]): Point[Tp] {.constructor,
    importcpp: "cv::Point_(@)", header: headertypes.}
converter `point`*[Tp; Tp2](this: Point[Tp]): Point[Tp2] {.noSideEffect,
    importcpp: "Point_::operator Point_", header: headertypes.}
converter `vec`*[Tp](this: Point[Tp]): Vec[Tp, 2] {.noSideEffect,
    importcpp: "Point_::operator Vec", header: headertypes.}
proc dot*[Tp](this: Point[Tp]; pt: Point): Tp {.noSideEffect, importcpp: "dot",
    header: headertypes.}
proc ddot*[Tp](this: Point[Tp]; pt: Point): cdouble {.noSideEffect, importcpp: "ddot",
    header: headertypes.}
proc cross*[Tp](this: Point[Tp]; pt: Point): cdouble {.noSideEffect,
    importcpp: "cross", header: headertypes.}
proc inside*[Tp](this: Point[Tp]; r: Rect[Tp]): bool {.noSideEffect,
    importcpp: "inside", header: headertypes.}
type
  Point2i* = Point[cint]
  Point2l* = Point[int64]
  Point2f* = Point[cfloat]
  Point2d* = Point[cdouble]
  
  Point3* {.importcpp: "cv::Point3_", header: headertypes, bycopy.}[Tp] = object
    x* {.importc: "x".}: Tp
    y* {.importc: "y".}: Tp
    z* {.importc: "z".}: Tp

  

proc constructPoint3*[Tp](): Point3[Tp] {.constructor, importcpp: "cv::Point3_(@)",
                                       header: headertypes.}
proc constructPoint3*[Tp](x: Tp; y: Tp; z: Tp): Point3[Tp] {.constructor,
    importcpp: "cv::Point3_(@)", header: headertypes.}
proc constructPoint3*[Tp](pt: Point3): Point3[Tp] {.constructor,
    importcpp: "cv::Point3_(@)", header: headertypes.}
proc constructPoint3*[Tp](pt: Point[Tp]): Point3[Tp] {.constructor,
    importcpp: "cv::Point3_(@)", header: headertypes.}
proc constructPoint3*[Tp](v: Vec[Tp, 3]): Point3[Tp] {.constructor,
    importcpp: "cv::Point3_(@)", header: headertypes.}
converter `point3`*[Tp; Tp2](this: Point3[Tp]): Point3[Tp2] {.noSideEffect,
    importcpp: "Point3_::operator Point3_", header: headertypes.}
converter `vec`*[Tp](this: Point3[Tp]): Vec[Tp, 3] {.noSideEffect,
    importcpp: "Point3_::operator Vec", header: headertypes.}
proc dot*[Tp](this: Point3[Tp]; pt: Point3): Tp {.noSideEffect, importcpp: "dot",
    header: headertypes.}
proc ddot*[Tp](this: Point3[Tp]; pt: Point3): cdouble {.noSideEffect,
    importcpp: "ddot", header: headertypes.}
proc cross*[Tp](this: Point3[Tp]; pt: Point3): Point3 {.noSideEffect,
    importcpp: "cross", header: headertypes.}
type
  Point3i* = Point3[cint]
  Point3f* = Point3[cfloat]
  Point3d* = Point3[cdouble]

  

proc constructSize*[Tp](): Size[Tp] {.constructor, importcpp: "cv::Size_(@)",
                                   header: headertypes.}
proc constructSize*[Tp](width: Tp; height: Tp): Size[Tp] {.constructor,
    importcpp: "cv::Size_(@)", header: headertypes.}
proc constructSize*[Tp](sz: Size): Size[Tp] {.constructor, importcpp: "cv::Size_(@)",
    header: headertypes.}
proc constructSize*[Tp](pt: Point[Tp]): Size[Tp] {.constructor,
    importcpp: "cv::Size_(@)", header: headertypes.}
proc area*[Tp](this: Size[Tp]): Tp {.noSideEffect, importcpp: "area",
                                 header: headertypes.}
proc empty*[Tp](this: Size[Tp]): bool {.noSideEffect, importcpp: "empty",
                                    header: headertypes.}
converter `size`*[Tp; Tp2](this: Size[Tp]): Size[Tp2] {.noSideEffect,
    importcpp: "Size_::operator Size_", header: headertypes.}
type
  Size2i* = Size[cint]
  Size2l* = Size[int64]
  Size2f* = Size[cfloat]
  Size2d* = Size[cdouble]
  

  

proc constructRect*[Tp](): Rect[Tp] {.constructor, importcpp: "cv::Rect_(@)",
                                   header: headertypes.}
proc constructRect*[Tp](x: Tp; y: Tp; width: Tp; height: Tp): Rect[Tp] {.constructor,
    importcpp: "cv::Rect_(@)", header: headertypes.}
proc constructRect*[Tp](r: Rect): Rect[Tp] {.constructor, importcpp: "cv::Rect_(@)",
    header: headertypes.}
proc constructRect*[Tp](org: Point[Tp]; sz: Size[Tp]): Rect[Tp] {.constructor,
    importcpp: "cv::Rect_(@)", header: headertypes.}
proc constructRect*[Tp](pt1: Point[Tp]; pt2: Point[Tp]): Rect[Tp] {.constructor,
    importcpp: "cv::Rect_(@)", header: headertypes.}
proc tl*[Tp](this: Rect[Tp]): Point[Tp] {.noSideEffect, importcpp: "tl",
                                      header: headertypes.}
proc br*[Tp](this: Rect[Tp]): Point[Tp] {.noSideEffect, importcpp: "br",
                                      header: headertypes.}
proc size*[Tp](this: Rect[Tp]): Size[Tp] {.noSideEffect, importcpp: "size",
                                       header: headertypes.}
proc area*[Tp](this: Rect[Tp]): Tp {.noSideEffect, importcpp: "area",
                                 header: headertypes.}
proc empty*[Tp](this: Rect[Tp]): bool {.noSideEffect, importcpp: "empty",
                                    header: headertypes.}
converter `rect`*[Tp; Tp2](this: Rect[Tp]): Rect[Tp2] {.noSideEffect,
    importcpp: "Rect_::operator Rect_", header: headertypes.}
proc contains*[Tp](this: Rect[Tp]; pt: Point[Tp]): bool {.noSideEffect,
    importcpp: "contains", header: headertypes.}
type
  Rect2i* = Rect[cint]
  Rect2f* = Rect[cfloat]
  Rect2d* = Rect[cdouble]
  
  RotatedRect* {.importcpp: "cv::RotatedRect", header: headertypes, bycopy.} = object
    center* {.importc: "center".}: Point2f
    size* {.importc: "size".}: Size2f
    angle* {.importc: "angle".}: cfloat


proc constructRotatedRect*(): RotatedRect {.constructor,
    importcpp: "cv::RotatedRect(@)", header: headertypes.}
proc constructRotatedRect*(center: Point2f; size: Size2f; angle: cfloat): RotatedRect {.
    constructor, importcpp: "cv::RotatedRect(@)", header: headertypes.}
proc constructRotatedRect*(point1: Point2f; point2: Point2f; point3: Point2f): RotatedRect {.
    constructor, importcpp: "cv::RotatedRect(@)", header: headertypes.}
proc points*(this: RotatedRect; pts: ptr Point2f) {.noSideEffect, importcpp: "points",
    header: headertypes.}
proc boundingRect*(this: RotatedRect): Rect {.noSideEffect,
    importcpp: "boundingRect", header: headertypes.}
proc boundingRect2f*(this: RotatedRect): Rect[cfloat] {.noSideEffect,
    importcpp: "boundingRect2f", header: headertypes.}
type
  Range* {.importcpp: "cv::Range", header: headertypes, bycopy.} = object
    start* {.importc: "start".}: cint
    `end`* {.importc: "end".}: cint


proc constructRange*(): Range {.constructor, importcpp: "cv::Range(@)",
                             header: headertypes.}
proc constructRange*(start: cint; `end`: cint): Range {.constructor,
    importcpp: "cv::Range(@)", header: headertypes.}
proc size*(this: Range): cint {.noSideEffect, importcpp: "size", header: headertypes.}
proc empty*(this: Range): bool {.noSideEffect, importcpp: "empty", header: headertypes.}
proc all*(): Range {.importcpp: "cv::Range::all(@)", header: headertypes.}
type
  Scalar* {.importcpp: "cv::Scalar_", header: headertypes, bycopy.}[Tp] = object of Vec[
      Tp, 4]
  

proc constructScalar*[Tp](): Scalar[Tp] {.constructor, importcpp: "cv::Scalar_(@)",
                                       header: headertypes.}
proc constructScalar*[Tp](v0: Tp; v1: Tp; v2: Tp = 0; v3: Tp = 0): Scalar[Tp] {.constructor,
    importcpp: "cv::Scalar_(@)", header: headertypes.}
proc constructScalar*[Tp](v0: Tp): Scalar[Tp] {.constructor,
    importcpp: "cv::Scalar_(@)", header: headertypes.}
proc constructScalar*[Tp; Tp2; Cn: static[cint]](v: Vec[Tp2, Cn]): Scalar[Tp] {.
    constructor, importcpp: "cv::Scalar_(@)", header: headertypes.}
proc all*[Tp](v0: Tp): Scalar[Tp] {.importcpp: "cv::Scalar_::all(@)",
                                header: headertypes.}
converter `scalar`*[Tp; T2](this: Scalar[Tp]): Scalar[T2] {.noSideEffect,
    importcpp: "Scalar_::operator Scalar_", header: headertypes.}
proc mul*[Tp](this: Scalar[Tp]; a: Scalar[Tp]; scale: cdouble = 1): Scalar[Tp] {.
    noSideEffect, importcpp: "mul", header: headertypes.}
proc conj*[Tp](this: Scalar[Tp]): Scalar[Tp] {.noSideEffect, importcpp: "conj",
    header: headertypes.}
proc isReal*[Tp](this: Scalar[Tp]): bool {.noSideEffect, importcpp: "isReal",
                                       header: headertypes.}
type
  
  KeyPoint* {.importcpp: "cv::KeyPoint", header: headertypes, bycopy.} = object
    pt* {.importc: "pt".}: Point2f
    size* {.importc: "size".}: cfloat
    angle* {.importc: "angle".}: cfloat
    response* {.importc: "response".}: cfloat
    octave* {.importc: "octave".}: cint
    classId* {.importc: "class_id".}: cint


proc constructKeyPoint*(): KeyPoint {.constructor, importcpp: "cv::KeyPoint(@)",
                                   header: headertypes.}
proc constructKeyPoint*(pt: Point2f; size: cfloat; angle: cfloat = -1;
                       response: cfloat = 0; octave: cint = 0; classId: cint = -1): KeyPoint {.
    constructor, importcpp: "cv::KeyPoint(@)", header: headertypes.}
proc constructKeyPoint*(x: cfloat; y: cfloat; size: cfloat; angle: cfloat = -1;
                       response: cfloat = 0; octave: cint = 0; classId: cint = -1): KeyPoint {.
    constructor, importcpp: "cv::KeyPoint(@)", header: headertypes.}
proc hash*(this: KeyPoint): csize {.noSideEffect, importcpp: "hash",
                                header: headertypes.}
proc convert*(keypoints: Vector[KeyPoint]; points2f: var Vector[Point2f];
             keypointIndexes: Vector[cint] = Vector[cint]()) {.
    importcpp: "cv::KeyPoint::convert(@)", header: headertypes.}
proc convert*(points2f: Vector[Point2f]; keypoints: var Vector[KeyPoint];
             size: cfloat = 1; response: cfloat = 1; octave: cint = 0; classId: cint = -1) {.
    importcpp: "cv::KeyPoint::convert(@)", header: headertypes.}
proc overlap*(kp1: KeyPoint; kp2: KeyPoint): cfloat {.
    importcpp: "cv::KeyPoint::overlap(@)", header: headertypes.}
type
  DMatch* {.importcpp: "cv::DMatch", header: headertypes, bycopy.} = object
    queryIdx* {.importc: "queryIdx".}: cint
    trainIdx* {.importc: "trainIdx".}: cint
    imgIdx* {.importc: "imgIdx".}: cint
    distance* {.importc: "distance".}: cfloat


proc constructDMatch*(): DMatch {.constructor, importcpp: "cv::DMatch(@)",
                               header: headertypes.}
proc constructDMatch*(queryIdx: cint; trainIdx: cint; distance: cfloat): DMatch {.
    constructor, importcpp: "cv::DMatch(@)", header: headertypes.}
proc constructDMatch*(queryIdx: cint; trainIdx: cint; imgIdx: cint; distance: cfloat): DMatch {.
    constructor, importcpp: "cv::DMatch(@)", header: headertypes.}
proc `<`*(this: DMatch; m: DMatch): bool {.noSideEffect, importcpp: "(# < #)",
                                     header: headertypes.}
type
  TermCriteria* {.importcpp: "cv::TermCriteria", header: headertypes, bycopy.} = object
    `type`* {.importc: "type".}: cint
    maxCount* {.importc: "maxCount".}: cint
    epsilon* {.importc: "epsilon".}: cdouble

  Type* {.size: sizeof(cint), importcpp: "cv::TermCriteria::Type",
         header: headertypes.} = enum
    COUNT = 1, EPS = 2


proc constructTermCriteria*(): TermCriteria {.constructor,
    importcpp: "cv::TermCriteria(@)", header: headertypes.}
proc constructTermCriteria*(`type`: cint; maxCount: cint; epsilon: cdouble): TermCriteria {.
    constructor, importcpp: "cv::TermCriteria(@)", header: headertypes.}
type
  Moments* {.importcpp: "cv::Moments", header: headertypes, bycopy.} = object
    m00* {.importc: "m00".}: cdouble
    m10* {.importc: "m10".}: cdouble
    m01* {.importc: "m01".}: cdouble
    m20* {.importc: "m20".}: cdouble
    m11* {.importc: "m11".}: cdouble
    m02* {.importc: "m02".}: cdouble
    m30* {.importc: "m30".}: cdouble
    m21* {.importc: "m21".}: cdouble
    m12* {.importc: "m12".}: cdouble
    m03* {.importc: "m03".}: cdouble
    mu20* {.importc: "mu20".}: cdouble
    mu11* {.importc: "mu11".}: cdouble
    mu02* {.importc: "mu02".}: cdouble
    mu30* {.importc: "mu30".}: cdouble
    mu21* {.importc: "mu21".}: cdouble
    mu12* {.importc: "mu12".}: cdouble
    mu03* {.importc: "mu03".}: cdouble
    nu20* {.importc: "nu20".}: cdouble
    nu11* {.importc: "nu11".}: cdouble
    nu02* {.importc: "nu02".}: cdouble
    nu30* {.importc: "nu30".}: cdouble
    nu21* {.importc: "nu21".}: cdouble
    nu12* {.importc: "nu12".}: cdouble
    nu03* {.importc: "nu03".}: cdouble


proc constructMoments*(): Moments {.constructor, importcpp: "cv::Moments(@)",
                                 header: headertypes.}
proc constructMoments*(m00: cdouble; m10: cdouble; m01: cdouble; m20: cdouble;
                      m11: cdouble; m02: cdouble; m30: cdouble; m21: cdouble;
                      m12: cdouble; m03: cdouble): Moments {.constructor,
    importcpp: "cv::Moments(@)", header: headertypes.}