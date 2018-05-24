implement LowLevelWindows;

include "sys.m";
    sys: Sys;
include "draw.m";
    draw: Draw;
    Display, Font, Image, Point, Screen: import draw;
    display: ref Display;

BCOLOR : con 180;
BD     : con 5;

LowLevelWindows: module
{
    init: fn(ctx: ref Draw->Context, args: list of string);
};

init(ctx: ref Draw->Context, args: list of string)
{
    sys = load Sys Sys->PATH;
    draw = load Draw Draw->PATH;

    if (ctx != nil) {
        sys->print("An existing context was supplied. Try running from outside wm/wm.\n");
        exit;
    }

    display := Display.allocate(nil);

    # Create a background (fill) image.
    wmimage := display.image;

    # Create an image and fill it with a colour and add a couple of rectangles.
    image := display.newimage(((0,0),(10,10)), wmimage.chans, 1, Draw->Black);
    image.draw(((0,0),(10,10)), display.rgb(BCOLOR, BCOLOR, BCOLOR), display.opaque, (0,0));
    image.draw(((0,0),(10,2)), display.rgb(BCOLOR - BD, BCOLOR - BD, BCOLOR - BD), display.opaque, (0,0));
    image.draw(((0,5),(10,7)), display.rgb(BCOLOR + BD, BCOLOR + BD, BCOLOR + BD), display.opaque, (0,0));

    # Create a public Screen object using the screen image and a background
    # (fill) image.
    screen := Screen.allocate(wmimage, image, 1);
    screen.image.draw(screen.image.r, screen.fill, display.opaque, (0,0));

    window := screen.newwindow(((10, 10), (410, 310)), Draw->Refbackup, Draw->Grey);
    screen.top(array[1] of {window});

    #pubscreen := display.publicscreen(1);
    # According to the draw-display man 2 page this is needed to ensure that
    # windows are updated.
    spawn refresh(display);

    # See the pointer man 3 page for details of the /dev/pointer file.
    f := sys->open("/dev/pointer", Sys->ORDWR);
    font := Font.open(display, "*default*");
    font.height = 16;
    font.ascent = 12;
    x := font.width("XX");

    # Use an infinite loop to stop the window from being garbage collected as
    # the function returns.
    for (;;) {

        # Read the pointer information from the file and print it in the window.
        b := array[49] of byte;
        sys->read(f, b, len b);
        s := sys->sprint("%d,%d %d %d", int string b[1:13], int string b[13:25],
                                        int string b[25:37], int string b[37:49]);
        window.draw(((0,0), (window.r.max.x,font.height*2)), display.color(Draw->Grey), display.opaque, (0,0));
        window.text((x,font.height), display.black, (0,0), font, s);
        #sys->print("%s\n", s);
    }
}

refresh(display: ref Display)
{
    # This function call should only return when the display is closed.
    display.startrefresh();
}
