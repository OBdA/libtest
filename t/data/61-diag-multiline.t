
. ./libtest.sh || exit 255


tests 2
ok "1 -eq 0"			'unquoted newlines'
diag "one: This is a multiline
two: diag message with
three unquoted newlines"

ok "1 -eq 0"			'quoted newlines'
diag '1: multiline\n2: with quoted\n3: newlines'

done_testing
#EOF
