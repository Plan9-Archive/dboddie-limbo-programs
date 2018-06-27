# cmdlinedrawtest.b
#
# Written in 2018 by David Boddie <david@boddie.org.uk>
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# Uses the Draw module to render an image which is exported as a PPM file in
# the current directory.

implement CmdLineDrawTest;

include "sys.m";
    sys: Sys;
include "bufio.m";
    bufio: Bufio;
    # Import Iobuf from a Bufio instance so that we can refer to its members.
    Iobuf: import bufio;
include "draw.m";
    draw: Draw;
    Chans, Context, Display, Image, Point, Rect: import draw;

CmdLineDrawTest: module
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

    # If the user did not specify an output file then print a usage message to
    # stderr.
    if (len(args) != 2) {
        stderr := sys->fildes(2);
        sys->fprint(stderr, "Usage: %s <output file>\n", hd args);
        exit;
    }

    # Interpret the last string in the argument list as the image file name.
    image_name := hd tl args;

    # Allocate a new display rather than use an existing one.
    display := draw->Display.allocate(nil);

    # Create a rectangle defining the extent of the image.
    rect := Rect(Point(0, 0), Point(100, 100));
    
    # Create an off-screen image with the same pixel format as the display.
    image := display.newimage(rect, display.image.chans, 0, Draw->Black);

    draw_on_image(display, image);

    # Preview the image on the screen.
    display.image.draw(image.r, image, display.opaque, Point(0, 0));

    save_image(image, image_name);
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
    # Note that this only works for displays that use a certain pixel format.
    if (image.chans.text() != "x8r8g8b8") {
        stderr := sys->fildes(2);
        sys->fprint(stderr, "Unhandled display format: %s\n", image.chans.text());
        exit;
    }

    # Create an I/O buffer in order to write to the file with the given name.
    # If this fails then the error is printed using the special %r format.
    iobuf := bufio->create(file_name, Sys->OWRITE, 8r0666);
    if (iobuf == nil) {
        stderr := sys->fildes(2);
        sys->fprint(stderr, "%r\n");
        exit;
    }

    # Calculate the width, height and depth (in bytes) of the image.
    width := image.r.max.x - image.r.min.x;
    height := image.r.max.y - image.r.min.y;
    bytes_per_pixel := image.chans.depth()/8;

    # Allocate a byte array for the entire image as well as an array for a
    # single pixel.
    pixels := array[width * height * bytes_per_pixel] of byte;
    pixel := array[bytes_per_pixel] of byte;

    # Export the entire image into the array.
    image.readpixels(Rect(Point(0, 0), Point(width, height)), pixels);

    # Write the PPM header.
    b := array of byte (
        sys->sprint("P6\n%d %d\n255\n", width, height)
        );

    iobuf.write(b, len(b));

    # Write each pixel in the array to the file using the I/O buffer.
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
