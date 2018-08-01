# lists.b
#
# Written in 2018 by David Boddie <david@boddie.org.uk>
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# Tests my intuition about lists.

implement Lists;

include "sys.m";
    sys: Sys;
include "draw.m";
include "string.m";
    str: String;

Lists: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

init(ctxt: ref Draw->Context, args: list of string)
{
    sys = load Sys Sys->PATH;
    str = load String String->PATH;

    l : list of int;
    for (i := 0; i < 10; i++)
        l = i::l;

    while (l != nil) {
        sys->print("%d\n", hd l);
        l = tl l;
    }

    s := "The-quick-brown-fox";
    for (sl := split(s, "-"); sl != nil; sl = tl sl)
        sys->print("%s ", hd sl);

    sys->print("\n");

    l = 1::
        2::
        3::nil;
}

split(s, c: string): list of string
{
    l : list of string;

    while (s != nil) {
        # Don't shadow the s argument with the := operator. Declare w instead.
        w : string;
        (s, w) = str->splitstrr(s, c);

        l = w::l;

        if (len s > 0)
            s = s[:len s - 1];
    }

    return l;
}
