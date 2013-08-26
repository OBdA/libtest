
. ./libtest.sh || exit 255


# prepare the tests
mkdir -p t/tmp
tmpd=$(mktemp -d t/tmp/,XXXXX)
[ -d "$tmpd" ] || exit 255


tests 9

func_ok pass    'pass()'
BAIL_OUT "pass() not defined"

func_ok fail    'fail()'
BAIL_OUT "fail() not defined"

err=$( $SHELL t/data/pass.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:=0}	1	'test script'

ok "-s $tmpd/out -a -s $tmpd/err"	'Output'

is_num $(cat $tmpd/out | wc -l)	5	'  count stdout'
is_num $(cat $tmpd/err | wc -l)	3	'  count stderr'

like_file $tmpd/out "test has passed"	'pass() message'
like_file $tmpd/out "test has failed"	'fail() message'

like_file $tmpd/err	"# Looks like you failed 1 tests of 4 run\." \
	"test summary"


rm -rf $tmpd
exit 0

#EOF
