#! /bin/sh

. ./libtest.sh || exit 255


# prepare the tests
mkdir -p t/tmp
tmpd=$(mktemp -d t/tmp/,XXXXX)
[ -d "$tmpd" ] || exit 255


tests 2

# run test with shell option errexit
err=$( sh -e t/data/33-func_ok.t >| $tmpd/out 2>| $tmpd/err || echo $?)
is_num $err 2		"two tests must fail"

failed_expected=$(cat $tmpd/out | grep -E 'not ok.*failed' | wc -l)
is_num $failed_expected 2 "expected two tests to fail"


rm -rf $tmpd
exit 0

#EOF
