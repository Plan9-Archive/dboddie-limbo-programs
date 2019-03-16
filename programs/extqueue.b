# extqueue.b
#
# Written in 2018 by David Boddie <david@boddie.org.uk>
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# An extensible queue container.

implement ExtQueueTest;

# Import modules to be used and declare any instances that will be accessed
# globally.

include "sys.m";
include "draw.m";
include "string.m";

ExtQueueTest: module
{
    init: fn(ctxt: ref Draw->Context, args: list of string);
};

ExtQueue: adt[T] {
    a: array of T;
    front, back: int;
    original_size: int;
    full: int;

    new: fn(size: int): ref ExtQueue[T];
    count: fn(eq: self ref ExtQueue[T]): int;
    extend: fn(eq: self ref ExtQueue[T], size: int);
    push: fn(eq: self ref ExtQueue[T], value: T);
    pop: fn(eq: self ref ExtQueue[T]): T;
};

init(ctxt: ref Draw->Context, args: list of string)
{
    # Load instances of modules, one local to init, the other global.
    sys := load Sys Sys->PATH;
    str := load String String->PATH;

    s := "The quick brown fox jumps over the lazy dog.";
    earray := ExtQueue[string].new(4);

    while (s != nil) {
        word: string;
        (word, s) = str->splitstrl(s, " ");

        sys->print("Push: %s ", word);
        earray.push(word);
        sys->print("front=%d, back=%d, size=%d, count=%d\n", earray.front,
            earray.back, len earray.a, earray.count());

        if (len s > 0)
            s = s[1:];
    }

    while (earray.count() != 0) {
        value := earray.pop();
        sys->print("Value: %s\n", value);
    }

    sys->print("front=%d, back=%d, size=%d, count=%d\n", earray.front,
        earray.back, len earray.a, earray.count());
}

ExtQueue[T].new(size: int): ref ExtQueue[T]
{
    a := array[size] of T;
    return ref ExtQueue[T](a, 0, 0, size, 0);
}

ExtQueue[T].count(eq: self ref ExtQueue[T]): int
{
    if (eq.full)
        return len eq.a;

    l := eq.back - eq.front;
    if (l < 0)
        l = len eq.a + l;

    return l;
}

ExtQueue[T].extend(eq: self ref ExtQueue[T], size: int)
{
    na := array[size] of T;

    i := eq.front;
    j := 0;

    do {
        na[j] = eq.a[i];
        i = (i + 1) % (len eq.a);
        j++;
    } while (i != eq.front);

    eq.front = 0;
    eq.back = j;
    eq.a = na;
    eq.full = 0;
}

ExtQueue[T].push(eq: self ref ExtQueue[T], value: T)
{
    if (eq.full)
        eq.extend(len eq.a + eq.original_size);

    eq.a[eq.back] = value;

    # Update the back of the queue, wrapping round to the start of the array
    # if necessary.
    eq.back = (eq.back + 1) % (len eq.a);

    if (eq.front == eq.back)
        eq.full = 1;
}

ExtQueue[T].pop(eq: self ref ExtQueue[T]): T
{
    # Return nil for an empty queue.
    if (eq.front == eq.back)
        return nil;

    item := eq.a[eq.front];

    # Update the front of the queue, wrapping round to the start of the array
    # if necessary.
    eq.front = (eq.front + 1) % (len eq.a);

    if (eq.front == eq.back)
        eq.full = 0;

    return item;
}
