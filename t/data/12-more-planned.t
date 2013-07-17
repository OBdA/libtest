
. ./libtest.sh || exit 255

tests 5

pass 'first test'
fail 'second test failed'
pass 'third test'

done_testing

#EOF
