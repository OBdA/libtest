#! /bin/sh

. ./libtest.sh || exit 255

tests 4

func_ok pass	'pass()'
func_ok fail	'fail()'

pass			'test has passed'
fail			'test has failed'

#EOF
