#! /bin/sh

. ./libtest.sh || exit 255

tests 1

pass 'first test'
fail 'second test failed'
pass 'third test'

done_testing

#EOF
