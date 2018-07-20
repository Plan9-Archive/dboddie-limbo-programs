# qtbridge1.b
#
# Written in 2018 by David Boddie <david@boddie.org.uk>
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# Reads strings and integers sequentially from spawned processes via two
# channels.

implement QtBridge1;

# Import modules to be used and declare any instances that will be accessed
# globally.

include "sys.m";
    sys: Sys;
include "draw.m";
include "string.m";
    str: String;

QtBridge1: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

init(ctxt: ref Draw->Context, args: list of string)
{
    # Load instances of modules, one local to init, the other global.
    sys = load Sys Sys->PATH;
    str = load String String->PATH;

    read_ch := chan of array of byte;
    write_ch := chan of array of byte;

    # Spawn a writer to handle input and output in the background.
    spawn writer(write_ch);

    write_ch <-= message("create QLabel window");
    write_ch <-= message("call window setText \"Hello world!\"");
    write_ch <-= message("call window show");

    for (;;) {}
}

message(text: string): array of byte
{
    return array of byte (text + "\n");
}

writer(write_ch: chan of array of byte)
{
    stdout := sys->fildes(1);

    for (;;) {
        write_array := <- write_ch;
        available := len write_array;
        if (sys->write(stdout, write_array, available) != available) {
            sys->fprint(sys->fildes(2), "Write error.\n");
            exit;
        }
    }
}
