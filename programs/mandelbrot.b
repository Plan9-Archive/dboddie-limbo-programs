implement Mandelbrot;

include "sys.m";
    sys: Sys;
include "draw.m";
    draw: Draw;
    Display, Image: import draw;
include "math.m";
    math: Math;
include "tk.m";
include "wmclient.m";
    wmclient: Wmclient;
    Window: import wmclient;

Mandelbrot: module
{
    init: fn(ctx: ref Draw->Context, args: list of string);
};

displayed := 0;

init(ctx: ref Draw->Context, args: list of string)
{
    sys = load Sys Sys->PATH;
    draw = load Draw Draw->PATH;
    math = load Math Math->PATH;
    wmclient = load Wmclient Wmclient->PATH;

    # Make this process independent of its parent.
    sys->pctl(Sys->NEWPGRP, nil);

    # Initialise the window manager client.
    wmclient->init();

    # Create a window with a resize control.
    window := wmclient->window(ctx, "WindowTest", wmclient->Resize);

    # Show the window - this causes its image to be created so that we can
    # update it.
    window.onscreen(nil);

    # Start accepting input so that the pointer can interact with the window,
    # including its controls.
    window.startinput(list of {"ptr"});

    image := window.display.newimage(window.r, window.display.image.chans, 0, Draw->Black);
    ch := chan of int;
    spawn render(ch, image, -0.5, 0.0, 2.0, 16);

    for (;;) {
        alt {
            msg := <- window.ctl or
            msg = <- window.ctxt.ctl =>
                window.wmctl(msg);
                if (msg != nil && msg[0] == '!')
                    update_window(image, window);

            ptr := <-window.ctxt.ptr =>
                window.pointer(*ptr);

            redraw := <- ch =>
                update_window(image, window);
        }
    }
}

render(ch: chan of int, image: ref Image, ox, oy, length: real, iterations: int)
{
    x1 := y1 := 0;
    x2 := w := image.r.max.x - image.r.min.x;
    y2 := h := image.r.max.y - image.r.min.y;

    scale: real;

    if (w < h)
        scale = length/(real w);
    else
        scale = length/(real h);

    w2 := w/2;
    h2 := h/2;

    y := y1;
    while (y < y2) {

        i := oy + (real (h2 - y) * scale);

        x := x1;
        while (x < x2) {

            tr := r := ox + (real (x - w2) * scale);
            ti := i;

            count := 0;

            while (count < iterations) {
                temp := (tr*tr) - (ti*ti) + r;
                ti = (2.0*tr*ti) + i;
                tr = temp;

                r2 := (tr*tr) + (ti*ti);
                if (r2 > 4.0)
                    break;

                count += 1;
            }

            low := iterations - 16;
            if (count < low)
                image.draw(((x, y), (x+1, y+1)), image.display.rgb(0, 0, 255), nil, (0,0));

            else if (count < iterations) {
                c := count - low;
                g: int;
                if (c <= 7)
                    g = c * 36;
                else
                    g = (15 - c) * 36;
                image.draw(((x, y), (x+1, y+1)), image.display.rgb(c * 17, g, 255 - (c * 17)), nil, (0,0));
            } else
                image.draw(((x, y), (x+1, y+1)), image.display.black, nil, (0,0));

            x += 1;
        }

        y += 1;
        ch <-= 1;
    }
}

update_window(image: ref Image, window: ref Window)
{
    contents := window.image;
    contents.draw(contents.r, image, nil, (0, 0));
}
