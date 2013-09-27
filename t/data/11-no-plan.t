
. ./libtest.sh || exit 255

func_ok	tests		'tests()'
ok "1 -eq 1"		'test ok'

done_testing
#EOF
