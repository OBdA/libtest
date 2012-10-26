#! /bin/sh

# prepare the tests
mkdir -p t/tmp
tmpd=$(mktemp -d t/tmp/,XXXXX)
[ -d "$tmpd" ] || exit 255


. ./libtest.sh || exit 255

tests 9

func_ok	tests						'tests()'
BAIL_OUT "tests() not defined"


err=$( t/data/11-no-plan.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:-0}	0				'No tests() planned'
like_file $tmpd/err	"# Tests were run but no plan was declared" \
	'  message'

err=$( t/data/11-not-enough.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:-0}	0				'not enough tests() planned'
like_file $tmpd/err	"# Looks like you planned 1 tests but ran 2\." \
	'  message'

err=$( t/data/11-too-many.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:-0}	0				'too many tests() planned'
like_file $tmpd/err	"# Looks like you planned 5 tests but ran 2\." \
	'  message'

err=$( t/data/11-ok.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:-0}	0				'tests() correctly planned'
unlike_file $tmpd/out	"^#" \
	'  message'


rm -rf $tmpd
exit 0

#EOF
