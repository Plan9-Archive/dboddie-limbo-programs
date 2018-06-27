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
