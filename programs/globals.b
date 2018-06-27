# Tests my intuition about how global variables are defined when they are
# exported from the module.

implement count;

include "sys.m";
include "draw.m";

count: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
    abc : int;
};

abc = 123;

init(ctxt: ref Draw->Context, args: list of string)
{
}
