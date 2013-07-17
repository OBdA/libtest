
# prepare the tests
mkdir -p t/tmp
tmpd=$(mktemp -d t/tmp/,XXXXX)
[ -d "$tmpd" ] || exit 255


. ./libtest.sh || exit 255

tests 5

func_ok	__ok						'__ok()'
BAIL_OUT "__ok() not defined"

func_ok	__nok						'__nok()'
BAIL_OUT "__nok() not defined"

err=$( t/data/00-ok-nok.t >| $tmpd/out 2>&1 || echo $? )
is_num	${err:=0}	1	'dummy test'

like_file $tmpd/out	'ok 1 - passed'		'  message for __ok()'
like_file $tmpd/out	'not ok 2 - failed'	'  message for __nok()'


test ${DEBUG:-} || rm -rf $tmpd
exit 0

#EOF
