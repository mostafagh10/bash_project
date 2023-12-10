#!/usr/bin/bash

shopt -s extglob
typeset -i flag=0
typeset -i bool=0

is_valid_db_name() {
while [ $bool -eq 0 ]
do
read -p "Please enter the name of the database: " dbname
if [ ! -d $dbname ]
then
case $dbname in
+([0-9])[a-zA-Z]*)
echo "Invalid name for a database. Please enter another name."
;;
+([a-zA-Z])[a-zA-Z0-9_]*)
mkdir $dbname
flag=1
bool=1
;;
*)
echo "Invalid name for a database. Please enter another name."
;;
esac
else
echo "Database already exists. Please enter another name."
fi
done
}

while [ $flag -eq 0 ]
do
is_valid_db_name
done
cd ../
