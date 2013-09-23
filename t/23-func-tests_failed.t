set -e

. ./libtest.sh || exit 255


##
## BEGIN
##

# prepare the tests
mkdir -p t/tmp
tmp=$(mktemp t/tmp/,nok.XXXXX)	|| exit 255


## run the tests

tests 4

err=$( $SHELL t/data/23-zero-of-three.t >| $tmp 2>&1 || echo $?)
is_num	${err:=0}	0					'zero of three failed'
like_file	$tmp	'^tests_failed:$'	'  output of tests_failed'

err=$( $SHELL t/data/23-two-of-three.t >| $tmp 2>&1 || echo $?)
is_num	${err:=0}	2					'zero of three failed'
like_file	$tmp	'^tests_failed:2$'	'  output of tests_failed'

${DEBUG:+echo DEBUG} rm -rf $tmp
done_testing

#EOF
