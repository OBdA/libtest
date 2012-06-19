#! /bin/sh

. ./libtest.sh || exit 255


tests 7

func_ok __is_number		'__is_number()'
BAIL_OUT "__is_number() not defined"

__is_number 0
is_status 0     '__is_number 0'

__is_number 1
is_status 0     '__is_number 1'

__is_number 655528
is_status 0     '__is_number 655528'

__is_number 16#ff
isnt_status 0     '__is_number 16#ff'

__is_number 0x777
isnt_status 0     '__is_number 0x777'

__is_number 0X111
isnt_status 0     '__is_number 0X111'


exit 0

#EOF
