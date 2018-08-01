# globals.b
#
# Written in 2018 by David Boddie <david@boddie.org.uk>
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# Tests my intuition about how global variables are defined when they are
# exported from the module.

implement Globals;

include "sys.m";
include "draw.m";

Globals: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
    abc : int;
};

abc = 123;

init(ctxt: ref Draw->Context, args: list of string)
{
}
