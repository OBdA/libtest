#! /bin/sh

# prepare the tests
mkdir -p t/tmp
tmpd=$(mktemp -d t/tmp/,XXXXX)
[ -d "$tmpd" ] || exit 255


. ./libtest.sh || exit 255

tests 5

func_ok	__ok						'__ok()'
BAIL_OUT "__ok() not defined"

func_ok	__nok						'__nok()'
BAIL_OUT "__nok() not defined"

(
	eval ". ./libtest.sh" || exit 255
	__ok passed
	__nok failed
) >$tmpd/out 2>&1
is_status 1				'dummy test'

like_file $tmpd/out	'ok 1 - passed'		'  message for __ok()'
like_file $tmpd/out	'not ok 2 - failed'	'  message for __nok()'


rm -rf $tmpd
exit 0

#EOF
