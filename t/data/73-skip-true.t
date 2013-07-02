#! /bin/sh
set -e

. ./libtest.sh || exit 255

tests 4


SKIP "42 -eq 42" live your life
ok "1 -eq 1"			'skipped ok'
ok "1 -eq 0"			'skipped failed'
SKIP

# normal tests
ok "0 -eq 0"			'test ok'
ok "1 -eq 0"			'test failed'

#EOF
