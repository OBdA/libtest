set -e

. ./libtest.sh || exit 255


##
## BEGIN
##

# prepare the tests
mkdir -p t/tmp
tmpd=$(mktemp -d t/tmp/,nok.XXXXX)	|| exit 255


## run the tests

tests 6

err=$( $SHELL t/data/05-messages.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:=0}	1	'one test really failed'

ok "-s $tmpd/out"		'there is STDOUT output'
ok "-s $tmpd/err"		'there is STDERR output'

# Looks like you planned 2 tests but ran 4.
# Looks like you failed 1 test of 4 run.
like_file	$tmpd/err	'Looks like you planned 2 tests but ran 4' \
						'Failed plan is STDERR'
like_file	$tmpd/err	'Looks like you failed 1 tests of 4' \
						'Failed test summary is STDERR'


err=$(prove -e $SHELL t/data/05-messages.t >| $tmpd/p.out 2>| $tmpd/p.err||echo $?)
like_file	$tmpd/p.out	'1 TODO test unexpectedly succeeded' \
						'one todo test unexpectedly succeeded'


${DEBUG:+echo} rm -rf $tmpd
done_testing
#EOF
