# tablestest2.b
#
# Written in 2018 by David Boddie <david@boddie.org.uk>
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# Shows how the Tables module can be used to store and retrieve associative
# data without the overhead of the Hash module.

implement TablesTest2;

include "sys.m";
    sys: Sys;
include "draw.m";
    draw: Draw;
include "tables.m";
    tables: Tables;
    Strhash, Table: import tables;

TablesTest2: module
{
    init: fn(ctx: ref Draw->Context, args: list of string);
};

Callable: type ref fn();

init(ctx: ref Draw->Context, args: list of string)
{
    sys = load Sys Sys->PATH;
    tables = load Tables Tables->PATH;

    h := Strhash[Callable].new(23, nil);
    h.add("Hello", hello);
    h.add("world", world);

    f : Callable;
    f = h.find("Hello");
    f();
    f = h.find("world");
    f();
}

hello()
{
    sys->print("Hello\n");
}

world()
{
    sys->print("world\n");
}
