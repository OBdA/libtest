
file=t/data/like_file.data


. ./libtest.sh || exit 255

tests 10

func_ok	like_file		'like_file()'
func_ok	unlike_file		'unlike_file()'


like_file	$file		'^/etc'			'found config file'
like_file	$file		'gugelhupf'		'found gugelhupf'

like_file	$file		'nutella'		'nutella ist aus (failed)'
like_file	t/data/nonexistent	''		'true (failed)'


unlike_file	$file		'^\/bin'		'no file in /bin'
unlike_file	$file		'kuchen'		'kein kuchen da'

unlike_file	$file		'hosts$'		'hosts file (failed)'
unlike_file	t/data/nonexistent	'asdfg'	'true (failed)'


#EOF
