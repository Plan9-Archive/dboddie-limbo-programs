implement DrawTest;

include "sys.m";
    sys: Sys;
include "bufio.m";
    bufio: Bufio;
    # Import Iobuf from a Bufio instance so that we can refer to its members.
    Iobuf: import bufio;
include "draw.m";
    draw: Draw;
    Chans, Context, Display, Image, Point, Rect: import draw;

DrawTest: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

# This example's init function does not require a valid context to be passed to
# it but it must be run in an environment where a display can be allocated.

init(nil: ref Context, args: list of string)
{
    sys = load Sys Sys->PATH;
    draw = load Draw Draw->PATH;
    bufio = load Bufio Bufio->PATH;

    display := draw->Display.allocate(nil);

    rect := Rect(Point(0, 0), Point(100, 100));
    
    # Create an off-screen image.
    image := display.newimage(rect, display.image.chans, 0, Draw->Black);

    draw_on_image(display, image);

    # Preview the image on the screen.
    display.image.draw(image.r, image, display.opaque, Point(0, 0));

    if (len(args) > 1)
        save_image(image, hd tl args); # args[1]
    else
        save_image(image, "");
}

draw_on_image(display: ref Display, image: ref Image)
{
    # Fill the image with a colour.
    background := display.rgb(0, 0, 255);
    image.draw(Rect(Point(10, 10), Point(90, 90)), background, display.opaque, Point(0, 0));

    # Draw a filled polygon.
    polygon := array[4] of {
        Point(50, 0), Point(100, 50), Point(50, 100), Point(0, 50)
        };

    image.fillpoly(polygon, 1, display.white, Point(0, 0));
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

    image.readpixels(Rect(Point(0, 0), Point(width, height)), pixels);

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
    iobuf.write(pixels, len(pixels));
    iobuf.close();
}
