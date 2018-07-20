# tablestest.b
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

implement TablesTest;

include "sys.m";
    sys: Sys;
include "draw.m";
    draw: Draw;
include "tables.m";
    tables: Tables;
    Strhash, Table: import tables;

TablesTest: module
{
    init: fn(ctx: ref Draw->Context, args: list of string);
};

Entry: adt {
    lat, lon: real;
};

init(ctx: ref Draw->Context, args: list of string)
{
    sys = load Sys Sys->PATH;
    tables = load Tables Tables->PATH;

    h := Strhash[ref Entry].new(23, ref Entry(0.0, 0.0));
    h.add("Oslo", ref Entry(59.0 + 55.0/60.0, 10.0 + 44.0/60.0));
    h.add("Tokyo", ref Entry(35.0 + 41.0/60.0, 139.0 + 41.0/60.0));
    h.add("Santiago", ref Entry(-33.0 - 27.0/60.0, -70.0 - 40.0/60.0));

    sys->print("%s %g %g\n", "Oslo", h.find("Oslo").lat, h.find("Oslo").lon);
    sys->print("%s %g %g\n", "Tokyo", h.find("Tokyo").lat, h.find("Tokyo").lon);
    sys->print("%s %g %g\n", "Santiago", h.find("Santiago").lat, h.find("Santiago").lon);
    sys->print("%s %g %g\n", "?", h.find("?").lat, h.find("?").lon);
}
