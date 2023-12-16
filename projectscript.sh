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
	select choice in createDB listDB dropDB connectDB exit
	do
	case $choice in
        createDB)
	find ~/bash_project -name createdb.sh 2>/dev/null | while read -r file; do cp "$file" .; done
	cd ./DB 2>/dev/null
	source ../createdb.sh
	echo "(1)=>createDB   (2)=>listDB   (3)=>dropBD    (4)=>connectDB   (5)=>exit"
	;;
	listDB)
	cd $PWD/DB/
	echo `ls -F|grep '/'`
	cd ../
	echo "(1)=>createDB   (2)=>listDB   (3)=>dropBD    (4)=>connectDB   (5)=>exit"
	;;
	dropDB)
		ls DB
		read -p "Enter the name of the database that you want to delete: " db
		db=$(echo "$db" | sed 's/ /_/g')
		path=$PWD/DB/$db
		echo $path
		if [ -d "$path" ]
		then
		rm -r "$path"
		echo "Database '$db' deleted successfully."
		else
		echo "Invalid name. Please enter the correct name."
		fi
		echo "(1)=>createDB   (2)=>listDB   (3)=>dropDB    (4)=>connectDB   (5)=>exit"
	;; 
	connectDB)
	ls DB
	read -p "Enter the name of database that you want to connect: " db
	db=$(echo "$db" | sed 's/ /_/g')
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
	 echo "(1)=>createtable   (2)=>listtables    (3)=>dropTable     (4)=>insertTable"
         echo "(5)=>selectTable   (6)=>deleteTable   (7)=>updateTable   (8)=>exit "
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
	 echo "(1)=>createtable   (2)=>listtables    (3)=>dropTable     (4)=>insertTable"
         echo "(5)=>selectTable   (6)=>deleteTable   (7)=>updateTable   (8)=>exit "
	 ;;
	 #---------------------------------------------------------------------------------------------------
	 dropTable)
	 for var in `ls -F $PWD`
	 do
	 if [[ ${var} != *".metadata" ]]
	 then
	 echo $var
	 fi
	 done
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
	 echo "(1)=>createtable   (2)=>listtables    (3)=>dropTable     (4)=>insertTable"
         echo "(5)=>selectTable   (6)=>deleteTable   (7)=>updateTable   (8)=>exit "
	 ;;
	 #-------------------------------------------------------------------------------------------------
	 insertTable)
	 cd ../../
	 find ~/bash_project -name insert.sh 2>/dev/null | while read -r file; do cp 		"$file" $PWD/; done
	 source $PWD/insert.sh
	 echo "(1)=>createtable   (2)=>listtables    (3)=>dropTable     (4)=>insertTable"
         echo "(5)=>selectTable   (6)=>deleteTable   (7)=>updateTable   (8)=>exit "
	 ;;
	 selectTable)
	 cd ../../
	 find ~/bash_project -name select.sh 2>/dev/null | while read -r file; do cp 		"$file" $PWD/; done
	 source $PWD/select.sh
	 ;;
	 deleteTable)
	 cd ../../
	 find ~/bash_project -name delete.sh 2>/dev/null | while read -r file; do cp 		"$file" $PWD/; done
	 source $PWD/delete.sh
	 echo "(1)=>createtable   (2)=>listtables    (3)=>dropTable     (4)=>insertTable"
         echo "(5)=>selectTable   (6)=>deleteTable   (7)=>updateTable   (8)=>exit "
	 ;;
	 updateTable)
	 cd ../../
	 find ~/bash_project -name update.sh 2>/dev/null | while read -r file; do cp 		"$file" $PWD/; done
	 source $PWD/update.sh
	 echo "(1)=>createtable   (2)=>listtables    (3)=>dropTable     (4)=>insertTable"
         echo "(5)=>selectTable   (6)=>deleteTable   (7)=>updateTable   (8)=>exit "
	 ;;
	 exit)
	 cd ../../
	 echo "back to first menu  (1)=>createDB   (2)=>listDB     (3)=>dropDB      (4)=>connectDB     (5)=>exit"
	 break
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
