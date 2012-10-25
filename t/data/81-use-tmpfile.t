#! /bin/sh

. ./libtest.sh

set +e	# disable 'errexit'

tests 4

libtest_mktemp
is_status	0		'mktemp() run successfully'
echo tmpfile=$LIBTEST_TMP

ok "-w $LIBTEST_TMP"	'  tmpfile exists and is writable'

ok "! -s $LIBTEST_TMP"	'  tmpfile has zero size'

echo hello world >| $LIBTEST_TMP
ok "-s $LIBTEST_TMP"	'  tmpfile now has size greater zero'

# DO NOT DELETE $LIBTEST_TMP

#EOF
