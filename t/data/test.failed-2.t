#! /bin/sh

. ./libtest.sh || exit 255

tests 3

ok "0 =! 0" 		failed
ok "0 -eq 0" 		failed
ok "0 =! 0" 		failed

#EOF
