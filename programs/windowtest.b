# windowtest.b
#
# Written in 2018 by David Boddie <david@boddie.org.uk>
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# Shows how to use the Wmclient module to open a window and respond to user
# input.

implement WindowTest;

include "sys.m";
    sys: Sys;
include "draw.m";
    draw: Draw;
    Image: import draw;
include "tk.m";
include "wmclient.m";
    wmclient: Wmclient;
    Window: import wmclient;

WindowTest: module
{
    init: fn(ctx: ref Draw->Context, args: list of string);
};

init(ctx: ref Draw->Context, args: list of string)
{
    sys = load Sys Sys->PATH;
    draw = load Draw Draw->PATH;
    wmclient = load Wmclient Wmclient->PATH;

    # Make this process independent of its parent.
    sys->pctl(Sys->NEWPGRP, nil);

    # Initialise the window manager client.
    wmclient->init();

    #if (ctx == nil)
    #    ctx = wmclient->makedrawcontext();

    # Create a window with a resize control.
    window := wmclient->window(ctx, "WindowTest", wmclient->Resize);

    # Show the window - this causes its image to be created so that we can
    # update it.
    window.onscreen(nil);
    update_window(window);

    # Start accepting input so that the pointer can interact with the window,
    # including its controls.
    window.startinput(list of {"ptr"});

    for (;;) {
        alt {
            msg := <- window.ctl or
            msg = <- window.ctxt.ctl =>
                window.wmctl(msg);
                if (msg != nil && msg[0] == '!')
                    update_window(window);

            ptr := <-window.ctxt.ptr =>
                window.pointer(*ptr);
        }
    }
}

update_window(window: ref Window)
{
    contents := window.image;
    contents.draw(contents.r, window.display.white, nil, (0, 0));
}
