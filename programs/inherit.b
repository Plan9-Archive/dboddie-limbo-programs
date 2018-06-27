# inherits.b
#
# Written in 2018 by David Boddie <david@boddie.org.uk>
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# Implements a simple form of inheritance where an instance of a specialised
# ADT contains an instance of the more general ADT it "inherits" from. Method
# calls are forwarded to the base implementation before code in the specialised
# ADT is executed.

implement Inherit;

include "draw.m";
    draw: Draw;
    Context, Display, Image, Point, Rect: import draw;

include "sys.m";
    sys: Sys;
    print: import sys;

Inherit: module
{
    init: fn(ctx: ref Context, args: list of string);
};

# Define a base class with position, size and fill colour attributes.

Box: adt
{
    pos:  Point;
    size: Point;
    rgba: int;

    draw: fn(box: self ref Box, display: ref Display);
    repr: fn(box: self ref Box): string;
};

# Define a specialised version of the Box class that must be instantiated using
# the init function. In addition to the position, size and fill colour, it also
# requires an outline colour to be specified.

DecoratedBox: adt
{
    base: ref Box;
    outline: int;

    init: fn(pos, size: Point, fill: int, outline: int): ref DecoratedBox;
    draw: fn(box: self ref DecoratedBox, display: ref Display);
};

# The main function sets up a display and creates instances of the Box and
# DecoratedBox classes, drawing each instance then waiting ten seconds before
# exiting.

init(ctx: ref Context, args: list of string)
{
    draw = load Draw Draw->PATH;
    sys = load Sys Sys->PATH;

    display := Display.allocate(nil);
    display.image.draw(display.image.r, display.color(Draw->Grey), nil, (0,0));

    box := ref Box((50,50), (100,100), Draw->Red);
    box.draw(display);

    decor := DecoratedBox.init((300,200), (200,200), Draw->Greygreen, Draw->Blue);
    decor.draw(display);

    sys->sleep(10000);
}

# The Box's draw method creates an image with the required colour and draws
# it on the display's image at the desired location.

Box.draw(box: self ref Box, display: ref Display)
{
    r := Rect(box.pos, box.pos.add(box.size));
    image := display.newimage(r, display.image.chans, 0, box.rgba);
    display.image.draw(r, image, display.opaque, box.pos);
}

Box.repr(box: self ref Box): string
{
    return sys->sprint("%d,%d %dx%d\n", box.pos.x, box.pos.y, box.size.x, box.size.y);
}

# The DecoratedBox's init function is used to create a new instance of the
# class. It creates a Box instance for accessing base class features and
# returns an initialised DecoratedBox instance.

DecoratedBox.init(pos, size: Point, fill: int, outline: int) : ref DecoratedBox
{
    base := Box(pos, size, fill);
    return ref DecoratedBox(ref base, outline);
}

# The DecoratedBox's draw method first uses the instance of the base class to
# draw a filled box then draws an outline around it.

DecoratedBox.draw(box: self ref DecoratedBox, display: ref Display)
{
    box.base.draw(display);

    p := box.base.pos;
    s := box.base.size;
    points := array[5] of {p, p.add((s.x, 0)), p.add(s), p.add((0, s.y)), p};

    display.image.poly(points, Draw->Endsquare, Draw->Endsquare, 1,
                       display.color(box.outline), p);
}
