set -e

# prepare the tests
mkdir -p t/tmp
tmpd=$(mktemp -d t/tmp/,XXXXX)
[ -d "$tmpd" ] || exit 255


. ./libtest.sh || exit 255

tests 12

func_ok	tests						'tests()'
BAIL_OUT "tests() not defined"

# nothing is planned, but tests are run
err=$( $SHELL t/data/11-no-plan.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:-0}	0				'Run without errors'
unlike_file $tmpd/err	"^#" \
	'  no error messages'

# planned 1, expected 2, run 3
err=$( $SHELL t/data/11-not-enough.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:-0}	1				'not enough tests() planned'
like_file $tmpd/out '^1\.\.1$' \
	'only one test planed'
like_file $tmpd/out	"^not ok.*planned to run 1 but done_testing\(\) expects 2" \
	'  additional test: planned 1 but expects 2'
like_file $tmpd/err	"# Looks like you planned 1 tests but ran 3\." \
	'  message: planned 1 but ran 3'

# planned 2 and run 2
err=$( $SHELL t/data/11-ok.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:-0}	0				'tests() correctly planned'
unlike_file $tmpd/out	"^#" \
	'  message'

# planned 5 but ran 1
err=$( $SHELL t/data/11-too-many.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:-0}	1				'too many tests() planned'
like_file $tmpd/out	"^not ok.*planned to run 5 but done_testing\(\) expects 1" \
	'  additional test: planned 5 expect 1'
like_file $tmpd/err	"# Looks like you planned 5 tests but ran 2\." \
	'  message'


${DEBUG:+echo} rm -rf $tmpd
done_testing

#EOF
