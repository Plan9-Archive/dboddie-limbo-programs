# qtbridge3.b
#
# Written in 2018 by David Boddie <david@boddie.org.uk>
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# Tests an integration bridge between Limbo and Qt.

implement QtBridge3;

# Import modules to be used and declare any instances that will be accessed
# globally.

include "sys.m";
    sys: Sys;
    sprint: import sys;
include "draw.m";
include "string.m";
    str: String;
include "tables.m";
    tables: Tables;
    Strhash: import tables;

QtBridge3: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

read_ch : chan of string;
write_ch : chan of string;
response_hash : ref Strhash[chan of string];

# Define an data type to represent a widget.

Widget: adt {
    name: string;

    init: fn(class, name: string): ref Widget;
    call: fn(w: self ref Widget, method, args: string): string;
};

Widget.init(name, class: string): ref Widget
{
    write_ch <-= sprint("create 0 %s %s\n", name, class);
    return ref Widget(name);
}

Widget.call(w: self ref Widget, method, args: string): string
{
    # Create a channel to use to receive the return value and use the expected
    # response string as a key in the response hash.
    expected := "value 1";
    response_ch := chan of string;
    response_hash.add(expected, response_ch);

    # Send the call request and receive the response.
    write_ch <-= sprint("call 1 %s %s %s\n", w.name, method, args);
    value := <- response_ch;

    # Delete the entry for the response in the response hash.
    response_hash.del(expected);

    return value;
}

# Main function and stream handling functions

init(ctxt: ref Draw->Context, args: list of string)
{
    # Load instances of modules, one local to init, the other global.
    sys = load Sys Sys->PATH;
    str = load String String->PATH;
    tables = load Tables Tables->PATH;

    read_ch = chan of string;
    write_ch = chan of string;
    response_hash = Strhash[chan of string].new(23, nil);

    # Spawn a reader and a writer to handle input and output in the background.
    spawn reader(read_ch);
    spawn writer(write_ch);

    widget := Widget.init("window", "QLabel");
    widget.call("setText", "\"Hello world!\"");
    widget.call("show", "");
    width := int widget.call("width", "");
    sys->print("%d\n", width);

    for (;;) alt {
        s := <- read_ch =>
            sys->print("default: %s\n", s);
    }
}

reader(read_ch: chan of string)
{
    stdin := sys->fildes(0);
    read_array := array[256] of byte;
    current := "";
    value_str : string;

    for (;;) {

        # Read as much as possible from stdin.
        read := sys->read(stdin, read_array, 256);
        # Convert the input to a string and append it to the current string.
        current += string read_array[:read];

        # Split the current text at the first newline, obtaining the next
        # command string.
        (value_str, current) = str->splitl(current, "\n");

        if (len current > 0)
            current = current[1:];

        # Remove the first two words from the value string ("value", <id>) and
        # return the rest as a value.
        i := n := 0;
        w : string;

        while (i < len value_str && n < 2) {
            if (value_str[i:i + 1] == " ")
                n++;
            i++;
        }

        key := value_str[:i - 1];
        value_str = value_str[i:];

        ch := response_hash.find(key);
        if (ch != nil) {
            ch <-= value_str;
            continue;
        }

        # Send the command via the default read channel.
        read_ch <-= value_str;
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
