#! /bin/sh

. ./libtest.sh || exit 255

# prepare the tests
mkdir -p t/tmp
tmp=$(mktemp t/tmp/,XXXXX)
[ -f "$tmp" ] || exit 255

tests 1

err=$( t/data/99-exit-code-254.t >| /dev/null 2>&1 || echo $?)
is_num	${err:=0}	3		'Bug #exit-code-254'

#EOF
