#! /bin/sh

. ./libtest.sh || exit 255


##
## BEGIN
##

# prepare the tests
mkdir -p t/tmp
tmpd=$(mktemp -d t/tmp/,nok.XXXXX)	|| exit 255


## run the tests

tests 4

err=$( t/data/72-format-todo.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:-0}	0		'format test ok'

is_num	$(cat $tmpd/err|wc -l)	0		'no output on stderr'

err=$(prove -e /bin/sh t/data/72-format-todo.t >| $tmpd/prove.out 2>&1 || echo $?)
is_num	${er:-0}	0		'prove returns 0'
like_file	$tmpd/prove.out	'Result: PASS'	'test passed (via prove)'
diag "Output was:\n$(cat $tmpd/prove.out)"

${DEBUG:-} || rm -rf $tmpd
#EOF
