Limbo Examples
==============

* `adttest.b`

  Tests my intuition about references to ADTs, creating references and
  modifying them.

* `args.b`

  Shows command line arguments.

* `arrays.b`

  Tests my intuition about how arrays are defined and initialised at the same
  time.

* `channels.b`

  Reads strings and integers sequentially from spawned processes via two
  channels.

* `channel_words.b`

  Reads strings sequentially from a spawned process via a channel.

* `cmdlinedrawtest.b`

  Uses the Draw module to render an image which is exported as a PPM file in
  the current directory.

* `count.b`

  A simple loop that prints integers from 0 to 19.

* `countmin.b`

  A program that performs an empty loop.

* `draw-example.b`

  From the draw-example man 2 page.

* `drawtest.b`

  Draws an image on the display and saves the result to a PPM image, or to
  stdout if no file name is passed as an argument.

* `drawtest-wm.b`

  Draws an image on the display and saves the result to a PPM image, or to
  stdout if no file name is passed as an argument. Requires the window manager
  to be running.

* `empty.b`

  Implements an empty module.

* `globals.b`

  Tests my intuition about how global variables are defined when they are
  exported from the module.

* `hashtest.b`

  Shows how the Hash module is used to store and retrieve associative data.

* `Hello.b`

  Hello world in Limbo.

* `Hello2.b`

  Hello world in Limbo with sleep calls.

* `inherit.b`

  Implements a simple form of inheritance where an instance of a specialised
  ADT contains an instance of the more general ADT it "inherits" from. Method
  calls are forwarded to the base implementation before code in the specialised
  ADT is executed.

* `low-level-windows.b`

  Shows how to create windows using the low-level API provided by the Screen
  ADT in the Draw module.

* `mandelbrot.b`

  Creates a window using the Wmclient module and draws a Mandelbrot set in it.

* `nested.b`

  Simple example of nested loops.

* `newhashtest.b`

  Shows how the NewHash module can be used to store and retrieve associative
  data without the overhead of the Hash module.

* `numbers.b`

  Tests my intuition about chained assignment.

* `onevar.b`

  Tests my intuition about variable definition and assignment.

* `pickadttest.b`

  Simple example showing how pick ADTs can be used to store values of different
  predefined types in an ADT, and how to retrieve those values using a pick
  statement.

* `raisetest.b`

  Experimenting with defining and raising an exception, as well as declaring
  that a function may contain code that raises an exception.

* `references.b`

  Tests my intuition about references.

* `selftest.b`

  Tests the use of the self keyword in ADT function declarations, allowing them
  to be called as methods on instances of those ADTs.

* `shell.b`

  Shows how to start a shell using the Sh module.

* `stdoutwriter.b`

  Shows how to write to stdout using both the `sys->fprint` function and an I/O
  buffer.

* `strings.b`

  Tests my intuition about strings, characters and string splitting.

* `tkhello.b`

  The updated Hello World example from the Inferno documents.

* `twovars.b`

  Tests my intuition about declaring two variables with the same type.

* `web.b`

  Shows how to fetch a web page from a server on the local host using the
  `sys->dial` function.

* `windowtest.b`

  Shows how to use the Wmclient module to open a window and respond to user
  input.

* `wmbackground.b`

  Shows how to draw on the background image in the window manager.


License
-------

All the examples, except for `draw-example.b` and `tkhello.b`, are licensed
under the Creative Commons CC0 1.0 Universal license. See the `LICENSE.txt`
file for the full text of this license.

The following online resources also contain the summary and full text of the
license:

https://creativecommons.org/publicdomain/zero/1.0/
https://creativecommons.org/publicdomain/zero/1.0/legalcode
