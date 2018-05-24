# The updated Hello World example from the Inferno documents.

implement TkHello;

include "sys.m";
    sys: Sys;
include "draw.m";
    draw: Draw;
include "tk.m";
    tk: Tk;
include "tkclient.m";
    tkclient: Tkclient;

TkHello: module
{
    init:   fn(ctxt: ref Draw->Context, argv: list of string);
};

init(ctxt: ref Draw->Context, argv: list of string)
{
    sys = load Sys Sys->PATH;
    draw = load Draw Draw->PATH;
    tk = load Tk Tk->PATH;
    tkclient = load Tkclient Tkclient->PATH;

    sys->pctl(Sys->NEWPGRP|Sys->FORKNS, nil);

    tkclient->init();
    (top, wmctl) := tkclient->toplevel(ctxt, "", "Hello", 0);

    if (top == nil) {
        sys->fprint(ref Sys->FD, "hello: cannot make window: %r\n");
        raise "fail:cannot make window";
    }

    tk->cmd(top, "button .b -text {hello, world}");
    tk->cmd(top, "pack .b");
    tk->cmd(top, "update");

    tkclient->onscreen(top, nil);
    tkclient->startinput(top, "kbd"::"ptr"::nil);

    for (;;) {
        alt {
        s := <-top.ctxt.kbd =>
            tk->keyboard(top, s);
        s := <-top.ctxt.ptr =>
            tk->pointer(top, *s);

        c := <-top.ctxt.ctl or
        c = <-top.wreq or
        c = <-wmctl =>
            tkclient->wmctl(top, c);
        }
    }
}
