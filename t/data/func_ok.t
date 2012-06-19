#! /bin/sh

. ./libtest.sh || exit 255

tests 5

type func_ok | grep -q 'func_ok is a shell function'
ok		"$? -eq 0"					'func_ok()'
BAIL_OUT "func_ok() not defined"

func_ok	func_ok			'func_ok() defined'

func_ok	nonexistent	'nonexistent() defined (failed)'
func_ok	''			'empty function argument (failed)'

new_func_def ()
{
:
}
func_ok	new_func_def	'new_func_def() defined'


#EOF
