implement Web;

include "draw.m";
include "sys.m";
    sys: Sys;

Web : module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

init(ctxt: ref Draw->Context, args: list of string)
{
    sys = load Sys Sys->PATH;

    host := "127.0.0.1";
    port := 80;
    dial_string := sys->sprint("tcp!%s!%d", host, port);

    (ok, conn) := sys->dial(dial_string, nil);

    if (ok == 0)
        sys->print("Connected to %s\n", dial_string);
    else
        sys->print("Failed to connect to %s\n", dial_string);

    request("GET", "/", conn.dfd, sys->fildes(1));
}

request(method, path: string, dfd, outfd: ref sys->FD)
{
    b := array of byte (method + " " + path + "\r\n");
    n := sys->write(dfd, b, len(b));

    if (n != len(b))
        return;

    output := array[32] of byte;
    r : int;

    for (;;) {
        # Be careful not to shadow the r variable with a new definition.
        r = sys->readn(dfd, output, 32);
        if (r == 0)
            break;
        sys->write(outfd, output, r);
    }
}
