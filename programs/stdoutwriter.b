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

    iobuf: ref Iobuf;
    iobuf = bufio->fopen(sys->fildes(1), Sys->OWRITE);
    
    # The first argument is omitted because it is declared using self, meaning
    # that the iobuf instance is substituted, as in Python.
    b := array of byte "Hello world!\n";
    iobuf.write(b, len(b));
    iobuf.close();
}
