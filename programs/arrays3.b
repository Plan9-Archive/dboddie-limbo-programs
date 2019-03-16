# arrays3.b
#
# Written in 2018 by David Boddie <david@boddie.org.uk>
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# Tests my intuition about how strings are converted to arrays.

implement Arrays3;

include "sys.m";
    
include "draw.m";

Arrays3: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

init(ctxt: ref Draw->Context, args: list of string)
{
    sys := load Sys Sys->PATH;
    print : import sys;

    b := array[] of { byte 49, byte 48, byte 48 };
    i := int string b;
    sys->print("%d\n", i);
}
