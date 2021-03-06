Notes on Limbo
==============

Numeric literals
----------------

Hexadecimal numbers are prefixed with 16r, as in the following example:

    a := 16rffffffff;

More generally, prefixing a number with <base>r indicates that the value is
specified in that base:

    b := 4r01230123;    # 6939
    c := 8r76543210;    # 16434824
    d := 2r101010;      # 42

Variable shadowing
------------------

It's quite easy to accidentally shadow variables, as in this example:

    i: int;

    do {
        i := 123;
        # ...
    } while (i == 0);

The i variable is redefined inside the loop and the variable outside the loop
is never updated.

Variable chaining
-----------------

Assignments can be chained, including combined declaraions with assignments:

    x := y := 0

Accessing members of objects
----------------------------

Types must be imported if members of their instances need to be accessed.
For example, the Context type is defined in the Draw module and members of a
Context object can be accessed if either the type is fully qualified or
imported. The fully qualified version looks like this:

    include "draw.m";
        draw: Draw;

    init(ctx: ref Draw->Context, args: list of string)
    {
        draw = load Draw Draw->PATH;
        display := ctx.display;

The imported version allows the ctx argument to be defined more concisely:

    include "draw.m";
        draw: Draw;
        Context: import draw;

    init(ctx: ref Context, args: list of string)
    {
        draw = load Draw Draw->PATH;
        display := ctx.display;

However, calling methods on objects requires the type to have been imported.
This is described in the next section.

Methods and functions in ADTs
-----------------------------

A function in an abstract data type (ADT) that specifies self in the type
declaration of its first argument can be used as a method with an instance of
that type as long as the type has been imported from its parent module:

    bufio := load Bufio Bufio->PATH;
    Iobuf: import bufio;

    iobuf: ref Iobuf;
    iobuf = bufio->fopen(sys->fildes(1), Sys->OWRITE);
    
    b := array of byte "Hello world!\n";
    iobuf.write(b, len(b));

Functions that don't include the self annotation in the first type declaration
are called with the dot notation:

    chans := Chans.mk("R8G8B8");

When a tuple is passed to an ADT its contents are unpacked into the fields
defined by the ADT, so a Draw->Rect can be instantiated with either of the
following:

    r1 := Rect(Point(x0, y0), Point(x1, y1));
    r2 := Rect((x0, y0), (x1, y1));

Since tuples can be passed instead of instances of ADTs and used to instantiate
new ADTs when necessary, the following variable can be passed into functions
that expect a Rect:

    r3 := ((x0, y0), (x1, y1));

Arrays can also be defined using tuples to achieve the same purpose. Either of
the following polygons can be passed to a function expecting an array of Point
values:

    polygon1 := array[4] of {
        Point(50, 0), Point(100, 50), Point(50, 100), Point(0, 50)
        };
    polygon2 := array[4] of {(50, 0), (100, 50), (50, 100), (0, 50)};

Picks and ADTs
--------------

A couple of points about "pick ADTs" are not clear (to me) in the Limbo
reference. First of all, how they are instantiated. Given the following ADT

    Value: adt
    {
        pick {
            Str => words: string;
        }
    };

it needs to be instantated with both the name of the ADT and the label that
corresponds to the type to be stored:

    a := ref Value.Str("Hello");
    b := ref Value.Int(123);

The label (Str or Int in this example) is user-defined, not some standard type
defined by the language.

The second point that seems to have been skimmed over is that only references
can be created. The relevant part of the Limbo reference seems to be this:

  "The identifier and expression given in the pick statement are used to bind
   a new variable to a pick adt reference expression..."

However, a couple of examples would have been nice.

Case structures
---------------

The limbo compiler segfaults in case structures where an individual case is
a function call that returns a string:

    case image.chans.text() {
    XRGB32.text() =>

In the situation where we don't import the XRGB32 name from the Draw module,
but instead fully qualify it, the compiler fails to find it:

    case image.chans.text() {
    Draw->XRGB32.text() =>

It prints this:

    drawtest.b:84: XRGB32 is not declared

Exceptions
----------

In an exception block, the break keyword causes control to break out of the
exception, not the surrounding block, like a for loop. However, the for loop
itself can be used as the block being checked for exceptions:

    for (number := 1; number <= 10; number++) {
        sys->print("Not %d\n", guess(number));
    } exception ex {
        found => sys->print("Found secret %d\n", ex); return;
    }

Functions can be annotated with the raises keyword but this might only be
required in module declarations.

Polymorphism and parameterised types
------------------------------------

Another later feature of the language is its support for polymorphism using
parameterised types which I discovered via Powerman's GitHub repository for his
replacement HashTable module:

https://github.com/powerman/inferno-contrib-hashtable

An ADT can be defined using parameterised notation in the following way:

    Value: adt[T]
    {
        value: T;
        show: fn[T](value: self ref Value);
    };

Powerman's Notes about Limbo (https://powerman.name/doc/Inferno/limbo_notes)
also mention aspects of the language that appear in code found in the appl
directory of the Inferno distribution.


Limbo Libraries
===============

Draw
----

The draw-image 2 man page is out of date. Images are created with the following
attributes (from draw.m):

    r:       Rect;          # rectangle in data area, local coords
    clipr:   Rect;          # clipping region
    depth:   int;           # number of bits per pixel
    chans:   Chans;
    repl:    int;           # whether data area replicates to tile the plane
    display: ref Display;   # where Image resides
    screen:  ref Screen;    # nil if not window
    iname:   string;

Sys
---

To use a directory to host files created by sys->file2chan it must first be
registered using the #s device. This has the effect of stopping file creation
in the specified directory, so following the convention of using /chan for this
would seem to be the best thing to do.


Standalone emu programs
=======================

Programs that are packaged using my Standalone/package.py in which the host
file system is unmounted won't be able to write to files. I currently mount the
directory containing the executable but this isn't ideal.
