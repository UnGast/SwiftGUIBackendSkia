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

extern "C" {
  void testFunc() {
    printf("IT WORKS\n");
  }

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
}