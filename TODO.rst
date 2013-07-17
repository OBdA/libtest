MAIN
====

+ add shell option -e to every data test script (see t/data/33-func_ok.t)
+ use $SHELL to start all data test scripts

  - add documentation::
  
    SHELL=/bin/dash prove -e "/bin/dash -Cefu" t/
  

NEXT
====

+ use ResT for complete documentation

  - README.rst
  - remove inline documentation
  - create man page?
  - make README.rst link to libtest.rst


#EOF
