#! /bin/sh

. ./libtest.sh || exit 255

tests 3
ok "0 != 0"			'failed test'
ok "0 != 0"			'failed test'
ok "0 != 0"			'failed test'

#EOF
