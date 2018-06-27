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
