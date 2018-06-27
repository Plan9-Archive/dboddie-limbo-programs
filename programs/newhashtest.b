# newhashtest.b
#
# Written in 2018 by David Boddie <david@boddie.org.uk>
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# Shows how the NewHash module can be used to store and retrieve associative
# data without the overhead of the Hash module.

implement NewHashTest;

include "sys.m";
    sys: Sys;
include "draw.m";
    draw: Draw;
include "newhash.m";
    hash: NewHash;
    HashTable, HashVal: import hash;

NewHashTest: module
{
    init: fn(ctx: ref Draw->Context, args: list of string);
};

init(ctx: ref Draw->Context, args: list of string)
{
    sys = load Sys Sys->PATH;
    hash = load NewHash NewHash->PATH;

    h := hash->new(11);
    h.insert("Name", ref HashVal.Str("Ada"));
    h.insert("Age", ref HashVal.Int(23));
    h.insert("Height", ref HashVal.Real(1.63));

    sys->print("%s %d %g\n", h.find("Name").as_string(),
                             h.find("Age").as_int(),
                             h.find("Height").as_real());
}
