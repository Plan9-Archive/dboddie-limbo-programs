implement Polymorphism;

include "sys.m";
    sys: Sys;
include "draw.m";

Polymorphism: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

Value: adt[T]
{
    value: T;
    show: fn[T](value: self ref Value);
};

Int: adt
{
    i: int;
    show: fn(i: self ref Int);
};

init(ctxt: ref Draw->Context, args: list of string)
{
    sys = load Sys Sys->PATH;

    a := Value[string]("Hello");
    b := ref Value[ref Int](ref Int(123));

    #show(a); Not possible because a is not a reference.
    show(b);
    #b.show();
}

show[T](value: ref Value[T])
    for { T => show: fn(v: self T); }   # Defines the show function for the
{                                       # specific type, relating it to the
    value.value.show();                 # existing functions/methods.
}

Value[T].show[T](value: self ref Value) # The T subscript by the function name
    for { T => show: fn(v: self T); }   # is necessary to use the type within
{                                       # the function.
    value.show();
}

Int.show(i: self ref Int)
{
    sys->print("%d\n", i.i);
}
