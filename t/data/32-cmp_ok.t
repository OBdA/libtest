
. ./libtest.sh || exit 255

tests 8
cmp_ok ""		'=' ""			'got "" expect ""'
cmp_ok ""		'!=' "fish"		'got "" expect not "fish"'
cmp_ok "rain"	'=' ""			'got "rain" expect ""'

cmp_ok "much"		'=' "much"			'got much expect much'
cmp_ok "apple"		'=' "plum"			'got apple expect plum'
cmp_ok "gold"		'!=' "gold"			'got gold expect no gold'

cmp_ok "0"	'-eq' "0"					'got zero want zero'
cmp_ok "3"	'-eq' "0"					'got three want zero'


done_testing
#EOF
