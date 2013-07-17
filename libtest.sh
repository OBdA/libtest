#! /bin/sh
# libtest.sh
# Shell library for testing (Heavily inspired from Perl's Test::Harness)
#
#..    Copyright 2011,2012 Olaf Ohlenmacher
#..
#..    This file is part of libtest.
#..
#..    libtest is free software: you can redistribute it and/or modify
#..    it under the terms of the GNU General Public License as published by
#..    the Free Software Foundation, either version 3 of the License, or
#..    (at your option) any later version.
#..
#..    libtest is distributed in the hope that it will be useful,
#..    but WITHOUT ANY WARRANTY; without even the implied warranty of
#..    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#..    GNU General Public License for more details.
#..
#..    You should have received a copy of the GNU General Public License
#..    along with libtest.  If not, see <http://www.gnu.org/licenses/>.
#..
#..

[ 'libtest.sh' = "${0##*/}" -a '--help' = "${1:-}" ] \
	&& exec grep '^#\.\.' "$0" | sed 's/^#..//' && exit 0


#..NAME
#..    libtest.sh
#..
#..
#..SYNOPSIS
#..    ./libtest.sh --help
#..
#..    eval ". ./libtest.sh" || exit 255
#..
#..    tests	2
#..    func_ok	test_it      'function test_it()'
#..    BAIL_OUT 'function test_it() undefined -- forgot to source?'
#..
#..    test_it
#..    is_status 0           'successfull execution'
#..
#..
#..DESCRIPTION
#..    This is libtest - a framework for regression tests for
#..    POSIX-compatible shell scripts. It's heavily inspired from Perl's
#..    Test::Harness and produces (more or less) compatible output for
#..    the 'prove' command shipped with Perl.
#..
#..    To check libtest.sh would run in your environment run
#..
#..        SHELL=/bin/sh  prove --exec '/bin/sh  -Cefu' t/  # or
#..        SHELL=/bin/zsh prove --exec '/bin/zsh -CeFu' t/  # for the zsh
#..
#..    If you have not installed Perl's 'prove' command, run
#..
#..        ls t/*.t | while read i; do
#..            echo -n $i...
#..            /bin/sh -Cefu $i >/dev/null 2>&1 && echo ok || echo FAILED
#..        done
#..
#..    This should run all test scripts and report a (very) short summary
#..    of the test results.
#..
#..

__libtest_TODO=			# holds TODO message
__libtest_TODO_flag=	# is TODO block active?
__libtest_plan=-1		# holds number of planed tests
__libtest_counter=0		# holds number of run tests
__libtest_failed=0		# holds number of failed tests
__libtest_lasttest=0	# holds result of last test
__libtest_called_dt=	# bool: was done_testing() already called?
__libtest_tmpfiles=		# holds all temporary file that must be removed
__libtest_SKIP=			# holds SKIP message
__libtest_SKIP_flag=	# is SKIP block active?
export __libtest_TODO __libtest_TODO_flag __libtest_plan __libtest_counter \
	__libtest_failed __libtest_lasttest __libtest_called_dt __libtest_tmpfiles \
	__libtest_SKIP __libtest_SKIP_flag

#..FUNCTIONS
#..
#..tests( <number> )
#..  Plan your tests. This function set the number of planed tests.
#..
#..  Example:
#..    tests 2
#..    is_func func      'func ok'
#..    ok "$life -eq 42"  'the answer'
#..
#..
tests ()
{
	__libtest_plan=$1
	echo 1..$__libtest_plan

	return 0
}

#..done_testing( [number_of_tests] )
#..  If you do not know how many test you will run, you can issue the plan
#..  after running the test. 'number_of_tests' is the number of tests you
#..  expected to run, equal to tests(). You can omit this, in this case the
#..  number of run tests does not matter. They only have to pass.
#..
#..  Example:
#..    . libtest.sh || exit 255
#..    ok "-r $file"      'file is readable'
#..    ok "$life -eq 42"  'the ultimate truth'
#..    done_testing
#..
#..
done_testing ()
{
	local plan
	plan=${1:-}

	if test ${__libtest_called_dt}; then
		__nok 'done_testing() was already called'
	fi
	
	if ! __is_number "${plan:-0}"; then
		echo "done_testing: $plan: argument is not a number" 1>&2

		# remove EXIT trap
		trap - EXIT
		exit 255
	fi

	# set future plan
	plan=${plan:-$__libtest_counter}

	# check the plans differ
	if test $__libtest_plan -ge 0 ; then
		if test $plan -ne $__libtest_plan; then
			# check plan and done_testing differs
			__nok "planned to run $__libtest_plan but done_testing() expects $plan"
		fi
		return 0
	fi

	# output plan if no tests() was given
	if test $__libtest_plan -lt 0; then
		echo 1..$plan
	fi

	# set __libtest_plan
	__libtest_plan=$plan

	__libtest_called_dt=1
	return 0
}

