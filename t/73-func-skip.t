
. ./libtest.sh || exit 255


##
## BEGIN
##

# prepare the tests
mkdir -p t/tmp
tmp1=$(mktemp t/tmp/,nok.XXXXX)
tmp2=$(mktemp t/tmp/,nok.XXXXX)
[ -f "$tmp1" -a -f "$tmp2" ] || exit 255


## run the tests
tests 10

## check if skip condition is false

err=$( t/data/73-skip-false.t >| $tmp1 2>&1 || echo $? )
is_num ${err:=0} 2	'not skipping: two tests failed'

like_file	$tmp1	"^ok.*not skipped ok" \
					'  not skipped test is ok'
like_file	$tmp1	"^not ok.*not skipped failed" \
					'  not skipped test is failed'

like_file	$tmp1	"^ok.*test ok" \
					'  normal test is ok'
like_file	$tmp1	"^not ok.*test failed" \
					'  normal test is failed'


## check if skip condition is true

err=$( t/data/73-skip-true.t >| $tmp2 2>&1 || echo $? )
is_num ${err:=0} 1	'skipping: only one test failed'

like_file	$tmp2	"^ok 1 # skip live your life" \
					'  skipped first test'
like_file	$tmp2	"^ok 2 # skip live your life" \
					'  skipped second test'

like_file	$tmp2	"^ok 3 - test ok" \
					'  normal test is ok'
like_file	$tmp2	"^not ok 4 - test failed" \
					'  normal test is failed'

done_testing

${DEBUG:+echo DRYRUN} rm -f $tmp1 $tmp2
exit 0

#EOF
