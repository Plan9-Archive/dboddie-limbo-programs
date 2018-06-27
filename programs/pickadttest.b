# pickadttest.b
#
# Written in 2018 by David Boddie <david@boddie.org.uk>
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# Simple example showing how pick ADTs can be used to store values of different
# predefined types in an ADT, and how to retrieve those values using a pick
# statement.

implement PickAdtTest;

include "sys.m";
    sys: Sys;
include "draw.m";

PickAdtTest: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

Value: adt
{
    pick {
        Str => words: string;
        Int => number: int;
    }
};

init(ctxt: ref Draw->Context, args: list of string)
{
    sys = load Sys Sys->PATH;

    # Create a new instance and take a reference to (a copy of) it.
    a := ref Value.Str("Hello");
    b := ref Value.Int(123);
    c : ref Value;
    c = ref Value.Str("World");

    # Pass the contents of the variables to a function that accepts a general
    # Value reference.
    show(a);
    show(b);
    show(c);
}

show(value: ref Value)
{
    pick v := value {
        Str => sys->print("%s\n", v.words);
        Int => sys->print("%d\n", v.number);
    }
}
