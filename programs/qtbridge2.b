# qtbridge2.b
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

implement QtBridge2;

# Import modules to be used and declare any instances that will be accessed
# globally.

include "sys.m";
    sys: Sys;
    sprint: import sys;
include "draw.m";
include "string.m";
    str: String;

QtBridge2: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

read_ch : chan of string;
write_ch : chan of string;

# Define an data type to represent a widget.

Widget: adt {
    name: string;

    init: fn(class, name: string): ref Widget;
    call: fn(w: self ref Widget, method, args: string): string;
};

Widget.init(class, name: string): ref Widget
{
    write_ch <-= sprint("create %s %s\n", class, name);
    return ref Widget(name);
}

Widget.call(w: self ref Widget, method, args: string): string
{
    write_ch <-= sprint("call %s %s %s\n", w.name, method, args);
    expected := sprint("value %s %s", w.name, method);

    line : string;
    do {
        line = <- read_ch;
    } while (line[:len expected] != expected);

    (s, v) := str->splitr(line, " ");
    return v;
}

# Main function and 

init(ctxt: ref Draw->Context, args: list of string)
{
    # Load instances of modules, one local to init, the other global.
    sys = load Sys Sys->PATH;
    str = load String String->PATH;

    read_ch = chan of string;
    write_ch = chan of string;

    # Spawn a reader and a writer to handle input and output in the background.
    spawn reader(read_ch);
    spawn writer(write_ch);

    widget := Widget.init("QLabel", "window");
    widget.call("setText", "\"Hello world!\"");
    widget.call("show", "");

    for (;;) alt {
        s := <- read_ch => sys->print("*** %s", s);
    }
}

reader(read_ch: chan of string)
{
    stdin := sys->fildes(0);
    read_array := array[256] of byte;
    current := "";

    for (;;) {

        # Read as much as possible from stdin.
        read := sys->read(stdin, read_array, 256);
        # Convert the input to a string and append it to the current string.
        current += string read_array[:read];

        # Split the current text at the first newline, obtaining the next
        # command string.
        (command, current) := str->splitl(current, "\n");

        if (len current > 1)
            current = current[1:];

        # Send the command via the read channel.
        read_ch <-= command;
    }
}

writer(write_ch: chan of string)
{
    stdout := sys->fildes(1);

    for (;;) {

        # Convert each string from the write channel to a byte array.
        s := <- write_ch;
        write_array := array of byte s;

        # Write the entire array to stdout.
        available := len write_array;
        if (sys->write(stdout, write_array, available) != available) {
            sys->fprint(sys->fildes(2), "Write error.\n");
            exit;
        }
    }
}
