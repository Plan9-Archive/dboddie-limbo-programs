# Tests my intuition about how arrays are defined and initialised at the same
# time.

implement Arrays;

include "sys.m";
    
include "draw.m";

Arrays: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

init(ctxt: ref Draw->Context, args: list of string)
{
    sys := load Sys Sys->PATH;
    print : import sys;

    ints := array[3] of {1, 2, 3};

    for (i := 0; i < len(ints); i++)
        print("%d ", ints[i]);
}
