#! /bin/sh

. ./libtest.sh || exit 255


##
## BEGIN
##

# prepare the tests
mkdir -p t/tmp
tmp=$(mktemp t/tmp/,nok.XXXXX)	|| exit 254


## run the tests

tests 4

( t/data/20-zero-of-three.t ) >| $tmp 2>&1
is_status	0							'zero of three failed'
like_file	$tmp	'^tests_failed:$'	'  output of tests_failed'

( t/data/20-two-of-three.t ) >| $tmp 2>&1
is_status	2							'zero of three failed'
like_file	$tmp	'^tests_failed:2$'	'  output of tests_failed'

${DEBUG:-} || rm -rf $tmpd
#EOF
