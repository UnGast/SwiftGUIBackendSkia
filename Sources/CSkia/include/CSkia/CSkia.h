#include "c/sk_canvas.h"
#include "c/sk_path.h"
#include "c/sk_paint.h"
#include "c/sk_types.h"

void testFunc();

char* testDraw(int width, int height, char *buffer);

void testDraw2(sk_canvas_t* _canvas);

sk_canvas_t* setupCanvas(int width, int height, char *buffer);

uint32_t sgui_sk_color_argb(uint8_t a, uint8_t r, uint8_t g, uint8_t b);

void sgui_sk_canvas_draw_text(sk_canvas_t* canvas, const char* text, sk_point_t point, const sk_paint_t* paint, float fontSize);

//  void sgui_sk_paint

//void sgui_sk_canvas_draw_line(sk_canvas_t* canvas, int x0, int y0, int x1, int y1, sk_paint_t* paint);