#..pass( <description> )
#..fail( <description> )
#..  If you just want to pass or fail a test use these functions.
#..
#..  Example:
#..    command
#..    if [ complex_expression ]; then
#..        pass 'Yeah, command is a runner'
#..    else
#..        fail 'command did not run like expected'
#..    fi
#..
#..
pass ()
{
	local desc

	desc="$*"

	__ok  "$desc"

	return 0
}

fail ()
{
	local desc

	desc="$*"

	__nok "$desc"

	return 0
}

#..func_ok( <function> <description> )
#..  Checks if <function> is a shell function and defined.
#..
#..  Example:
#..    func_ok sort_numbers    'function sort_numbers()'
#..    
#..
func_ok ()
{
	local func desc

	func=$1; shift
	desc="$*"

	if type "$func" | grep -E -q "$func is a( shell)? function"; then
		__ok  "$desc"
		return 0
	fi
	__nok "$desc"
	__libtest_message "  Function '$func' is not defined."

	return 0
}

#..ok( <condition> <description> )
#..  Run test with specified condition and mark test with given description.
#..  Use BAIL_OUT() or diag() if you want to react on test results.
#..
#..  Example:
#..    ok "$(go_to_bed $time) = 'dreams'"   'have dreams while sleeping'
#..    diag "gone to sleep at $time"
#..
#..
ok ()
{
	local cond desc

	cond=$1 ; shift
	desc="$*"

	#if eval '[' "$cond" ']'		# Do not escape the quotes!
	if eval test $cond; then
		__ok  "$desc"
	else
		__nok "$desc"
	fi

	return 0
}

#..cmp_ok( <got> <op> <expect> <description> )
#..  This function allows you to compare two arguments using any binary
#..  test(1) operator. Additional to ok() there will be more information
#..  of the expected results when a test fails.
#..
#..  Example:
#..    cmp_ok "$retval" '=' 'expected string'  'expected string found'
#..
#..
cmp_ok ()
{
	local got op expected desc

	got=$1; shift
	op=$1; shift
	expected=$1; shift
	desc="$*"

	if eval '[' \"$got\" "$op" \"$expected\" ']'
	then
		__ok  "$desc"
	else
		__nok "$desc"
		__got_expected "$got" "$expected"
	fi

	return 0
}

#..is_status( <expect> <description> )
#..isnt_status( <expect> <description> )
#..  These functions test the return value of the last executed command
#..  and produce their output regarding to this value.
#..
#..  Example:
#..    is_status   '0'  'command exits succesfully'
#..    isnt_status '0'  'command failed'
#..
#..  This function is incompatible with the shell option 'errexit'. So, do
#..  not use 'errexit' in your tests scripts containing is_status().
#..
is_status ()
{
	# BASH's 'local' command overwrites variable 'got', using a "random"
	# variable reduces possibility of variable conflicts
	got_GuPbi0pK4Z=$?
	local got expected desc
	got=$got_GuPbi0pK4Z


	# check for numbers
	if ! __is_number "$1"
	then
		__nok "$3"
		__libtest_message "         got: '$1' as test value\n    expected: <number>"
		return 0
	fi

	expected=$1; shift
	desc="$*"

	if eval '[' \"$got\" '-eq' \"$expected\" ']'
	then
		__ok  "$desc"
	else
		__nok "$desc"
		__got_expected "$got" "$expected"
	fi

	return 0
}

isnt_status ()
{
	# BASH's 'local' command overwrites variable 'got', using a "random"
	# variable reduces possibility of variable conflicts
	got_GuPbi0pK4Z=$?
	local got expected desc
	got=$got_GuPbi0pK4Z


	# check for numbers
	if ! __is_number "$1"
	then
		__nok "$3"
		__libtest_message "         got: '$1' as test value\n    expected: <number>"
		return 0
	fi

	expected=$1; shift
	desc="$*"

	if eval '[' \"$got\" '-ne' \"$expected\" ']'
	then
		__ok  "$desc"
	else
		__nok "$desc"
		__got_expected "$got" __anything_else__
	fi

	return 0
}

