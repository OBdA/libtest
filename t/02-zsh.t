set -e

# prepare the tests
mkdir -p t/tmp
tdir=$(mktemp -d t/tmp/,XXXXX)
[ -d "$tdir" ] || exit 255

. ./libtest.sh || exit 255

have_zsh=$(which zsh)
SKIP "-z $have_zsh"  no ZSH available

err=$( $have_zsh t/data/02-single-failure.t >| $tdir/out 2>| $tdir/err || echo $?)
is_num	${err:-0}	1		'ZSH returns correct exit code'

SKIP

done_testing 1

rm -rf $tdir
exit 0

#EOF
