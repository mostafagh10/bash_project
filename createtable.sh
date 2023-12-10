#!/usr/bin/bash

cd $path
shopt -s extglob

typeset -i flag=0
typeset -i bool=0
typeset -i pkselected=0

is_valid_table_name() {
while [ $bool -eq 0 ]
do
read -p "Please enter the name of the table: " tablename
if [ ! -f $tablename ]
then
case $tablename in
+([0-9])[a-zA-Z]*)
echo "Invalid name for a database. Please enter another name."
;;
+([a-zA-Z])[a-zA-Z0-9_]*)
touch $tablename
touch $tablename.metadata
echo "table created successfully:"
declare -a ele
read -p "please enter the number of columns for this table: " colnumber
for (( i=0; i < colnumber; i++ )) do
	read -p "column $i name is: " colsarray[$i]
	echo "enter the datatype of this column "$i": "
	if [ $pkselected -eq 0 ]
	then
		select choice in string int stringPK intPK
		do
		case $choice in
		string)
		ele[$i]=1
		break
		;;
		int)
		ele[$i]=2
		break
		;;
		stringPK)
		ele[$i]=3
		pkselected=1
		break
		;;
		intPK)
		ele[$i]=4
		pkselected=1
		break
		;;
		*)
		echo "invalid choice. please enter a valid option"
		;;
		esac
		done
	else
	select choice in string int
	do
		case $choice in
		string)
		ele[$i]=1
		break
		;;
		int)
		ele[$i]=2
		break
		;;
		*)
		echo "invalid choice. please enter a valid option"
		;;
		esac
		done
	fi
done

# Join array elements with a space separated using IFS=>(Internal Field Separator)
cols_line=$(IFS=":"; echo "${colsarray[*]}")
# Append the line to tablename
echo "$cols_line" >> $tablename

# Join array elements with a space
cols_line=$(IFS=":"; echo "${colsarray[*]}")
# Append the line to tablename.metadata
echo "$cols_line" >> $tablename.metadata
# Join array elements with a space
ele_line=$(IFS=":"; echo "${ele[*]}")
# Append the line to tablename.metadata
echo "$ele_line" >> $tablename.metadata


flag=1
bool=1
;;
*)
echo "Invalid name for a table. Please enter another name."
;;
esac
else
echo "table already exists. Please enter another name."
fi
done
}

while [ $flag -eq 0 ]
do
is_valid_table_name
done

