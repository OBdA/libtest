. ./libtest.sh || exit 255

# we use 'false' and have to disable option 'errexit'
set +e

# prepare the tests
t1 ()
{
    echo t1 ; return 0
}

t2 ()
{
    echo t2 ; return 2
}


tests 7
ok '0 -eq 0'		'null gleich null'
ok '1 != 0'			'eins gleich null'
ok '"b"la = "bl"a'	'bla gleich bla'

true
ok "$? -eq 0"		'true returns 0'

false
ok "$? != 0"		'false returns not 0'

ok '$(t1) = "t1"'	't1() has value "t1"'

t2  > /dev/null
ok "$? -eq 2"		't2() returns 2'

done_testing
#EOF
