
. ./libtest.sh || exit 255


##
## BEGIN
##

# prepare the tests
mkdir -p t/tmp
tmpd=$(mktemp -d t/tmp/,nok.XXXXX)	|| exit 255


## run the tests

func_ok libtest_mktemp		'libtest_mktemp() exists'
BAIL_OUT 'Oh, no libtest version of mktemp available'

err=$( $SHELL t/data/81-use-tmpfile.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num	${err:-0}	0	'successfully run all tests using the tmpfile'

file=$(cat $tmpd/out |  sed -n '/^tmpfile=/ {s/tmpfile=//;p}' || :)
ok "! -e '$file'"		'tmpfile successfully deleted on test __END__'

done_testing

${DEBUG:-} || rm -rf $tmpd
#EOF
