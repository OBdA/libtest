
. ./libtest.sh || exit 255

# prepare the tests
mkdir -p t/tmp
tmpd=$(mktemp -d t/tmp/,XXXXX)
[ -d "$tmpd" ] || exit 255


tests 8

func_ok	like		'like()'
BAIL_OUT "like() not defined"

func_ok	unlike		'unlike()'
BAIL_OUT "unlike() not defined"


err=$( $SHELL t/data/51-like.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:=0}	2					'test script'

ok "-s $tmpd/out -a -s $tmpd/err"		'Output'

is_num $(cat $tmpd/out | wc -l)	11	'  count stdout'
is_num $(cat $tmpd/err | wc -l)	9	'  count stderr'

like_file	$tmpd/err	"expected regexp: 'nutella'" \
	'expected regular expression'

like_file	$tmpd/err	"expected anything not matching:" \
	'expected anything than ...'


rm -rf $tmpd
exit 0

#EOF
