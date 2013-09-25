BUGS
====

+ test for func_ok() fails
  zsh t/33-func-func_ok.t 
  1..2
  not ok 1 - two tests must fail 
  #   Failed test 'two tests must fail'
  #   at t/33-func-func_ok.t
  #          got: '127'
  #     expected: '2'
  not ok 2 - expected two tests to fail 
  #   Failed test 'expected two tests to fail'
  #   at t/33-func-func_ok.t
  #          got: '0'
  #     expected: '2'
  # Looks like you failed 2 tests of 2 run.

+ use SH_OPTION_LETTERS?
  Ist es damit möglich zsh -Cefu' zu benutzen?
  

+ check for message 'many test planned but only ran x'
8<--------------------------
. ./libtest.sh || exit 255
test 5
ok "1 -eq 1"            'test ok'
done_testing

8<--------------------------



MAIN
====

+ update Changelog and release 1.4
  

NEXT
====

+ use ResT for complete documentation

  - README.rst
  - remove inline documentation
  - create man page?
  - make README.rst link to libtest.rst


#EOF
