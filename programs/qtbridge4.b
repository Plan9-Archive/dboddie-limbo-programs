# qtbridge4.b
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

implement QtBridge4;

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
    Table: import tables;

QtBridge4: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

read_ch : chan of string;
write_ch : chan of string;

Channels: adt {
    counter: int;
    response_hash : ref Table[chan of string];

    init: fn(): ref Channels;
    get: fn(c: self ref Channels): (int, chan of string);
};

Channels.init(): ref Channels
{
    response_hash := Table[chan of string].new(7, nil);
    return ref Channels(0, response_hash);
}

Channels.get(c: self ref Channels): (int, chan of string)
{
    # Creates a new channel and registers it with the 
    response_ch := chan of string;
    c.counter = (c.counter + 1) % 1024;
    c.response_hash.add(c.counter, response_ch);

    return (c.counter, response_ch);
}

channels : ref Channels;

# Define an data type to represent a widget.

Widget: adt {
    name: string;

    init: fn(class, name: string): ref Widget;
    call: fn(w: self ref Widget, method: string, args: list of string): string;
};

Widget.init(class, name: string): ref Widget
{
    write_ch <-= sprint("create %s %s\n", class, name);
    return ref Widget(name);
}

Widget.call(w: self ref Widget, method: string, args: list of string): string
{
    return call(w.name, method, args);
}

call(name, method: string, args: list of string): string
{
    # Obtain a channel to use to receive a response.
    (key, response_ch) := channels.get();
    
    # Send the call request and receive the response.
    message := sprint("call %d %s %s", key, name, method);
    for (; args != nil; args = tl args)
        message += " " + hd args;

    write_ch <-= message + "\n";
    value := <- response_ch;

    # Delete the entry for the response in the response hash.
    channels.response_hash.del(key);

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
    channels = Channels.init();

    # Spawn a reader and a writer to handle input and output in the background.
    spawn reader(read_ch);
    spawn writer(write_ch);

    widget := Widget.init("QLabel", "window");
    widget.call("setText", "\"Hello world!\""::nil);
    widget.call("show", nil);
    width := int widget.call("width", nil);
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

        # Remove the first word from the value string ("value"), extract the
        # second (the identifier) and return the rest as a value.
        token : string;
        (token, value_str) = str->splitl(value_str, " ");
        value_str = value_str[1:];

        (token, value_str) = str->splitl(value_str, " ");
        id := int token;
        value_str = value_str[1:];

        ch := channels.response_hash.find(id);
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
