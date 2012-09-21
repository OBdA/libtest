#! /bin/sh

. ./libtest.sh || exit 255


##
## BEGIN
##

# prepare the tests
mkdir -p t/tmp
tmpd=$(mktemp -d t/tmp/,nok.XXXXX)	|| exit 254


## run the tests

tests 6

( t/data/00-messages.t ) >$tmpd/out 2>$tmpd/err
is_status	1			'one test really failed'

ok "-s $tmpd/out"		'there is STDOUT output'
ok "-s $tmpd/err"		'there is STDERR output'

TODO	check stdout/stderr
# Looks like you planned 2 tests but ran 4.
# Looks like you failed 1 test of 4 run.
like_file	$tmpd/err	'Looks like you planned 2 tests but ran 4' \
						'Failed plan is STDERR'
like_file	$tmpd/err	'Looks like you failed 1 tests of 4' \
						'Failed test summary is STDERR'
TODO


TODO	check TODO messages via prove
( prove -e /bin/sh t/data/00-messages.t ) >$tmpd/p.out 2>$tmpd/p.err
like_file	$tmpd/p.out	'1 TODO test unexpectedly succeeded' \
						'one todo test unexpectedly succeeded'
TODO

${DEBUG:-} || rm -rf $tmpd
#EOF
