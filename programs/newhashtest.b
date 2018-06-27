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
