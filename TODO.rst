BUGS
====

+ zsh does not remove tmp files::

  $ zsh t/data/81-use-tmpfile.t 
  1..4
  ok 1 - mktemp() run successfully 
  tmpfile=/tmp/tmp.zpxHaP9ce8
  ok 2 -   tmpfile exists and is writable
  ok 3 -   tmpfile has zero size 
  ok 4 -   tmpfile now has size greater zero
  
Remark:
ZSH expandiert __libtest_tmpfiles mit einem Leerzeichen. Das soll
eigentlich nur die einzelnen temporären Dateien voneinander trennen.
wird aber im Befehl anscheinend mit evaluiert, so dass die Datei
'/tmp/tmp.ssdsd ' nicht existiert und daher nicht gelöscht wird.


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