#..is( <got> <expect> <description> )
#..isnt( <got> <expect> <description> )
#..  Similiar to ok(), is() and isnt() compare two string arguments and produce
#..  their output regarding to the results.
#..
#..  Example:
#..    is   "$retval" 'expected'  'expected string found'
#..    isnt "$retval" ''          'got some string'
#..
#..
is ()
{
	local got expected desc

	got=$1; shift
	expected=$1; shift
	desc="$*"

	if eval '[' \"$got\" '=' \"$expected\" ']'
	then
		__ok  "$desc"
	else
		__nok "$desc"
		__got_expected "$got" "$expected"
	fi

	return 0
}

isnt ()
{
	local got expected desc

	got=$1; shift
	expected=$1; shift
	desc="$*"

	if eval '[' \"$got\" '!=' \"$expected\" ']'
	then
		__ok  "$desc"
	else
		__nok "$desc"
		__got_expected "$got" __anything_else__
	fi

	return 0
}

#..is_num( <got> <expect> <description> )
#..isnt_num( <got> <expect> <description> )
#..  Similiar to is(), is_num() and isnt_num() compare two integer arguments
#..  and produce their output regarding to the results.
#..
#..  Example:
#..    is_num   "$?"   '0'  'command exits succesfully'
#..    isnt_num "$int" '42' 'got anything other than the answer'
#..
#..
is_num ()
{
	local got expected desc

	# check for numbers
	if ! __is_number "$1"
	then
		__nok "$3"
		__libtest_message "         got: '$1' as test value\n    expected: <number>"
		return 0
	elif ! __is_number "$2"
	then
		__nok "$3"
		__libtest_message "         got: '$2' as expected value\n    expected: <number>"
		return 0
	fi

	got=$1; shift
	expected=$1; shift
	desc="$*"

	if eval '[' \"$got\" '-eq' \"$expected\" ']'
	then
		__ok  "$desc"
	else
		__nok "$desc"
		__got_expected "$got" "$expected"
	fi

	return 0
}

isnt_num ()
{
	local got expected desc

	# check for numbers
	if ! __is_number "$1"
	then
		__nok "$3"
		__libtest_message "         got: '$1' as test value\n    expected: <number>"
		return 0
	elif ! __is_number "$2"
	then
		__nok "$3"
		__libtest_message "         got: '$2' as expected value\n    expected: <number>"
		return 0
	fi

	got=$1; shift
	expected=$1; shift
	desc="$*"

	if eval '[' \"$got\" '-ne' \"$expected\" ']'
	then
		__ok  "$desc"
	else
		__nok "$desc"
		__got_expected "$got" __anything_else__
	fi

	return 0
}

#..like( <got> <regexp> <description> )
#..unlike( <got> <regexp> <description> )
#..  Similiar to is() and isnt() these functions compare a string against
#..  a extended regular expression
#..
#..  Example:
#..    like   "$path" '^/'    'path is absolute'
#..    unlike "$path" '^/etc' 'file not in /etc'
#..
#..
like ()
{
	local got regexp desc

	got=$1; shift
	regexp=$1; shift
	desc="$*"

	if echo "$got" | grep -E -q "$regexp"
	then
		__ok  "$desc"
	else
		__nok "$desc"
		__libtest_message "         got: '$got'\n    expected regexp: '$regexp'"
	fi

	return 0
}

unlike ()
{
	local got regexp desc

	got=$1; shift
	regexp=$1; shift
	desc="$*"

	if ! echo "$got" | grep -E -q "$regexp"
	then
		__ok  "$desc"
	else
		__nok "$desc"
		__libtest_message "         got: '$got'\n    expected anything not matching: '$regexp'"
	fi

	return 0
}

#..like_file( <file> <regexp> <description> )
#..unlike_file( <file> <regexp> <description> )
#..  Similiar to like() and unlike() these functions compare the contents of
#..  a file against a extended regular expression.
#..
#..  Example:
#..    like_file   "$file" 'computer'    'file contains computer'
#..    unlike_file "$file" 'telephone'   'file contains no telephone'
#..
#..
like_file ()
{
	local file regexp desc

	file=$1; shift
	regexp=$1; shift
	desc="$*"

	if [ ! -r "$file" ]
	then
		__nok "$desc"
		__libtest_message "  File not readable: '$file'"
		return 0
	fi

	if grep -E -q "$regexp" "$file"
	then
		__ok "$desc"
	else
		__nok "$desc"
		__libtest_message "    File: '$file'\n  RegExp: '$regexp'"
	fi

	return 0
}

