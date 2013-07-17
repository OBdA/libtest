
. ./libtest.sh || exit 255

tests	5

func_ok	tests		'tests()'
ok "1 -eq 1"			'test ok'

#EOF
