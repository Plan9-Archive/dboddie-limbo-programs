# Implements an empty module.

implement empty;

include "sys.m";
include "draw.m";

empty: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

init(ctxt: ref Draw->Context, args: list of string)
{
}
