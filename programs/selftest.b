# selftest.b
#
# Written in 2018 by David Boddie <david@boddie.org.uk>
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# Tests the use of the self keyword in ADT function declarations, allowing them
# to be called as methods on instances of those ADTs.

implement SelfTest;

include "sys.m";
    sys: Sys;
include "draw.m";

SelfTest: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

Greeting: adt
{
    words: string;
    # The print function accepts a Greeting reference as its argument. The self
    # keyword enables method calling syntax to be used.
    print: fn(g: self ref Greeting);
};

Greeting.print(g: self ref Greeting)
{
    sys->print("%s\n", g.words);
}

init(ctxt: ref Draw->Context, args: list of string)
{
    sys = load Sys Sys->PATH;

    # Create a Greeting reference and call its print function as a method. This
    # is enabled by the use of the self keyword in its declaration.
    a := ref Greeting("Hello");
    a.print();
}
