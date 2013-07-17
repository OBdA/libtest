set -e

. ./libtest.sh || exit 255

tests 6

# empty function
func_ok	''				"empty function argument (failed)"
is_status 0 			"empty: rc ok"

# non-existent function
func_ok 'non_existent'	"non existent function (failed)"
is_status 0 			"non-existent: rc ok"

# real function
new_func_def ()
{
:
}
func_ok	new_func_def	'new_func_def() defined'
is_status 0 			"real function: rc ok"


#EOF
