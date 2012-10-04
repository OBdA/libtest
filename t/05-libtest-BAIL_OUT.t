#! /bin/sh

. ./libtest.sh || exit 255

# prepare the tests
mkdir -p t/tmp
tmp=$(mktemp t/tmp/,XXXXX)
[ -f "$tmp" ] || exit 255


tests 6

err=$( t/data/BAIL_OUT.t >| $tmp 2>&1 || echo $?)
is_num	${err:=0}	255					'test script'

ok "-s $tmp"							'  output'

is_num	$(cat $tmp|wc -l)	6			'  lines of output'

is_num	$(cat $tmp|grep '^#'|wc -l)	2	'  lines of messages'

like_file	$tmp	'Bail out'			'Bail Out message'
like_file	$tmp	'FAILED!'			'  description of BAIL_OUT'


rm -f $tmp
exit 0

#EOF
