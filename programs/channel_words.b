implement Words;

include "sys.m";
    sys: Sys;
include "draw.m";
include "string.m";
    str: String;

Words: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

init(ctxt: ref Draw->Context, args: list of string)
{
    sys = load Sys Sys->PATH;
    str = load String String->PATH;

    c := chan of string;
    spawn words(c);
    s: string;

    for (;;) {
        s = <- c;
        if (s == nil) break;
        sys->print("%s ", s);
    }

    sys->print("\n");
}

words(c: chan of string)
{
    s := "The quick brown fox jumps over the lazy dog.";
    word : string;

    while (s != nil) {
        (word, s) = str->splitl(s, " ");
        c <-= word;
        if (len(s) > 1)
            s = s[1:];
    }

    c <-= nil;
}
