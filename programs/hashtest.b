# hashtest.b
#
# Written in 2018 by David Boddie <david@boddie.org.uk>
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# Shows how the Hash module is used to store and retrieve associative data.

implement HashTest;

include "sys.m";
    sys: Sys;
include "draw.m";
    draw: Draw;
include "hash.m";
    hash: Hash;
    HashTable, HashVal: import hash;

HashTest: module
{
    init: fn(ctx: ref Draw->Context, args: list of string);
};

init(ctx: ref Draw->Context, args: list of string)
{
    sys = load Sys Sys->PATH;
    hash = load Hash Hash->PATH;

    h := hash->new(11);
    h.insert("Name", HashVal(0, 0.0, "Ada"));
    h.insert("Number", HashVal(123, 0.0, ""));

    sys->print("%s %d\n", h.find("Name").s, h.find("Number").i);
}
