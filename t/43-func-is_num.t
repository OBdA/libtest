
. ./libtest.sh || exit 255


# prepare the tests
mkdir -p t/tmp
tmpd=$(mktemp -d t/tmp/,XXXXX)
[ -d "$tmpd" ] || exit 255


tests 9

func_ok	is_num						'is_num()'
BAIL_OUT "is_num() not defined"

func_ok	isnt_num					'isnt_num()'
BAIL_OUT "isnt_num() not defined"


err=$( $SHELL t/data/43-is_num.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:=0}	6	'test script return value'

ok "-s $tmpd/out -a -s $tmpd/err"		'  output'
is_num $(cat $tmpd/out | wc -l)	12		'  count stdout'
is_num $(cat $tmpd/err | wc -l)	25		'  count stderr'


like_file	$tmpd/err	"got: 'no' as expected value" \
	"'no' isn't a number"

like_file	$tmpd/err	"got: 'yes' as test value" \
	"'yes' isn't a number"

like_file	$tmpd/err	"# Looks like you failed 6 tests of 11 run." \
	"test summary"


rm -rf $tmpd
exit 0

#EOF
