#! /bin/sh

. ./libtest.sh || exit 255


# prepare the tests
mkdir -p t/tmp
tmpd=$(mktemp -d t/tmp/,XXXXX)
[ -d "$tmpd" ] || exit 255


tests 7

func_ok	diag					'diag()'
BAIL_OUT	'function diag() undefined'

( t/data/diag.t )	> $tmpd/out 2> $tmpd/err
is_status	1					'test script'

ok "-s $tmpd/out -a -s $tmpd/err"	'  output'

is_num $(cat $tmpd/out|wc -l)	4			'  lines of STDOUT'
is_num $(cat $tmpd/err|wc -l)	3			'  lines of STDERR'
is_num $(cat $tmpd/*|grep '^#'|wc -l)	4	'  lines of messages'

like_file	$tmpd/err	'Check wheter 1 -eq 0!' \
	'Diagnostic message'


rm -rf $tmpd
exit 0

#EOF
