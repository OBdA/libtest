#! /bin/sh

. ./libtest.sh || exit 255

# prepare the tests
mkdir -p t/tmp
tmp=$(mktemp t/tmp/,XXXXX)
[ -f "$tmp" ] || exit 255

tests 2

( t/data/99-exit-code-254.t ) >/dev/null 2>&1
is_status	3			'Bug #exit-code-254'

( t/data/99-diag-oneliner.t ) > $tmp 2>&1
like_file $tmp '^#[[:space:]]*blubb'	'Bug #diag-onliner'

#EOF
