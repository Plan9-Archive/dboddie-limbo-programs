# wmbackground.b
#
# Written in 2018 by David Boddie <david@boddie.org.uk>
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# Shows how to draw on the background image in the window manager.

implement WMBackground;

include "sys.m";
    sys: Sys;
include "draw.m";
    draw: Draw;
    Display, Image, Screen: import draw;
    display: ref Display;

BCOLOR : con 180;
BD     : con 10;

WMBackground: module
{
    init: fn(ctx: ref Draw->Context, args: list of string);
};

init(ctx: ref Draw->Context, args: list of string)
{
    sys = load Sys Sys->PATH;
    draw = load Draw Draw->PATH;

    if (ctx == nil) {
        sys->print("No valid context supplied. Try running from within wm/wm.\n");
        exit;
    }

    # Create a background (fill) image.
    display = ctx.display;
    wmimage := display.image;

    # Create an image and fill it with a colour and add a couple of rectangles.
    image := display.newimage(((0,0),(10,10)), wmimage.chans, 1, Draw->Black);
    image.draw(((0,0),(10,10)), display.rgb(BCOLOR, BCOLOR, BCOLOR), display.opaque, (0,0));
    image.draw(((0,0),(10,2)), display.rgb(BCOLOR - BD, BCOLOR - BD, BCOLOR - BD), display.opaque, (0,0));
    image.draw(((0,5),(10,7)), display.rgb(BCOLOR + BD, BCOLOR + BD, BCOLOR + BD), display.opaque, (0,0));

    # Create a public Screen object using the screen image and a background
    # (fill) image.
    screen := Screen.allocate(wmimage, image, 1);
    # Actually paint the image supplied onto the screen.
    screen.image.draw(screen.image.r, screen.fill, display.opaque, (0,0));

    window := screen.newwindow(((10, 10), (410, 310)), Draw->Refbackup, Draw->Grey);

    #pubscreen := display.publicscreen(1);
    # According to the draw-display man 2 page this is needed to ensure that
    # windows are updated.
    spawn refresh(display);

    # Use an infinite loop to stop the window from being garbage collected as
    # the function returns.
    for (;;) {
    }
}

refresh(display: ref Display)
{
    # This function call should only return when the display is closed.
    display.startrefresh();
}
