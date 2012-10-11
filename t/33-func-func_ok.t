#! /bin/sh

. ./libtest.sh || exit 255


# prepare the tests
mkdir -p t/tmp
tmpd=$(mktemp -d t/tmp/,XXXXX)
[ -d "$tmpd" ] || exit 255


tests 7

err=$(type func_ok | egrep -q 'func_ok is a( shell)? function' || echo $?)
is_num	${err:=0}	0	'func_ok()'
BAIL_OUT "func_ok() not defined"

func_ok func_ok			'func_ok defined'


err=$( t/data/33-func_ok.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:=0}	2	'Test script'

ok "-s $tmpd/out -a -s $tmpd/err"	'Output'

is_num $(cat $tmpd/out | wc -l)	6	'  count stdout'
is_num $(cat $tmpd/err | wc -l)	7	'  count stderr'

like_file	$tmpd/err	"# Looks like you failed 2 tests of 5 run\." \
	"test summary"


rm -rf $tmpd
exit 0

#EOF
