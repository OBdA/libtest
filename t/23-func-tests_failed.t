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

err=$( t/data/23-zero-of-three.t >| $tmp 2>&1 || echo $?)
is_num	${err:=0}	0					'zero of three failed'
like_file	$tmp	'^tests_failed:$'	'  output of tests_failed'

err=$( t/data/23-two-of-three.t >| $tmp 2>&1 || echo $?)
is_num	${err:=0}	2					'zero of three failed'
like_file	$tmp	'^tests_failed:2$'	'  output of tests_failed'

${DEBUG:-} || rm -rf $tmpd
#EOF
