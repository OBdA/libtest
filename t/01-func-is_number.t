set -e

. ./libtest.sh || exit 255


tests 7

func_ok __is_number		'__is_number()'
BAIL_OUT "__is_number() not defined"

# Internal functions may return an exit code != 0.
# Use an if-clause for the internal functions to ensure that the shell does
# not exit when the shell option 'errexit' is active.

if __is_number 0; then
	pass '__is_number 0'
else
	fail '__is_number 0'
fi

if __is_number 1; then
	pass '__is_number 1'
else
	fail '__is_number 1'
fi

if __is_number 655528; then
	pass '__is_number 1'
else
	fail '__is_number 1'
fi

if __is_number 16#ff; then
	fail '__is_number 16#ff'
else
	pass '__is_number 16#ff'
fi

if __is_number 0x777; then
	fail '__is_number 0x777'
else
	pass '__is_number 0x777'
fi

if __is_number 0X111; then
	fail '__is_number 0X111'
else
	pass '__is_number 0X111'
fi


done_testing

#EOF
