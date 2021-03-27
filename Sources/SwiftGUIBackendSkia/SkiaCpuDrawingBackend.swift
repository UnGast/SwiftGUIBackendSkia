import VisualAppBase
import CSkia
import GfxMath
import SwiftGUI

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

  func paintToSkia(_ paint: TextPaint) -> (strokePaint: OpaquePointer?, fillPaint: OpaquePointer?) {
    var skiaFillPaint: OpaquePointer?
    if let color = paint.color {
      skiaFillPaint = sk_paint_new()
      sk_paint_set_color(skiaFillPaint, sgui_sk_color_argb(color.a, color.r, color.g, color.b))
    }

    return (strokePaint: nil, fillPaint: skiaFillPaint)
  }

  override open func drawLine(from start: DVec2, to end: DVec2, paint: Paint) {
    let (strokePaint, _) = paintToSkia(paint)
    
    if let strokePaint = strokePaint {
      let pathBuilder = sk_pathbuilder_new()
      sk_pathbuilder_move_to(pathBuilder, Float(start.x), Float(start.y))
      sk_pathbuilder_line_to(pathBuilder, Float(end.x), Float(end.y))
      let path = sk_pathbuilder_detach_path(pathBuilder);
      sk_paint_set_color(strokePaint, sgui_sk_color_argb(255, 100, 50, 100))
      sk_canvas_draw_path(skiaCanvas, path, strokePaint)
    }
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

  override open func drawCircle(center: DVec2, radius: Double, paint: Paint) {
    let (strokePaint, fillPaint) = paintToSkia(paint)
    if let strokePaint = strokePaint {
      sk_canvas_draw_circle(skiaCanvas, Float(center.x), Float(center.y), Float(radius), strokePaint)
    }
    if let fillPaint = fillPaint {
      sk_canvas_draw_circle(skiaCanvas, Float(center.x), Float(center.y), Float(radius), fillPaint)
    }
  }

  override open func drawText(text: String, position: DVec2, paint: TextPaint) {
    var skiaPoint = sk_point_t()
    skiaPoint.x = Float(position.x)
    skiaPoint.y = Float(position.y) + Float(paint.fontConfig.size)
    let (skiaStrokePaint, skiaFillPaint) = paintToSkia(paint)

    let skiaFont = sgui_sk_font_new()
    sgui_sk_font_set_size(skiaFont, Float(paint.fontConfig.size));

    if let skiaStrokePaint = skiaStrokePaint {
      sgui_sk_canvas_draw_text(skiaCanvas, text, skiaPoint, skiaFont, skiaStrokePaint)
    }

    if let skiaFillPaint = skiaFillPaint {
      sgui_sk_canvas_draw_text(skiaCanvas, text, skiaPoint, skiaFont, skiaFillPaint)
    }
  }

  override open func measureText(text: String, paint: TextPaint) -> DSize2 {
    let skiaFont = sgui_sk_font_new()
    sgui_sk_font_set_size(skiaFont, Float(paint.fontConfig.size));
    let width = sgui_sk_font_measure_text(skiaFont, text)
    print("MEASURE TEXT", width)
    return DSize2(Double(width), paint.fontConfig.size)
  }

  override open func clip(rect: DRect) {
  }

  override open func resetClip() {
  }
}