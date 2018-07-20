# channels_file.b
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

implement ChannelsFile;

# Import modules to be used and declare any instances that will be accessed
# globally.

include "sys.m";
include "draw.m";
include "string.m";
    str: String;

ChannelsFile: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

init(ctxt: ref Draw->Context, args: list of string)
{
    # Load instances of modules, one local to init, the other global.
    sys := load Sys Sys->PATH;
    str = load String String->PATH;

    # Register the current directory for serving channels as file system
    # operations.
    sys->bind("#s", "/chan", sys->MBEFORE);

    # Create a file and use a FileIO object to interact with it.
    dir := "/chan";
    file_name := "example";

    fileio := sys->file2chan(dir, file_name);
    if (fileio == nil) {
        sys->fprint(sys->fildes(2), "Cannot create channel file: %s/%s.\n",
                    dir, file_name);
        exit;
    }

    # Loop, reading strings received from c1 and integers from c2, printing
    # these until a nil string is received on c1.
    s := array[32] of byte;
    s = array of byte "Hello world!\n";

    for (;;) alt {
        (offset, count, fid, rc) := <- fileio.read =>
            if (rc == nil) continue;
            if (offset != 0) {
                rc <-= (nil, nil);
                continue;
            }
            if (count > len s)
                count = len s;

            rc <-= (s[:count], "");
        
        ### Writes are untested.
        (offset, data, fid, wc) := <- fileio.write =>
            if (wc == nil) continue;
            if (offset != 0) {
                wc <-= (0, "bad offset");
                continue;
            }
            sys->print("%d, %s\n", offset, string data);
            s = data;
            wc <-= (len data, "");
    }
}
