# Hello world in Limbo with sleep calls.

implement Hello;

include "sys.m";
include "draw.m";

Hello: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

init(ctxt: ref Draw->Context, args: list of string)
{
    sys := load Sys Sys->PATH;
    sys->sleep(1000);
    sys->print("Hello world!\n");
    sys->sleep(2000);
}
