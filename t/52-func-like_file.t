set -e

. ./libtest.sh || exit 255

# prepare the tests
mkdir -p t/tmp
tmpd=$(mktemp -d t/tmp/,XXXXX)
[ -d "$tmpd" ] || exit 255


tests 8

func_ok	like_file		'like_file()'
BAIL_OUT "like_file() not defined"

func_ok	unlike_file		'unlike_file()'
BAIL_OUT "unlike_file() not defined"


err=$( $SHELL t/data/52-like_file.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:=0}	4				'test script'

ok "-s $tmpd/out -a -s $tmpd/err"	'Output'

is_num $(cat $tmpd/out | wc -l)	11	'  count stdout'
is_num $(cat $tmpd/err | wc -l)	15	'  count stderr'

like_file	$tmpd/err	"File not readable: 't/data/nonexistent'" \
	'message: file not readable'

like_file	$tmpd/err	"RegExp: 'nutella'" \
	'message: regular expression'


rm -rf $tmpd
exit 0

#EOF
