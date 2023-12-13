#!/usr/bin/bash

shopt -s extglob

cd $path

#function to check if the provided string is valid
checkstring(){
        read -p "enter the value you want to update to : " newvalue
	case $newvalue in
	+([a-zA-Z0-9_@[:space:]]))
	#make the update on the file
	sed -i "s:$1:$newvalue:g" $tablename
        echo "the string was updated"
	;;
	*)
	echo  "you've entered a wrong string format, please enter a correct one: "
	checkstring $1 
	;;
	esac
}

#function to check if the provided number is valid
checknumber(){
	read -p "enter the value you want to update to : " newvalue
	case $newvalue in
	+([0-9.]))
	#make the update on the file
	sed -i "s:$1:$newvalue:g" $tablename
        echo "the number was updated"
	;;
	*)
	echo  "you've entered a wrong format, please enter a number: "
	checknumber $1 
	;;
	esac
}	

#function to check if the provided stringPK is valid
checkstringPK(){
	read -p "enter the value you want to update to : " newvalue
	case $newvalue in
	+([a-zA-Z0-9_@[:space:]]))
	##make flag2 variable to check if the input exists or not (1 => exists) (0 => not exist)	
	flag2=$(awk -F: -v searchcolname="$2" -v newvalue="$newvalue" '
	        BEGIN {
		  flag2 = 0
	        }
	        NR > 1 && newvalue == $searchcolname {
		  flag2 = 1
		  exit
	        }
	        END {
		  print flag2
	        }' "$tablename")
	# the input not exist so it's unique
	if [ $flag2 -eq 0 ]
	then
	#make the update on the file
	sed -i "s:$1:$newvalue:g" $tablename
        echo "the string was updated"
	else
	# the flag =1 so the input exist so it's not unique
	echo "this string should be unique, please enter another one: "
	checkstringPK $1 $2 
	fi
	;;
	*)
	echo  "you've entered a wrong string format, please enter a correct one: "
	checkstringPK $1 $2 
	;;
	esac	
}

#function to check if the provided numberPK is valid
checknumberPK(){
	read -p "enter the value you want to update to : " newvalue
	case $newvalue in
	+([0-9.]))
	##make flag2 variable to check if the input exists or not (1 => exists) (0 => not exist)	
	flag2=$(awk -F: -v searchcolname="$2" -v newvalue="$newvalue" '
	        BEGIN {
		  flag2 = 0
	        }
	        NR > 1 && newvalue == $searchcolname {
		  flag2 = 1
		  exit
	        }
	        END {
		  print flag2
	        }' "$tablename")
	# the input not exist so it's unique
	if [ $flag2 -eq 0 ]
	then
	#make the update on the file
	sed -i "s:$1:$newvalue:g" $tablename
        echo "the number was updated"
	else
	# the flag =1 so the input exist so it's not unique
	echo "this number should be unique, please enter another one: "
	checknumberPK $1 $2 
	fi
	;;
	*)
	echo  "you've entered a wrong number format, please enter a correct one: "
	checknumberPK $1 $2 
	;;
	esac	
}

read -p "please enter the name of the table that you want to update into: " tablename
findtable=0
	 for var in `ls -F $path` # list all the files in the provided path
	 do
	 if [[ ${var} == ${tablename} ]] #check if the table exist or not
	 then
	 ((findtable=1)) # table exist
	 read -p "enter the column you want to update : " colname
         #searchcolname=$(awk -F: '{if (NR==1) for(i=1 ; i<=NF ; i++) if($colname==$i) print i }' $tablename)))
         typeset -i searchcolname=0
         searchcolname=$(awk -F: -v colname="$colname" '{if (NR==1) for(i=1; i<=NF; i++) if(colname==$i) print i }' "$tablename")
         if [ $searchcolname -eq 0 ]
         then
         echo "the column name not fount ... "
         fi
         if [ $searchcolname -gt 0 ]
         then
         read -p "enter the value you want you update it : " oldvalue
         #to search for the value you want to update through the col
         typeset -i searchvalue=0
         searchvalue=$(awk -F: -v searchcolname=$searchcolname -v oldvalue="$oldvalue" '{if (NR>1) if(oldvalue==$searchcolname) print NR }' "$tablename")
         if [ $searchvalue -eq 0 ]
         then
         echo "the value not fount"
         else
         
         #checkvar= to get the number of the chosen column to check its data type ( 1 => string , 2=>number , 3=>stringpk , 4=>numberpk)
         checkvar=$(awk -F: -v searchcolname=$searchcolname '{if (NR>1) print $searchcolname }' "$tablename.metadata")
         #make cases to check about the datatype of the newvalue
         case $checkvar in
		        1)
			  checkstring "$oldvalue"
			  ;;
		        2)
			  checknumber "$oldvalue"
			  ;;
		        3)
		           checkstringPK "$oldvalue" "$searchcolname"
		        	  ;; 
		        4)
		           checknumberPK "$oldvalue" "$searchcolname"
		        	  ;;   
		        *)
			  echo "not valid"
			  ;;
		    esac
         fi
         
         fi
	 
	 
	 fi
	 done
	 #the table name doesn't exist because the findtable still equal 0
	 if [ $findtable -eq 0 ]
	 then
	 echo "this table doesn't exist ..."
	 fi
