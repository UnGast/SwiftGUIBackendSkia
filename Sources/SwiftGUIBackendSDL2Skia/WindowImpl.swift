import CSDL2
import SwiftGUI

open class SDL2SkiaWindow: Window {
  public var sdlWindow: OpaquePointer

  public required init(options: Options) throws {
    SDL_Init(SDL_INIT_VIDEO)

    let size = ISize2(options.initialSize)

    sdlWindow = SDL_CreateWindow(
      "",
      0,
      0,
      Int32(options.initialSize.width),
      Int32(options.initialSize.height),
      SDL_WINDOW_RESIZABLE.rawValue)

    let renderer = SDL_CreateRenderer(sdlWindow, -1, 0)

    let texture = SDL_CreateTexture(renderer,
                           SDL_PIXELFORMAT_BGRA8888.rawValue,
                           Int32(SDL_TEXTUREACCESS_STREAMING.rawValue), 
                           Int32(size.width),
                           Int32(size.height))
    
    var pixels: UnsafeMutableRawPointer?
    var rowLength: Int32 = 0

    SDL_LockTexture(texture, nil, &pixels, &rowLength)

    var surface = CpuBufferDrawingSurface(size: size)
    surface.buffer = pixels!.bindMemory(to: Int8.self, capacity: size.width * size.height * 4)
    let drawingBackend = SkiaCpuDrawingBackend(surface: surface)

    SDL_UnlockTexture(texture)

    SDL_RenderCopy(renderer, texture, nil, nil)
    SDL_RenderPresent(renderer)

    try super.init(options: options)
  }
}