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
    c : string;
    c = "Hello";
    d : int;
    d = c[1];
    sys->print("%s\n", c);
}
