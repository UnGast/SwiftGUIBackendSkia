import SwiftGUIBackendSDL2Skia
import GfxMath
import CSDL2

print("RUNS")


let window = try SDL2SkiaWindow(options: SDL2SkiaWindow.Options(
  title: nil,
  initialSize: DSize2(800, 600),
  initialPosition: .Centered,
  initialVisibility: .Visible,
  background: .black,
  borderless: false
))

SDL_Delay(4000)