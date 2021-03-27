#include <stdio.h>
//#include "include/gpu/GrDirectContext.h"
//#include "include/gpu/vk/GrVkBackendContext.h"
//#include "include/core/SkData.h"
#include "SkCanvas.h"
#include "include/core/SkImage.h"
//#include "include/core/SkStream.h"
#include "SkRect.h"
#include "SkPaint.h"
#include "include/core/SkSurface.h"
#include "SkSurface.h"
#include "SkTextBlob.h"
#include "SkFont.h"
#include "include/c/sk_canvas.h"
#include "include/c/sk_surface.h"
#include "CSkia/types.h"

static sk_sp<SkSurface> theSurface = NULL;

extern "C" {
  void testDraw(int width, int height, char* buffer) {
    SkImageInfo info = SkImageInfo::MakeN32Premul(width, height);
    size_t rowBytes = info.minRowBytes();
    size_t size = info.computeByteSize(rowBytes);
    sk_sp<SkSurface> surface =
            SkSurface::MakeRasterDirect(
                    info, buffer, rowBytes);
    SkCanvas* canvas = surface->getCanvas();
    SkRect rect = SkRect::MakeXYWH(0.0f, 0.0f, 181.0f, 181.0f);
    SkPaint paint;
    paint.setColor(SK_ColorBLUE);
    canvas->drawRect(rect, paint);
  }

  void testDraw2(sk_canvas_t* _canvas) {
    auto canvas = reinterpret_cast<SkCanvas*>(_canvas);
    SkRect rect = SkRect::MakeXYWH(40.0f, 80.0f, 11.0f, 181.0f);
    SkPaint paint;
    paint.setColor(SK_ColorBLUE);
    canvas->drawRect(rect, paint);
  }

  sk_canvas_t* setupCanvas(int width, int height, char* buffer) {
    SkImageInfo info = SkImageInfo::MakeN32Premul(width, height);
    size_t rowBytes = info.minRowBytes();
    size_t size = info.computeByteSize(rowBytes);
    sk_sp<SkSurface> surface =
            SkSurface::MakeRasterDirect(
                    info, buffer, rowBytes);
    SkCanvas* canvas = surface->getCanvas();
    theSurface = surface;
    return reinterpret_cast<sk_canvas_t*>(canvas);
  }

  void sgui_sk_canvas_draw_text(sk_canvas_t* _canvas, const char* _text, sk_point_t bottom_left, sgui_sk_font_t* _font, sk_paint_t* _paint) {
    auto canvas = reinterpret_cast<SkCanvas*>(_canvas);

    auto paint = reinterpret_cast<SkPaint*>(_paint);

    auto font = reinterpret_cast<SkFont*>(_font);

    auto text = SkTextBlob::MakeFromString(_text, *font);
    canvas->drawTextBlob(text.get(), bottom_left.x, bottom_left.y, *paint); 
  }

  sgui_sk_font_t* sgui_sk_font_new() {
    auto font = new SkFont;
    return reinterpret_cast<sgui_sk_font_t*>(font);
  }

  void sgui_sk_font_set_size(sgui_sk_font_t* _font, float size) {
    auto font = reinterpret_cast<SkFont*>(_font);
    font->setSize(size);
  }

  uint32_t sgui_sk_color_argb(uint8_t a, uint8_t r, uint8_t g, uint8_t b) {
    return sk_color_set_argb(a, r, g, b);
  }

  /*void sgui_sk_canvas_draw_line(sk_canvas_t* _canvas, int x0, int y0, int x1, int y1, sk_paint_t* paint) {
    SkCanvas *canvas = reinterpret_cast<SkCanvas*>(canvas);

    auto _paint = (SkPaint*) paint;
    canvas->drawLine(SkPoint::Make(x0, y0), SkPoint::Make(x1, y1), *_paint);
  }*/
}