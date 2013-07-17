
. ./libtest.sh || exit 255

tests	1

func_ok	tests		'tests()'
ok "1 -eq 1"			'test ok'

#EOF
