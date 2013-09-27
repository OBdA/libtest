BUGS
====



+ missing message: planned x tests, but ran only y, with y<<x:: 

  8<--------------------------
  . ./libtest.sh || exit 255
  test 5
  ok "1 -eq 1"            'test ok'
  done_testing
  8<--------------------------
  prints:
  ok 1 - test ok 
  1..1


MAIN
====

+ remove TODO in t/11
+ remove TODO in t/12

  
+ update Changelog and release 1.4
  

NEXT
====

+ use ResT for complete documentation

  - README.rst
  - remove inline documentation
  - create man page?
  - make README.rst link to libtest.rst


#EOF
