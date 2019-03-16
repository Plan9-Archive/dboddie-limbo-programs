# adttest2.b
#
# Written in 2018 by David Boddie <david@boddie.org.uk>
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# Tests my intuition about references to ADTs, creating references and
# modifying them.

implement AdtTest2;

include "sys.m";
include "draw.m";
include "string.m";
    str: String;

AdtTest2: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

Greeting: adt
{
    words: array of string;

    init: fn(words: string): ref Greeting;
};

Greeting.init(words: string): ref Greeting
{
    n := 0;
    l : list of string;

    # Split the string into words, placing them in a list.
    while (words != nil) {
        w : string;

        (w, words) = str->splitl(words, " ");

        if (len words > 0)
            words = words[1:];

        l = w::l;
        n++;
    }

    g := ref Greeting(array[n] of string);

    # Transfer the words from the list to the array, remembering that they are
    # stored in reverse order.
    for (; l != nil; l = tl l)
        g.words[len l - 1] = hd l;

    return g;
}

init(ctxt: ref Draw->Context, args: list of string)
{
    sys := load Sys Sys->PATH;
    str = load String String->PATH;

    # Create a new instance and take a reference to (a copy of) it.
    greeting := Greeting.init("Hello, how are you?");

    sys->print("Number of words: %d\n", len greeting.words);

    for (i := 0; i < len greeting.words; i++)
        sys->print("%s ", greeting.words[i]);

    sys->print("\n");
}
