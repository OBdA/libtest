
. ./libtest.sh || exit 255

tests 11

func_ok	is_num						'is_num()'
BAIL_OUT "is_num() not defined"

is_num		0			no				'  0   -eq no'
is_num		yes			11				'  yes -eq 11'
is_num		0			0				'  0   -eq 0'
is_num		1			-1				'  1   -eq -1'

func_ok	isnt_num						'isnt_num()'
BAIL_OUT "isnt_num() not defined"

isnt_num	0			nein			'  0  != nein'
isnt_num	ja			11				'  ja != 11'

isnt_num	0			0				'  0  != 0'
isnt_num	-15			-1				' -15 != -1'
isnt_num	15			0				'  15 != 0'

#EOF
