#!/bin/sh

sbcl --non-interactive --disable-debugger --load src/crow.lisp --eval "(progn (sb-ext:disable-debugger) (sb-ext:save-lisp-and-die \"bin/crow\" :toplevel #'main :executable t :purify t))"
