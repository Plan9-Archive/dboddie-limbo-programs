# receivers.b
#
# Written in 2018 by David Boddie <david@boddie.org.uk>
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# Tests one producer with two consumers.

implement Receivers;

include "sys.m";
    sys: Sys;
include "draw.m";
include "string.m";

Receivers: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

init(ctxt: ref Draw->Context, args: list of string)
{
    sys = load Sys Sys->PATH;

    ch := chan of int;

    spawn receiver1(ch);
    spawn receiver2(ch);

    for (i := 0; i < 100; i++) {
        ch <-= i;
    }
}

receiver1(ch: chan of int)
{
    for (;;) alt {
        i := <- ch =>
            sys->print("r1: %d\n", i);
    }
}

receiver2(ch: chan of int)
{
    for (;;) alt {
        i := <- ch =>
            sys->print("r2: %d\n", i);
    }
}
