# Draws an image on the display and saves the result to a PPM image, or to
# stdout if no file name is passed as an argument. Requires the window manager
# to be running.

implement DrawTest;

include "sys.m";
    sys: Sys;
include "bufio.m";
    bufio: Bufio;
    # Import Iobuf from a Bufio instance so that we can refer to its members.
    Iobuf: import bufio;
include "draw.m";
    draw: Draw;
    Chans, Context, Display, Image: import draw;

DrawTest: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

# This example's init function requires a valid context to be passed to it.
# This means that the window manager must be running for 

init(ctxt: ref Context, args: list of string)
{
    sys = load Sys Sys->PATH;
    draw = load Draw Draw->PATH;
    bufio = load Bufio Bufio->PATH;

    if (ctxt == nil) {
        sys->print("No valid context supplied. Try running from within wm/wm.\n");
        exit;
    }
    
    #chans := Chans.mk("R8G8B8"); # Draw->RGB24; # Chans(16r52474241);
    chans := ctxt.display.image.chans;

    # Tuples will work instead of Points in the definition of a Rect instance.
    rect := ((0, 0), (100, 100));
    #image := ref Image(rect, rect, 32, chans, 0, ctxt.display, nil, "");
    
    # Create an off-screen image.
    image := ctxt.display.newimage(rect, chans, 0, Draw->Black);

    draw_on_image(ctxt, image);

    # Preview the image on the screen.
    ctxt.display.image.draw(image.r, image, ctxt.display.opaque, (0, 0));

    if (len(args) > 1)
        save_image(image, hd tl args); # args[1]
    else
        save_image(image, "");
}

draw_on_image(ctxt: ref Context, image: ref Image)
{
    # Fill the image with a colour.
    background := ctxt.display.rgb(0, 0, 255);
    # Define an array of points.
    points := array[4] of {(50, 0), (100, 50), (50, 100), (0, 50)};

    # The first argument is implicit because it is declared using self, meaning
    # that the image instance is substituted, as in Python.
    image.draw(((10, 10), (90, 90)), background, ctxt.display.opaque, (0, 0));
    image.fillpoly(points, 1, ctxt.display.white, (0, 0));
}

save_image(image: ref Image, file_name: string)
{
    iobuf: ref Iobuf;

    if (file_name != nil) {
        iobuf = bufio->create(file_name, Sys->OWRITE, 8r0666);
    } else {
        iobuf = bufio->fopen(sys->fildes(1), Sys->OWRITE);
    }
    
    width := image.r.max.x - image.r.min.x;
    height := image.r.max.y - image.r.min.y;

    bytes_per_pixel := image.chans.depth()/8;
    pixels := array[width * height * bytes_per_pixel] of byte;
    pixel := array[bytes_per_pixel] of byte;

    image.readpixels(((0, 0), (width, height)), pixels);

    # Write the PPM header.
    b := array of byte (
        sys->sprint("P6\n%d %d\n255\n", width, height)
        );

    iobuf.write(b, len(b));

    ptr := 0;
    for (i := 0; i < height; i++) {
        for (j := 0; j < width; j++) {
            case image.chans.text() {
            "x8r8g8b8" =>
                iobuf.write(pixels[ptr + 2:ptr + 3], 1);
                iobuf.write(pixels[ptr + 1:ptr + 2], 1);
                iobuf.write(pixels[ptr:ptr + 1],     1);
            }
            ptr += bytes_per_pixel;
        }
    }
    iobuf.close();
}
