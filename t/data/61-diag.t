
. ./libtest.sh || exit 255

tests 2
ok "1 -eq 1"			'test ok'		&& diag 'Haha -- 1 -eq 1'
ok "1 -eq 0"			'failed test'	&& diag 'Check wheter 1 -eq 0!'

done_testing
#EOF
