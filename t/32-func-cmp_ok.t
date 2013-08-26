
. ./libtest.sh || exit 255


# prepare the tests
mkdir -p t/tmp
tmpd=$(mktemp -d t/tmp/,XXXXX)
[ -d "$tmpd" ] || exit 255


tests 15

err=$($SHELL t/data/32-cmp_ok.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:=0}	4	'test script'

ok "-s $tmpd/out -a -s $tmpd/err"	'Output'

like_file $tmpd/err	"Looks like you failed 4 tests of 8 run\." \
	'test summary'


like_file $tmpd/out	'not ok 3 - got "rain" expect ""' \
	'got rain expect NULL'
like_file $tmpd/err	"got: 'rain'"		'  got rain'
like_file $tmpd/err	"expected: ''"		'  expected NULL'


like_file $tmpd/err	"Failed test 'got apple expect plum'" \
	'got apple expect plum'
like_file $tmpd/err	"got: 'apple'"		'  got apple'
like_file $tmpd/err	"expected: 'plum'"	'  want plum'


like_file $tmpd/err	"Failed test 'got gold expect no gold'"\
	'got gold expect no gold'
like_file $tmpd/err	"got: 'gold'"			'  got gold'
like_file $tmpd/err	"expected: 'gold'"		'  want no gold'


like_file $tmpd/err	"Failed test 'got three want zero'"	'got three want zero'
like_file $tmpd/err	"got: '3'"							'  got three'
like_file $tmpd/err	"expected: '0'"						'  want zero'


rm -rf $tmpd
exit 0

#EOF
