
. ./libtest.sh || exit 255

tests 10

func_ok	like		'like()'
func_ok	unlike		'unlike()'

like	''				'^$'		'match NULL string'
like	'/etc/hosts'	'^\/etc'	'file in /etc'
like	'foobarbaz'		'bar'		'bar in string'
like	'gugelhupf'		''			'NULL regexp'

like	'nixda'			'nutella'	'nutella ist aus'


unlike	'/usr/bin/grep'	'^\/bin'	'prog not in /bin'
unlike	'hefezopf'		'kuchen'	'kein kuchen da'

unlike	'/usr/bin/grep'	'\/bin\/'	'no executable'


done_testing
#EOF
