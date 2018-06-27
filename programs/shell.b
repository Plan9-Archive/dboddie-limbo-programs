# shell.b
#
# Written in 2018 by David Boddie <david@boddie.org.uk>
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# Shows how to start a shell using the Sh module.

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

    # Either of the following will work.
    # The first is a declaration followed by an assignment.
    #args: list of string = "sh"::"-c"::"ls /tmp"::nil;
    # The second is an assignment that defines the type of the list elements.
    args := list of {"sh", "-c", "ls /tmp"};

    # We do not need to spawn a new process here.
    sh->init(ctxt, args);
}
