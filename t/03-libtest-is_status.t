#! /bin/sh

. ./libtest.sh || exit 255

# prepare the tests
mkdir -p t/tmp
tmpd=$(mktemp -d t/tmp/,XXXXX)
[ -d "$tmpd" ] || exit 255


tests 7

func_ok	is_status					'is_status()'
BAIL_OUT "is_status() not defined"

func_ok	isnt_status					'isnt_status()'
BAIL_OUT "isnt_status() not defined"


( t/data/is_status.t )	> $tmpd/out 2> $tmpd/err
cmp_ok "$?" '-eq' 6					'test script'

ok "-s $tmpd/out -a -s $tmpd/err"	'  Output'

cmp_ok $(cat $tmpd/out | wc -l) -eq 13	'  count stdout'
cmp_ok $(cat $tmpd/err | wc -l) -eq 25	'  count stderr'

grep -q "# Looks like you failed 6 tests of 12 run\."	$tmpd/err
ok "$? -eq 0"		"test summary"


rm -rf $tmpd
exit 0

#EOF
