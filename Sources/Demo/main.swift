import SwiftGUIBackendSkia
import GfxMath
import CSDL2
import ApplicationBackendSDL2
import Drawing

let applicationBacked = try ApplicationBackendSDL2.getInstance()

print("RUNS")

let window = applicationBacked.createWindow(initialSize: DSize2(400, 400)) as! SDL2Window

let drawingBackend = SkiaCpuDrawingBackend(surface: window.surface)
drawingBackend.drawLine(from: .zero, to: DVec2(200, 200), paint: Paint(color: nil, strokeWidth: 1, strokeColor: .blue))
drawingBackend.drawRect(rect: DRect(min: DVec2(200, 200), max: DVec2(400, 400)), paint: Paint(color: .yellow))
drawingBackend.drawCircle(center: DVec2(150, 150), radius: 100, paint: Paint(color: .green, strokeWidth: 1.0, strokeColor: .red))

window.swap()


/*
let window = try SDL2SkiaWindow(options: SDL2SkiaWindow.Options(
  title: nil,
  initialSize: DSize2(800, 600),
  initialPosition: .Centered,
  initialVisibility: .Visible,
  background: .black,
  borderless: false
))*/

SDL_Delay(2000)