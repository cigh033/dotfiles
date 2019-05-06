#!/bin/bash

updatelines=`eopkg lu`
updatecount=`echo $updatelines | wc -l`

if [[ $updatecount -ge 2 ]]

	then
		echo $updatecount

	elif [ "$updatelines" == "No packages to upgrade." ]

	then
		echo "0"

	else
		echo $updatecount

fi
