#! /bin/sh

. ./libtest.sh || exit 255

tests 3

fail	'test #1'
pass	'test #2'
fail	'test #3'

echo "tests_failed:$(tests_failed)"

exit 0
#EOF
