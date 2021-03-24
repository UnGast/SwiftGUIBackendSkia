import VisualAppBase
import CSkia

open class SkiaCpuDrawingBackend: DrawingBackend {
  private let surface: CpuBufferDrawingSurface

  public init(surface: CpuBufferDrawingSurface) {
    self.surface = surface
    testDraw(Int32(surface.size.width), Int32(surface.size.height), surface.buffer)
  }
}