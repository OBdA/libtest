
. ./libtest.sh || exit 255

tests 12

func_ok	is							'is()'
BAIL_OUT "is() not defined"

func_ok	isnt						'isnt()'
BAIL_OUT "isnt() not defined"

is		''			''				'  got NULL expect NULL'
isnt	''			''				'  got NULL expect not NULL'

is		alpha		''				'  got alpha expect NULL'
is		''			beta			'  got NULL expect beta'

isnt	alpha		''				'  got alpha expect not NULL'
isnt	''			beta			'  got NULL expect not beta'

is		"much"		"much"			'  got much expect much'
is		"apple"		"plum"			'  got apple expect plum'

isnt	"silver"	"gold"			'  got silver expect no gold'
isnt	"gold"		"gold"			'  got gold expect no gold'

done_testing
#EOF
