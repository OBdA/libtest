#! /bin/sh

. ./libtest.sh

tests 4

is_num $((1+1)) 2		'test is ok'

TODO 'Three failed tests'
fail			'todo test failed'
is_num	5	42	'another test failed'
fail			'third todo test failed'
TODO

exit 0

#EOF
