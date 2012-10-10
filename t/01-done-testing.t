#! /bin/sh

# prepare the tests
mkdir -p t/tmp
tmpd=$(mktemp -d t/tmp/,XXXXX)
[ -d "$tmpd" ] || exit 255


. ./libtest.sh || exit 255

# use done_testing(), instead of tests() -- see at the end!

func_ok	done_testing						'function done_testing()'


## no tests(), no done_testing() was run
err=$( t/data/11-nothing.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:=0}	0	't/data/11-nothing.t exits like expected'

like_file	$tmpd/err \
	'# Tests were run but no plan was declared and done_testing\(\) was not seen.' \
	'  error message on STDERR'
diag "STDERR was '$(cat $tmpd/err)'"


## argument to done_testing is not a number
err=$( t/data/11-no-number.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:=0}	255	't/data/11-no-number.t exits like expected'

like_file	 $tmpd/err \
	"done_testing: bla: argument is not a number" \
	'  error message is ok'


## no tests() - only done_testing()
err=$( t/data/11-no-plan.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:=0}	0	't/data/11-no-plan.t exits like expected'

ok "! -s $tmpd/err"		'  no output on STDERR'
diag "STDERR was '$(cat $tmpd/err)'"

err=$(tail -1 $tmpd/out|grep -q '^1\.\.3$' || echo $?)
is_num	${err:=0}	0	'  plan is on last line'


## planed more than done_testing()
err=$( t/data/11-more-planned.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:=0}	2	't/data/11-more-planned.t exits like expected'
like_file	 $tmpd/out \
	"not ok 4 - planned to run 5 but done_testing\(\) expects 3" \
	'  ok message'
like_file	 $tmpd/err \
	"Failed test 'planned to run 5 but done_testing\(\) expects 3'" \
	'  error message'


## planed less than done_testing()
err=$( t/data/11-less-planned.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:=0}	2	't/data/11-less-planned.t exits like expected'
like_file	 $tmpd/out \
	"not ok 4 - planned to run 1 but done_testing\(\) expects 3" \
	'  ok message'
like_file	 $tmpd/err \
	"Failed test 'planned to run 1 but done_testing\(\) expects 3'" \
	'  error message'


## done_testing() was called twice
err=$( t/data/11-called-twice.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:=0}	2	't/data/11-called-twice.t exits like expected'
diag  "failed extra test 'called twice'" \
	"\nfailed extra test 'planned ... but done_testing expects'"

like_file	 $tmpd/out \
	"not ok .* - done_testing\(\) was already called" \
	'  extra failed test'
like_file	 $tmpd/out \
	"^1\.\.1$" \
	'  first done_testing\(\) set the plan'
like_file	 $tmpd/err \
	"Looks like you planned 1 tests but ran 5\." \
	'  first plan - till the end'
diag "There are two failed extra tests"


done_testing


rm -rf $tmpd
exit 0

#EOF
