#! /bin/sh

. ./libtest.sh || exit 255


# prepare the tests
mkdir -p t/tmp
tmp=$(mktemp t/tmp/,XXXXX)
[ -f "$tmp" ] || exit 255


tests 5

( t/data/failed.t )	> $tmp 2>&1

is_status	1	'Test has one failed test'
BAIL_OUT	'failed simple test'

ok "-s $tmp"		"Output file has content"

is_num $(grep '^#' $tmp|wc -l)	3	'Messages in output'

like_file	$tmp	"Looks "	'  Looks - message'

like_file	$tmp	"Looks like you failed 1 tests of 2 run\." \
	'  test summary'

rm -f $tmp
#EOF
