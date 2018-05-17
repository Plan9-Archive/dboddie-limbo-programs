implement AdtTest;

include "sys.m";
include "draw.m";

AdtTest: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

Greeting: adt
{
    words: string;
};

init(ctxt: ref Draw->Context, args: list of string)
{
    sys := load Sys Sys->PATH;

    a := ref Greeting("Hello");
    sys->print("%s\n", a.words);

    update_greeting(a);
    
    sys->print("%s\n", a.words);
}

update_greeting(b: ref Greeting)
{
    b.words = "Hi!";
}
