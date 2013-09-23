set -e

. ./libtest.sh || exit 255


# prepare the tests
mkdir -p t/tmp
tmpd=$(mktemp -d t/tmp/,XXXXX)
[ -d "$tmpd" ] || exit 255


tests 14

func_ok	diag					'diag()'
BAIL_OUT	'function diag() undefined'

err=$( $SHELL t/data/61-diag.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:=0}	1				'test script'

ok "-s $tmpd/out -a -s $tmpd/err"	'  output'

is_num $(cat $tmpd/out|wc -l)	3	'  lines of STDOUT'
is_num $(cat $tmpd/err|wc -l)	4	'  lines of STDERR'
is_num $(
	cat $tmpd/out $tmpd/err \
	| grep '^#'|wc -l
)	4								'  lines of messages'

like_file	$tmpd/err	'Check wheter 1 -eq 0!' \
	'Diagnostic message'

## diag() multiline suppport

err=$( $SHELL t/data/61-diag-multiline.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:=0}	2				'test script'

like_file	$tmpd/err "^# one:"		'begin unquoted multiline'
like_file	$tmpd/err "^# two:"		'second unquoted multiline'
like_file	$tmpd/err "^# three un"	'last unquoted multiline'

like_file	$tmpd/err "^# 1:"		'begin quoted multiline'
like_file	$tmpd/err "^# 2:"		'second quoted multiline'
like_file	$tmpd/err "^# 3:"		'last quoted multiline'


rm -rf $tmpd

done_testing
#EOF
