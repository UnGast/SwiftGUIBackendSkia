import VisualAppBase
import CSkia
import GfxMath

open class SkiaCpuDrawingBackend: DrawingBackend {
  private let surface: CpuBufferDrawingSurface
  private var skiaCanvas: OpaquePointer

  public init(surface: CpuBufferDrawingSurface) {
    self.surface = surface
    testDraw(Int32(surface.size.width), Int32(surface.size.height), surface.buffer)
    self.skiaCanvas = setupCanvas(
      Int32(surface.size.width),
      Int32(surface.size.height),
      surface.buffer)
    testDraw2(skiaCanvas)
  }

  func paintToSkia(_ paint: Paint) -> (strokePaint: OpaquePointer?, fillPaint: OpaquePointer?) {
    var skiaStrokePaint: OpaquePointer?
    if let strokeWidth = paint.strokeWidth, let strokeColor = paint.strokeColor {
      skiaStrokePaint = sk_paint_new()
      sk_paint_set_stroke(skiaStrokePaint!, true)
      sk_paint_set_stroke_width(skiaStrokePaint!, Float(strokeWidth))
      sk_paint_set_color(skiaStrokePaint!, sgui_sk_color_argb(strokeColor.a, strokeColor.r, strokeColor.g, strokeColor.b))
    }
    var skiaFillPaint: OpaquePointer?
    if let color = paint.color {
      skiaFillPaint = sk_paint_new()
      sk_paint_set_color(skiaFillPaint, sgui_sk_color_argb(color.a, color.r, color.g, color.b))
    }

    return (strokePaint: skiaStrokePaint, fillPaint: skiaFillPaint)
  }

  override open func drawLine(from start: DVec2, to end: DVec2, paint: Paint) {
    let pathBuilder = sk_pathbuilder_new()
    sk_pathbuilder_move_to(pathBuilder, Float(start.x), Float(start.y))
    sk_pathbuilder_line_to(pathBuilder, Float(end.x), Float(end.y))
    let path = sk_pathbuilder_detach_path(pathBuilder);
    let paint = sk_paint_new();
    sk_paint_set_stroke(paint, true)
    sk_paint_set_stroke_width(paint, 1)
    sk_paint_set_color(paint, sgui_sk_color_argb(255, 100, 50, 100))
    sk_canvas_draw_path(skiaCanvas, path, paint)
  }

  override open func drawRect(rect: DRect, paint: Paint) {
    var skiaRect = sk_rect_t()
    skiaRect.top = Float(rect.min.y)
    skiaRect.right = Float(rect.max.x)
    skiaRect.bottom = Float(rect.max.y)
    skiaRect.left = Float(rect.min.x)

    let (strokePaint, fillPaint) = paintToSkia(paint)

    if let strokePaint = strokePaint {
      sk_canvas_draw_rect(skiaCanvas, &skiaRect, strokePaint)
    }

    if let fillPaint = fillPaint {
      sk_canvas_draw_rect(skiaCanvas, &skiaRect, fillPaint)
    }
  }
}