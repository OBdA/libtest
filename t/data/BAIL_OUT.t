#! /bin/sh

. ./libtest.sh || exit 255

tests 3
ok "1 -eq 1"			'test ok'
ok "1 -eq 0"			'failed test'	&& BAIL_OUT 'FAILED!'

#EOF
