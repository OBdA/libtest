#! /bin/sh

. ./libtest.sh || exit 255

# prepare the tests
mkdir -p t/tmp
tmpd=$(mktemp -d t/tmp/,XXXXX)
[ -d "$tmpd" ] || exit 255


tests 8

func_ok	like_file		'like_file()'
BAIL_OUT "like_file() not defined"

func_ok	unlike_file		'unlike_file()'
BAIL_OUT "unlike_file() not defined"


( t/data/like_file.t )	> $tmpd/out 2> $tmpd/err
is_status	4						'test script'

ok "-s $tmpd/out -a -s $tmpd/err"	'Output'

is_num $(cat $tmpd/out | wc -l)	12	'  count stdout'
is_num $(cat $tmpd/err | wc -l)	14	'  count stderr'

grep -q "File not readable: 't/data/nonexistent'"	$tmpd/err
is_status	0	'message: file not readable'

grep -q "RegExp: 'nutella'" $tmpd/err
is_status	0	'message: regular expression'


rm -rf $tmpd
exit 0

#EOF
