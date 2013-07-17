set -e

. ./libtest.sh || exit 255

tests 4


SKIP "1 -eq 0" not skipped
ok "1 -eq 1"			'not skipped ok'
ok "1 -eq 0"			'not skipped failed'
SKIP

# normal tests
ok "0 -eq 0"			'test ok'
ok "1 -eq 0"			'test failed'

#EOF
