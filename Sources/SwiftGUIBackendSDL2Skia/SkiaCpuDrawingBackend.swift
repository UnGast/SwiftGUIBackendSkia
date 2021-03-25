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
}