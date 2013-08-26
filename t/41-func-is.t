set -e

. ./libtest.sh || exit 255

# prepare the tests
mkdir -p t/tmp
tmpd=$(mktemp -d t/tmp/,XXXXX)
[ -d "$tmpd" ] || exit 255


tests 13

func_ok	is						'is()'
BAIL_OUT "is() not defined"

func_ok	isnt					'isnt()'
BAIL_OUT "isnt() not defined"


err=$( $SHELL t/data/41-is.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:=0}	5	'test script'

ok "-s $tmpd/out -a -s $tmpd/err"	'Output'

is_num $(cat $tmpd/out | wc -l)	13	'  count stdout'
is_num $(cat $tmpd/err | wc -l)	21	'  count stderr'

like_file $tmpd/out	'not ok 4 -   got NULL expect not NULL' \
	'got NULL expect no NULL'
like_file $tmpd/err	"got: ''" \
	"  got ''"
like_file $tmpd/err	"expected: anything else" \
	"  expected anything else"

like_file $tmpd/out	'not ok 10 -   got apple expect plum' \
	'got apple expect plum'
like_file $tmpd/err	'expected: anything else' \
	'  expected anything else'

like_file $tmpd/out	'not ok 12 -   got gold expect no gold' \
	'got gold expect no gold'
like_file $tmpd/err	'expected: anything else' \
	'  expected anything else'

rm -rf $tmpd
exit 0

#EOF
