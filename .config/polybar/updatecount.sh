#!/bin/zsh

updatelines=`eopkg lu`

updatecount=`echo -E $updatelines | wc -l`

if [[ $updatecount -ge 2 ]]

	then
		echo "%{F#FFF374}$updatecount"

	elif [ "$updatelines"=="No packages to upgrade." ]

	then
		echo "ok"

	else
		echo $updatecount

fi
