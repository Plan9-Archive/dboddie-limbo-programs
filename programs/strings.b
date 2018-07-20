# strings.b
#
# Written in 2018 by David Boddie <david@boddie.org.uk>
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

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
    c += " world!";
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
    sys->print("The original string is now empty: '%s'\n", s);

    s = "The quick brown fox jumps over the lazy dog.";

    while (s != nil) {
        (s, w) = str->splitstrr(s, " ");
        sys->print("%s ", w);
        if (len(s) > 1)
            s = s[:len(s) - 1];
    }
    sys->print("\n");
}
