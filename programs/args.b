implement Args;

include "sys.m";
include "draw.m";

Args: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

init(ctxt: ref Draw->Context, args: list of string)
{
    sys := load Sys Sys->PATH;

    for (; args != nil; args = tl args)
    {
        sys->print("%s\n", hd args);
    }
}
