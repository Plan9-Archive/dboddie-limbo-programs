# references.b
#
# Written in 2018 by David Boddie <david@boddie.org.uk>
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# Tests my intuition about references.

implement References;

include "sys.m";
    sys: Sys;
include "draw.m";

References: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

Name: adt
{
    first: string;
    second: string;

    repr: fn(name: self Name): string;
    reprref: fn(name: self ref Name): string;
};

init(nil: ref Draw->Context, args: list of string)
{
    sys = load Sys Sys->PATH;

    a := Name("John", "Smith");
    b := ref a;

    sys->print("a = %s\n", a.repr());
    sys->print("b = %s\n", b.reprref());

    a.first = "Jim";
    sys->print("a = %s\n", a.repr());
    sys->print("b = %s\n", b.reprref());

    b.second = "Brown";
    sys->print("a = %s\n", a.repr());
    sys->print("b = %s\n", b.reprref());
}

Name.repr(name: self Name): string
{
    return sys->sprint("%s %s", name.first, name.second);
}

Name.reprref(name: self ref Name): string
{
    return sys->sprint("%s %s", name.first, name.second);
}
