# channel_words.b
#
# Written in 2018 by David Boddie <david@boddie.org.uk>
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# Reads strings sequentially from a spawned process via a channel.

implement Words;

# Import modules to be used and declare any instances that will be accessed
# globally.

include "sys.m";
include "draw.m";
include "string.m";
    str: String;

Words: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

init(ctxt: ref Draw->Context, args: list of string)
{
    # Load instances of modules, one local to init, the other global.
    sys := load Sys Sys->PATH;
    str = load String String->PATH;

    # Create a channel for transferring strings and spawn a process to run the
    # words function, passing the channel to allow communication.
    c := chan of string;
    spawn words(c);

    # Loop, reading and printing the strings from the channel as they are
    # received until a nil value is encountered.
    for (;;) {
        s := <- c;
        if (s == nil) break;
        sys->print("%s ", s);
    }

    sys->print("\n");
}

words(c: chan of string)
{
    s := "The quick brown fox jumps over the lazy dog.";
    word : string;

    # Split the string on spaces until there is nothing left, sending each
    # word to the main process.
    while (s != nil) {
        (word, s) = str->splitl(s, " ");
        c <-= word;
        if (len(s) > 1)
            s = s[1:];
    }

    c <-= nil;
}
