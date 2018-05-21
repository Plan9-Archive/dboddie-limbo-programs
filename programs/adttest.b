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

    # Create a new instance and take a reference to (a copy of) it.
    a := ref Greeting("Hello");
    sys->print("%s\n", a.words);

    update_greeting(a);
    
    sys->print("%s\n", a.words);

    b := Greeting("Hiya");
    c := ref b;
    sys->print("%x %s\n", c, c.words);
    d := ref b;
    sys->print("%x %s\n", d, d.words);

    update_greeting(c);
    update_greeting(d);
    
    sys->print("%s\n", c.words);
    sys->print("%s\n", d.words);
}

update_greeting(b: ref Greeting)
{
    b.words += " Hi!";
}
