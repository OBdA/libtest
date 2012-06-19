#! /bin/sh

. ./libtest.sh || exit 255

tests 4


TODO produce success output
ok "1 -eq 1"			'test ok'

TODO produce failed output
ok "1 -eq 0"			'failed test'
TODO

# normal tests
ok "0 -eq 0"			'test ok'

ok "1 -eq 0"			'this test failed'

#EOF
