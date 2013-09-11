MAIN
====

+ install zsh and test against it
+ update Changelog and release 1.4

+ add test (SKIP) for checking return value of the zsh
  

NEXT
====

+ use done_testing() instead of a EXIT trap
  The zsh do not executes a 'exit' while executing a EXIT-trap.
  It exits with the original exit code.

+ use ResT for complete documentation

  - README.rst
  - remove inline documentation
  - create man page?
  - make README.rst link to libtest.rst


#EOF
