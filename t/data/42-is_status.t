
. ./libtest.sh || exit 255

tests 12

func_ok is_status					'is_status()'
BAIL_OUT "is_status() not defined"

true
is_status		0	'  true returns 0'

true
is_status		1	'  true returns 1 (failed)'

false
is_status		1	'  false returns 1'

false
is_status		2	'  false returns 2 (failed)'

( exit 11 )
is_status		11	'  exit 11 returns 11'


func_ok isnt_status					'isnt_status()'
BAIL_OUT "isnt_status() not defined"

true
isnt_status		0	'  true returns NOT 0 (failed)'

true
isnt_status		5	'  true returns NOT 5'

false
isnt_status		1	'  false returns NOT 1 (failed)'

false
isnt_status		1	'  false returns NOT 2 (failed)'

( exit 11 )
isnt_status		11	'  exit 11 returns NOT 11 (failed)'

done_testing
#EOF
