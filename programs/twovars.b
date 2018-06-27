# Tests my intuition about declaring two variables with the same type.

implement empty;

include "sys.m";
include "draw.m";

empty: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

init(ctxt: ref Draw->Context, args: list of string)
{
    a, b : int;
    a = 123;
    b = 456;
}
