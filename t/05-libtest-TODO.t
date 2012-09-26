#! /bin/sh

. ./libtest.sh || exit 255


##
## BEGIN
##

# prepare the tests
mkdir -p t/tmp
tmp=$(mktemp t/tmp/,nok.XXXXX)
[ -f "$tmp" ] || exit 255


## run the tests

tests 5

( t/data/TODO.t ) > $tmp 2>&1
is_status	1		'TODO.t has only one really failed test'


like_file	$tmp	"^ok.*test ok # TODO produce success output" \
					'TODO comment success'

like_file	$tmp	"^not ok.*failed test # TODO produce failed output" \
					'TODO comment failed'

like_file	$tmp	"^# +Failed \(TODO\) test 'failed test'" \
					'  Failed description'

# check for correct file information, aka:
#   Failed (TODO) test 'failed test'
#   in t/data/TODO.t
cat $tmp \
| grep -E -A 1 		"^# +Failed \(TODO\) test 'failed test'" \
| grep -q 'at t/data/TODO\.t'
is_status	0		'  Failed description with file info'


rm -f $tmp

#EOF
