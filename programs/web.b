# Shows how to fetch a web page from a server on the local host using the
# sys->dial function.

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

    # Define the host and port to connect to, combining the two to make a
    # network specification string to pass to the dial function.
    host := "127.0.0.1";
    port := 80;
    dial_string := sys->sprint("tcp!%s!%d", host, port);

    # Dial the host using the network specification string to obtain a flag
    # indicating success or failure, and a Connection object.
    (ok, conn) := sys->dial(dial_string, nil);

    if (ok == 0)
        sys->print("Connected to %s\n", dial_string);
    else
        sys->print("Failed to connect to %s\n", dial_string);

    # The following function fetches a page from the server, passing the data
    # file descriptor associated with the Connection object.
    request("GET", "/", conn.dfd, sys->fildes(1));
}

# This function accepts a method and path for the server to interpret as a
# request, as well as the file descriptors to use to send the request and
# receive a response.
request(method, path: string, dfd, outfd: ref sys->FD)
{
    # Create a byte array containing the request string and write it to the
    # Connection's data file descriptor.
    b := array of byte (method + " " + path + "\r\n");
    n := sys->write(dfd, b, len(b));

    # Return if the request could not be written.
    if (n != len(b))
        return;

    # Buffer the output in a 32 byte array.
    output := array[32] of byte;
    r : int;

    for (;;) {
        # (Be careful not to shadow the r variable with a new definition.)
        # Read 32 bytes at a time and write them to the output file.
        r = sys->readn(dfd, output, 32);
        if (r == 0)
            break;
        sys->write(outfd, output, r);
    }
}
