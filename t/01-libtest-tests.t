#! /bin/sh

# prepare the tests
mkdir -p t/tmp
tmpd=$(mktemp -d t/tmp/,XXXXX)
[ -d "$tmpd" ] || exit 255


. ./libtest.sh || exit 255

tests 9

func_ok	tests						'tests()'
BAIL_OUT "tests() not defined"


( t/data/tests_no-plan.t )	> $tmpd/out 2> $tmpd/err
is_status 0				'No tests() planned'
like_file $tmpd/err	"# Tests were run but no plan was declared" \
	'  message'

( t/data/tests_not-enough.t )	> $tmpd/out 2> $tmpd/err
is_status 0				'not enough tests() planned'
like_file $tmpd/out	"# Looks like you planned 1 tests but ran 2\." \
	'  message'

( t/data/tests_too-many.t )	> $tmpd/out 2> $tmpd/err
is_status 0				'too many tests() planned'
like_file $tmpd/out	"# Looks like you planned 5 tests but ran 2\." \
	'  message'

( t/data/tests_ok.t )	> $tmpd/out 2> $tmpd/err
is_status 0				'tests() correctly planned'
unlike_file $tmpd/out	"^#" \
	'  message'


rm -rf $tmpd
exit 0

#EOF