unlike_file ()
{
	local file regexp desc

	file=$1; shift
	regexp=$1; shift
	desc="$*"

	if [ ! -r "$file" ]
	then
		__nok "$desc"
		__libtest_message "  File not readable: '$file'"
		return 0
	fi

	if ! grep -E -q "$regexp" "$file"
	then
		__ok "$desc"
	else
		__nok "$desc"
		__libtest_message "            File: '$file'\n  matched RegExp: '$regexp'"
	fi

	return 0
}

#..diag( <message> )
#..  Shows message for diagnostics if last test failed. Backslash escapes
#..  can be used in <message>, see echo(1).
#..
#..  Example:
#..    ok $(go_to_bed $time) '=' "lovly dream"    'sleeping nicly'
#..    diag "Going to bed at $time\nHaving bad dreams"
#..        
#..
diag ()
{
	local what

	what="$*"

	[ $__libtest_lasttest -ne 0 ] && __libtest_message "$what"

	return 0
}

#..TODO( [description] )
#..  When <description> is set all following tests are marked as TODO and
#..  cannot fail.
#..  Use TODO without <description> to return to productive tests.
#..
#..  Example:
#..    TODO Make file holding real test data
#..    like_file t/data/testfile "real test data" 'testfile are correct'
#..    TODO
#..    ok "$prod -eq 1" 'productive test'
#..
#..  Setting the environment LIBTEST_NO_TODO to a non-empty value disables
#..  the functionality of TODO. This can be used to proof that any TODO's
#..  are open before publishing a version.
#..
#..
TODO ()
{
	__libtest_TODO="$*"
	
	if test -z "${LIBTEST_NO_TODO:-}"; then
		# set flag if TODO is activated
		__libtest_TODO_flag=
		test "$__libtest_TODO" && __libtest_TODO_flag=true
	fi

	return 0
}

#..BAIL_OUT( <reason> )
#..  This function stops further testing if the last test failed, and exit
#..  with code 255.
#..  Backslash escapes can be used in <reason> like in echo(1).
#..
#..  Example:
#..    func_ok important_function   'important_function() available'
#..    BAIL_OUT 'important_function() *must* be available'
#..
#..
BAIL_OUT ()
{
	local why

	why="$*"

	if [ "$__libtest_lasttest" -eq 0 ]
	then
		return 0
	fi

	echo "Bail out!  $why"

	# no summary message - remove trap for EXIT
	trap - EXIT
	exit 255
}

