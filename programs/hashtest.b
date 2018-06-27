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
