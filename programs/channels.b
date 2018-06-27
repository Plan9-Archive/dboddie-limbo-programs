# Reads strings and integers sequentially from spawned processes via two
# channels.

implement Words;

# Import modules to be used and declare any instances that will be accessed
# globally.

include "sys.m";
include "draw.m";
include "string.m";
    str: String;

Words: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

init(ctxt: ref Draw->Context, args: list of string)
{
    # Load instances of modules, one local to init, the other global.
    sys := load Sys Sys->PATH;
    str = load String String->PATH;

    # Create channels for transferring strings and integers, and spawn
    # processes to run the names and numbers functions, passing the appropriate
    # channel to each function to allow communication.
    c1 := chan of string;
    c2 := chan of int;
    spawn names(c1);
    spawn numbers(c2);

    # Loop, reading strings received from c1 and integers from c2, printing
    # these until a nil string is received on c1.
    for (;;) {
        s := <- c1;
        if (s == nil) break;
        sys->print("%s: ", s);
        n := <- c2;
        sys->print("%d\n", n);
    }
}

names(c: chan of string)
{
    l := list of {"Melody", "Harmony", "Rhapsody", "Chorus", "Rhythm"};

    for (; l != nil; l = tl l)
        c <-= hd l;

    c <-= nil;
}

numbers(c: chan of int)
{
    l := list of {12, 5, 7, 0, 32};

    for (l; l != nil; l = tl l)
        c <-= hd l;
}
