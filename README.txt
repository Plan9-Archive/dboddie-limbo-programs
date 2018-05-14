Getting Started
===============

1. Build a hosted Inferno environment.

2. Ensure that `limbo` and `emu` are on the path by adding the directory
   containing those executables for the host system to the `PATH` environment
   variable.

   If you have separate directories containing the build system and hosted
   installation then the path will refer to a directory in the build
   directory.

3. Run `limbo` to compile programs, passing `-o` with the location on the
   host's filing system of the resulting `.dis` files, which should be within
   the hosted environment.

4. Run `emu` with the `-r` option to specify the location of the hosted
   environment on the host's filing system and the `-d` option to specify the
   location of the `.dis` files in the hosted environment.


Example
-------

export INFERNO_ROOT=/home/user/inferno-os
export HOSTED_ROOT=/home/user/hosted
export SYSHOST=Linux
export ARCH=386
export PATH=$INFERNO_ROOT/$SYSHOST/$ARCH/bin:$PATH

limbo -o $HOSTED_ROOT/tmp/output.dis programs/Hello.b
emu -r $HOSTED_ROOT -d /tmp/output.dis

