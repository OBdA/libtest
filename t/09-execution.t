set -e

# prepare the tests
mkdir -p t/tmp
tmpd=$(mktemp -d t/tmp/,XXXXX)
[ -d "$tmpd" ] || exit 255


. ./libtest.sh || exit 255

ok "-x ./libtest.sh"	"libtest.sh is executable"

err=$( ./libtest.sh --help >| $tmpd/out 2>| $tmpd/err || echo $? )
is_num	${err:-0}	0	"  'libtest.sh --help' exists successfully"

ok "-e $tmpd/err -a ! -s $tmpd/err"	"  no output on STDERR"
diag "STDERR was: $(cat $tmpd/err)"

ok "-s $tmpd/out"		"  there is output on STDOUT"
diag "$(ls -l $tmpd/out)"

## check some contents of the inline documentation

like_file $tmpd/out 'Copyright .* Olaf Ohlenmacher.*License GPL' \
	'  check copyright and license'

like_file $tmpd/out '^SYNOPSIS$' \
	'  SYNOPSIS section...found'

unlike_file $tmpd/out '^BUGS$' \
	'  No BUGS section...good!'


##	check the none test

err=$( $SHELL t/data/09-none-test.t >| $tmpd/out 2>| $tmpd/err || echo $? )
is_num	${err:-0}	0	"  'simple none test exists successfully"

ok "-e $tmpd/out -a ! -s $tmpd/out" \
	'  no output on STDOUT'
diag "STDOUT was: $(cat $tmpd/out)"

ok "-e $tmpd/out -a ! -s $tmpd/err" \
	'  no output on STDERR'
diag "STDOUT was: $(cat $tmpd/err)"


done_testing


${DEBUG:+echo} rm -rf $tmpd
exit 0

#EOF
