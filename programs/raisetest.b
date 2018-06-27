# Experimenting with defining and raising an exception, as well as declaring
# that a function may contain code that raises an exception.

implement RaiseTest;

include "sys.m";
    sys: Sys;
include "draw.m";
    draw: Draw;
include "hash.m";
    hash: Hash;
    HashTable, HashVal: import hash;

RaiseTest: module
{
    init: fn(ctx: ref Draw->Context, args: list of string);
};

# Define an exception that holds an integer.
found: exception(int);
nearly: exception(int, string);

init(ctx: ref Draw->Context, args: list of string)
{
    sys = load Sys Sys->PATH;
    hash = load Hash Hash->PATH;

    # Loop over integers from 1 to 10, printing the number unless a recognised
    # exception was raised.
    for (number := 1; number <= 10; number++) {
        sys->print("Not %d\n", guess(number));
    } exception ex {
        # If the found exception was raised then print the argument passed to
        # it and return.
        found => sys->print("Found secret %d\n", ex); return;
        # If the nearly exception was raised then unpack the tuple of arguments
        # passed to it and print them.
        nearly =>
            (n, s) := ex;
            sys->print("Not %d: %s\n", n, s);
    }
}

guess(number: int): int raises (found)
{
    if (number == 7)
        raise found(number);
    else if (number == 6)
        raise nearly(number, "Very close!");

    return number;
}
