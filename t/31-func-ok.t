
. ./libtest.sh || exit 255


# prepare the tests
mkdir -p t/tmp
tmp=$(mktemp t/tmp/,XXXXX)
[ -f "$tmp" ] || exit 255


## BEGIN

tests 3

err=$(  $SHELL t/data/31-ok.t >| $tmp 2>&1 || echo $?)
is_num	${err:-0}	0	'Tests are all successfull'

is_num $(grep '^#' $tmp|wc -l)		0   'No messages in output'
is_num $(grep '^not' $tmp|wc -l)	0   'No failed tests'

rm -rf $tmp

#EOF
