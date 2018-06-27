# Tests my intuition about strings, characters and string splitting.

implement Strings;

include "sys.m";
include "draw.m";
include "string.m";

Strings: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

init(ctxt: ref Draw->Context, args: list of string)
{
    sys := load Sys Sys->PATH;
    str := load String String->PATH;

    c : string;
    c = "Hello";
    d : int;
    d = c[1];

    sys->print("String: '%s'\nCharacter 1: %d ('%c')\n", c, d, d);

    # Define a string to be split and two strings to hold substrings.
    s := "The quick brown fox jumps over the lazy dog.";
    w, t : string;

    while (s != nil) {
        (w, s) = str->splitstrl(s, " ");
        sys->print("%s ", w);
        if (len(s) > 1)
            s = s[1:];
    }
    sys->print("\n");
}
