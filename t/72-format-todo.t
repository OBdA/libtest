#! /bin/sh

. ./libtest.sh || exit 255


##
## BEGIN
##

# prepare the tests
mkdir -p t/tmp
tmpd=$(mktemp -d t/tmp/,nok.XXXXX)	|| exit 254


## run the tests

tests 4

( t/data/72-format-todo.t ) >| $tmpd/out 2>| $tmpd/err
is_status	0		'format test ok'

is_num	$(cat $tmpd/err|wc -l)	0		'no output on stderr'

prove		-e /bin/sh t/data/72-format-todo.t >| $tmpd/prove.out 2>&1
is_status	0		'proved returns 0'
like_file	$tmpd/prove.out	'Result: PASS'	'test passed (via prove)'

${DEBUG:-} || rm -rf $tmpd
#EOF
