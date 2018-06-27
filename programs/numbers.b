# Tests my intuition about chained assignment.

implement Numbers;

include "sys.m";
include "draw.m";
include "math.m";

Numbers: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

init(ctxt: ref Draw->Context, args: list of string)
{
    sys := load Sys Sys->PATH;
    math := load Math Math->PATH;

    x := y := 0;
}
