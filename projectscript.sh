#!/usr/bin/bash
shopt -s extglob

#script1->check for the DB directory
flag1=0
for var in `ls -F|grep '/'`
do
if [ $var = "DB/" ]
then
	((flag1=1))
fi
done
if [ $flag1 -eq 0 ]
then
	mkdir DB
	echo "the DB Directory created"
	find / -name createdb.sh 2>/dev/null | while read -r file; do cp "$file" .; done
	cd ./DB
	source ../createdb.sh
else
	echo "show ls"
fi
