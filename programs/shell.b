implement Shell;

include "sys.m";
    sys: Sys;

include "draw.m";
    draw: Draw;
    Context: import draw;

include "sh.m";
    sh: Sh;

Shell: module
{
    init: fn(ctxt: ref Context, argv: list of string);
};

init(ctxt: ref Context, argv: list of string)
{
    sys := load Sys Sys->PATH;
    sh := load Sh Sh->PATH;

    args: list of string = "sh"::"-c"::"ls"::"/tmp"::nil;

    # We do not need to span a new process here.
    sh->init(ctxt, args);
}
