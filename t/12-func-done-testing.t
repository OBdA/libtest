set -e

# prepare the tests
mkdir -p t/tmp
tmpd=$(mktemp -d t/tmp/,XXXXX)
[ -d "$tmpd" ] || exit 255


. ./libtest.sh || exit 255

# use done_testing(), instead of tests() -- see at the end!

func_ok	done_testing						'function done_testing()'


## no tests(), no done_testing() was run
err=$( $SHELL t/data/12-nothing.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:=0}	0	't/data/12-nothing.t exits like expected'

# prove have to fail
err=$( prove -e "$SHELL" t/data/12-nothing.t >| $tmpd/out 2>| $tmpd/err || echo $?)
isnt_num	${err:=0}	0	't/data/12-nothing.t: prove failed on it'
like_file $tmpd/out 'No plan found in TAP output' '  proved missed plan'


## argument to done_testing is not a number
err=$( $SHELL t/data/12-no-number.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:=0}	255	't/data/12-no-number.t exits like expected'

like_file	 $tmpd/err \
	"done_testing: bla: argument is not a number" \
	'  error message is ok'


## no tests() - only done_testing()
err=$( $SHELL t/data/12-no-plan.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:=0}	0	't/data/12-no-plan.t exits like expected'

ok "! -s $tmpd/err"		'  no output on STDERR'
diag "STDERR was '$(cat $tmpd/err)'"

err=$(tail -1 $tmpd/out|grep -q '^1\.\.3$' || echo $?)
is_num	${err:=0}	0	'  plan is on last line'


## planed more than done_testing()
err=$( $SHELL t/data/12-more-planned.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:=0}	2	't/data/12-more-planned.t exits like expected'
like_file	 $tmpd/out \
	"not ok 4 - planned to run 5 but done_testing\(\) expects 3" \
	'  additional test: planned 5 expected 3'
like_file	 $tmpd/err \
	"Looks like you planned 5 tests but ran 4" \
	'  message: planned 5 ran 4\.'


## planed less than done_testing()
err=$( $SHELL t/data/12-less-planned.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:=0}	2	't/data/12-less-planned.t exits like expected'
like_file	 $tmpd/out \
	"not ok 4 - planned to run 1 but done_testing\(\) expects 3" \
	'  additional test: planned 1 expect 3'
like_file	 $tmpd/err \
	"Looks like you planned 1 tests but ran 4" \
	'  message: planned 1 run 4'


## done_testing() was called directly
err=$( $SHELL t/data/12-called-directly.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:=0}	255	't/data/12-called-directly.t bails out'
like_file	 $tmpd/out \
	"^1\.\.2" \
	'  list of tests'
like_file $tmpd/err "^# No tests run\!"		'  message: no tests run'


${DEBUG:+echo} rm -rf $tmpd
done_testing 18


#EOF
