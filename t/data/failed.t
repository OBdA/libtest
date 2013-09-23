. ./libtest.sh || exit 255

tests 2
ok "1 -eq 1"			'test ok'
ok "1 -eq 0"			'failed test'

done_testing
#EOF
