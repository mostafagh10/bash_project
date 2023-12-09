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
else
	select choice in createDB listDB dropBD connectDB exit
	do
	case $choice in
        createDB)
	find / -name createdb.sh 2>/dev/null | while read -r file; do cp "$file" .; done
	cd ./DB 2>/dev/null
	source ../createdb.sh
	;;
	listDB)
	cd ./DB
	echo `ls -F|grep '/'`
	;;
	dropBD)
		read -p "Enter the name of the database that you want to delete: " db
		path=./DB/$db
		if [ -d "$path" ]
		then
		rm -r "$path"
		echo "Database '$db' deleted successfully."
		else
		echo "Invalid name. Please enter the correct name."
		fi
	;; 
	exit)
	exit
	;;
	*)
	echo "enter valid choice"	
	;;
	esac
	done
fi
