import SwiftGUIBackendSkia
import GfxMath
import CSDL2
import ApplicationBackendSDL2
import Drawing
import SwiftGUI

let applicationBacked = try ApplicationBackendSDL2.getInstance()

print("RUNS")

let window = applicationBacked.createWindow(initialSize: DSize2(400, 400)) as! SDL2Window

try applicationBacked.processEvents(timeout: 500)

let drawingBackend = SkiaCpuDrawingBackend(surface: window.surface)

let drawingContext = DrawingContext(backend: drawingBackend)

let guiRoot = Root(rootWidget: Container().with(styleProperties: {
  (\.$background, .green)
}).withContent {
  Container().with(styleProperties: {
    (\.$width, 200)
    (\.$height, 200)
    (\.$background, .red)
  })

  Container().with(styleProperties: {
    (\.$width, 200)
    (\.$height, 200)
    (\.$background, .white)
  })
})

guiRoot.setup(
  measureText: { _, _ in .zero },
  getKeyStates: { KeyStatesContainer() },
  getApplicationTime: { 0 },
  getRealFps: { 0 },
  requestCursor: { _ in {} })

guiRoot.bounds.size = DSize2(window.size)
guiRoot.tick(Tick(deltaTime: 0, totalTime: 0))
guiRoot.draw(drawingContext)

drawingBackend.drawLine(from: .zero, to: DVec2(200, Double(window.surface.size.height)), paint: Paint(color: nil, strokeWidth: 1, strokeColor: .blue))
drawingBackend.drawRect(rect: DRect(min: DVec2(200, 200), max: DVec2(400, 400)), paint: Paint(color: .yellow))
drawingBackend.drawCircle(center: DVec2(150, 150), radius: 100, paint: Paint(color: .green, strokeWidth: 1.0, strokeColor: .red))
drawingBackend.drawText(text: "Hello World", position: DVec2(200, 200), paint: TextPaint(fontConfig: FontConfig(
  family: defaultFontFamily, size: 48, weight: .regular, style: .normal 
), color: .orange, breakWidth: nil))

window.swap()

SDL_Delay(2000)