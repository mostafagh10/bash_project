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
	find ~/bash_project -name createdb.sh 2>/dev/null | while read -r file; do cp "$file" .; done
	cd ./DB 2>/dev/null
	source ../createdb.sh
	;;
	listDB)
	cd $PWD/DB/
	echo `ls -F|grep '/'`
	cd ../
	;;
	dropBD)
		read -p "Enter the name of the database that you want to delete: " db
		path=$PWD/DB/$db
		echo $path
		if [ -d "$path" ]
		then
		rm -r "$path"
		echo "Database '$db' deleted successfully."
		else
		echo "Invalid name. Please enter the correct name."
		fi
	;; 
	connectDB)
	read -p "Enter the name of database that you want to connect: " db
	path=$PWD/DB/$db
	echo $path
	if [ -d $path ]
	then
	echo "you are now in '$db'"
	cd $path
	select menu2 in createTable listTables dropTable insertTable selectTable deleteTable updateTable exit
	do
	case $menu2 in
	 createTable)
	 cd ../../
	 find ~/bash_project -name createtable.sh 2>/dev/null | while read -r file; do cp "$file" $PWD/; done
	 source $PWD/createtable.sh
	 echo "create table"
	 ;;
	 listTables)
	 echo "list Tables"
	 ;;
	 dropTable)
	 echo "drop Table"
	 ;;
	 insertTable)
	 echo "insert Table"
	 ;;
	 selectTable)
	 echo "select Table"
	 ;;
	 deleteTable)
	 echo "delete Table"
	 ;;
	 updateTable)
	 echo "update Table"
	 ;;
	 exit)
	 exit
	 ;;
	 esac
	 done
	else
	echo "this database not exist ... try again with valid name"
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
