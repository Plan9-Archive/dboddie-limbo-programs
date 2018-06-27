# Shows how to write to stdout using both the sys->fprint function and an I/O
# buffer.

implement StdoutWriter;

include "draw.m";
include "sys.m";
include "bufio.m";

StdoutWriter: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

init(ctxt: ref Draw->Context, args: list of string)
{
    sys := load Sys Sys->PATH;
    bufio := load Bufio Bufio->PATH;
    Iobuf: import bufio;

    # Printing strings is easy with the following function.
    sys->fprint(sys->fildes(1), "Simple hello.\n");

    iobuf: ref Iobuf;
    iobuf = bufio->fopen(sys->fildes(1), Sys->OWRITE);
    
    # The first argument is omitted because it is declared using self, meaning
    # that the iobuf instance is substituted, as in Python.
    b := array of byte "Hello world!\n";
    iobuf.write(b, len(b));
    iobuf.close();
}
