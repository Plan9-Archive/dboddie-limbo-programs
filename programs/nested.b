# Simple example of nested loops.

implement count;

include "sys.m";
include "draw.m";

count: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

init(ctxt: ref Draw->Context, args: list of string)
{
    sys := load Sys Sys->PATH;
    for (i := 1; i < 13; i++) {
        for (j := 1; j < 13; j++)
            sys->print("%3d ", i * j);
        sys->print("\n");
    }
}
