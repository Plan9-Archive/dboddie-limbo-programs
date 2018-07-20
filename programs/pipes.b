implement Pipes;

include "sys.m";
    sys: Sys;
    FD, pipe, print: import sys;

include "draw.m";

Pipes: module
{
    init: fn(ctx: ref Draw->Context, args: list of string);
};

init(ctx: ref Draw->Context, args: list of string)
{
    sys = load Sys Sys->PATH;

    # Create an array of file descriptors. This must have a pre-determined size.
    descs := array[2] of ref FD;

    
    f1 := pipe(descs);
    if (f1 != 0) {
        sys->fprint(sys->fildes(2), "Failed to created pipe.\n");
        exit;
    }

    print("Pipe created successfully.\n");
}
