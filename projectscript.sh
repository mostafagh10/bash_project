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
	 #-------------------------------------------------------------------------------------------------
	 listTables)
	 #list the tables files only without metadata files
	 for var in `ls -F $PWD`
	 do
	 if [[ ${var} != *".metadata" ]]
	 then
	 echo $var
	 fi
	 done
	 ;;
	 #---------------------------------------------------------------------------------------------------
	 dropTable)
	 read -p "enter the table name to drop it : " dbname
	 #findtable variable to search for the table if it exists or not ( 0=> not exist) (1=> exists)
	 findtable=0
	 for var in `ls -F $PWD`
	 do
	 if [[ ${var} = ${dbname} ]]
	 then
	 ((findtable=1))
	 rm $dbname
	 rm $dbname.metadata
	 echo "the table $dbname is deleted"
	 fi
	 done
	 #the table name doesn't exist because the findtable still equal 0
	 if [ $findtable -eq 0 ]
	 then
	 echo "this name doesn't exist ..."
	 fi
	 ;;
	 #-------------------------------------------------------------------------------------------------
	 insertTable)
	 cd ../../
	 find ~/bash_project -name insert.sh 2>/dev/null | while read -r file; do cp 		"$file" $PWD/; done
	 source $PWD/insert.sh
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
