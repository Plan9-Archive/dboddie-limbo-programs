# arrays.b
#
# Written in 2018 by David Boddie <david@boddie.org.uk>
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# Tests my intuition about how arrays are defined and initialised at the same
# time.

implement Arrays;

include "sys.m";
    
include "draw.m";

Arrays: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

init(ctxt: ref Draw->Context, args: list of string)
{
    sys := load Sys Sys->PATH;
    print : import sys;

    ints := array[3] of {1, 2, 3};

    for (i := 0; i < len(ints); i++)
        print("%d ", ints[i]);
}