#..SKIP( <condition>, [description] )
#..  When <condition> is true set all following tests are skipped.
#..  Use SKIP_IF without any parameter to return to productive tests.
#..
#..  Example:
#..    SKIP_IF "! -r /var/log/messages"  Test only if file is readable
#..    like_file /var/log/messages "important message" 'message OK'
#..    SKIP_IF
#..    ok "$prod -eq 1" 'productive test'
#..
#..
SKIP ()
{
	local cond
	if [ $# -le 0 ]; then
		__libtest_SKIP_flag=
		return 0
	fi

	cond="$1"; shift;

	__libtest_SKIP="$*"

	# set flag if SKIP condition is true
	__libtest_SKIP_flag=
	if eval test $cond; then
		__libtest_SKIP_flag=true
	fi

	return 0
}

__skipped()
{
	# return false unless SKIP is active
	[ $__libtest_SKIP_flag ] || return 1

	__libtest_lasttest=0
	__libtest_counter=$(( $__libtest_counter + 1 ))
	echo "ok $__libtest_counter # skip $__libtest_SKIP"
	return 0
}

#..tests_failed()
#..  This function returns number of failed tests on STDOUT. If no test
#..  failed no output is produced.
#..
#..  Example:
#..    # save file when tests failed
#..    if $(tests_failed) && rm -f $tmpfile
#..
#..
tests_failed()
{
	local retval

	retval=${__libtest_failed}
	[ "$retval" -gt 254 ] && retval=254

	if test "$retval" -gt 0; then
		echo $retval
	else
		:
	fi

	return 0
}

#..libtest_mktemp()
#..  This function is a wrapper to mktemp(1) and creates a temporary
#..  file or directory which is automatically removed when the test
#..  script exists. The name of the file or directory is returned via
#..  the environment variable LIBTEST_TMP.
#..  See mktemp(1) for all available options for 'libtest_mktemp'.
#..
#..  Example:
#..    libtest_mktemp -d
#..    complex_command >| $LIBTEST_TMP/out 2>| $LIBTEST_TMP/err
#..
#..
libtest_mktemp()
{
	local err

	LIBTEST_TMP=$(command -p mktemp "$@")
	err=$?

	if test $err -eq 0; then
		__libtest_tmpfiles="$__libtest_tmpfiles $LIBTEST_TMP"
	fi

	return $err
}

##
##	Internal function
##

__reset_counter ()
{
	__libtest_plan=-1
	__libtest_counter=0
	__libtest_failed=0

	return 0
}

__set_counter ()
{
	__libtest_counter=$1

	return 0
}

__set_failed ()
{
	__libtest_failed=$1

	return 0
}

__libtest_message ()
{
	local fd out

	# put all messages to STDOUT when test successfull or when test failed
	# in a TODO block. Otherwise use STDERR for printing messages.
	if test "$__libtest_lasttest" -eq 0 -o "$__libtest_TODO_flag" ;then
		fd=1
	else
		fd=2
	fi

	echo "$*" \
	| sed -r 's/\\n/\n/g' \
	| sed  'i # ' | sed 'N; s/\n//' 1>&$fd

	return 0
}

__ok ()
{
	local desc

	desc=$1

	__skipped && return 0
	__libtest_lasttest=0
	__libtest_counter=$(( $__libtest_counter + 1 ))

	echo -n "ok $__libtest_counter - $desc "

	if [ "$__libtest_TODO_flag" ]
	then
		__libtest_message "TODO $__libtest_TODO"
	else
		echo
	fi

	return 0
}

__nok ()
{
	local desc

	desc=$1

	__skipped && return 0
	__libtest_lasttest=1
	__libtest_counter=$(( $__libtest_counter + 1 ))

	echo -n "not ok $__libtest_counter - $desc "

	if [ "$__libtest_TODO_flag" ]
	then
		__libtest_message "TODO $__libtest_TODO"
		__libtest_message "  Failed (TODO) test '$desc'"
		__libtest_message "  at $0"
	else
		__libtest_failed=$(( $__libtest_failed + 1 ))
		echo
		__libtest_message "  Failed test '$desc'"
		__libtest_message "  at $0"
	fi

	return 0
}

__got_expected ()
{
	local got expected

	got=$1
	expected=$2

	if [ "$expected" = '__anything_else__' ]
	then
		__libtest_message "         got: '$got'\n    expected: anything else"
	else
		__libtest_message "         got: '$got'\n    expected: '$expected'"
	fi

	return 0
}

__is_number ()
{
	local val

	val=$1

	if echo "$val" | grep -E -q '^[+-]?[[:digit:]]+$'
	then
		return 0
	else
		return 1
	fi
}


# __END__
# Function called by EXIT trap
#
# Print test summary and exit the test with correct exit status.
#
__END__ ()
{
	local retval

	# no test plan given
	if test "$__libtest_counter" -gt 0; then
		if [ "$__libtest_plan" -lt 0 ]
		then
			echo \# Tests were run but no plan was declared and done_testing\(\) \
				was not seen. 1>&2
		else
			if [ "$__libtest_plan" -ne "$__libtest_counter" ]
			then
				echo \# Looks like you planned $__libtest_plan tests \
					but ran $__libtest_counter. 1>&2
			fi
		fi
	fi

	# some tests failed
	if [ "$__libtest_failed" -gt 0 ]
	then
		echo \# Looks like you failed $__libtest_failed tests \
			of $__libtest_counter run. 1>&2
	fi

	# exit code equals number of failed tests, code 255 is reserved for
	# critical errors of the test script. See BAIL_OUT().
	retval=$__libtest_failed
	[ "$retval" -gt 254 ] && retval=254

	# remove all files created with libtest_mktemp()
	if test "$__libtest_tmpfiles"; then
		rm -rf $__libtest_tmpfiles
	fi

	exit $retval
}

# set EXIT trap to handle test summary and cleanup
trap __END__ 	EXIT


#..BUGS
#..    Do not use traps on EXIT!
#..    libtest.sh use this trap to calculate test results. So, do not use
#..    'trap' in your test scripts.
#..
#..AUTHOR
#..    Written by Olaf Ohlenmacher
#..
#..COPYRIGHT
#..    Copyright 2011,2012 Olaf Ohlenmacher.  License GPLv3+: GNU GPL
#..    version 3 or later <http://gnu.org/licenses/gpl.html>. This is free
#..    software: you are free to change and redistribute it. There is NO
#..    WARRANTY, to the extent permitted by law.
#..

#EOF
