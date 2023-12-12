#!/usr/bin/bash

shopt -s extglob

cd $path

#declare an array to store the input in it.
declare -a arr1
#function to check if the provided string is valid
checkstring(){
	read -p "Enter the content of this column: " content
	case $content in
	+([a-zA-Z0-9_@[:space:]]))
	arr1[$1]=$content
	;;
	*)
	echo  "you've entered a wrong string format, please enter a correct one: "
	checkstring $1 $content 
	;;
	esac
}

#function to check if the provided number is valid
checknumber(){
	read -p "Enter the content of this column: " content
	case $content in
	+([0-9.]))
	arr1[$1]=$content
	;;
	*)
	echo  "you've entered a wrong format, please enter a number: "
	checknumber $1 $content 
	;;
	esac
}	
declare -a arr2
#function to check if the provided stringPK is valid
checkstringPK(){
	read -p "Enter the content of this column: " content
	case $content in
	+([a-zA-Z0-9_@[:space:]]))
	#awk -F: '{NR>1 && $index==$content {((flag2=1)) exit} }' $tablename	
	flag2=$(awk -F: -v col_index="$index" -v content="$content" '
	        BEGIN {
		  flag2 = 0
	        }
	        NR > 1 && $col_index == content {
		  flag2 = 1
		  exit
	        }
	        END {
		  print flag2
	        }' "$tablename")
	if [ $flag2 -eq 0 ]
	then
	arr1[$1]=$content
	else
	echo "this string should be unique, please enter another one: "
	checkstringPK $1 $content 
	fi
	;;
	*)
	echo  "you've entered a wrong string format, please enter a correct one: "
	checkstringPK $1 $content 
	;;
	esac	
}
#function to check if the provided stringPK is valid
checknumberPK(){
	read -p "Enter the content of this column: " content
	case $content in
	+([0-9.]))
	flag2=$(awk -F: -v col_index="$index" -v content="$content" '
	        BEGIN {
		  flag2 = 0
	        }
	        NR > 1 && $col_index == content {
		  flag2 = 1
		  exit
	        }
	        END {
		  print flag2
	        }' "$tablename")
	if [ $flag2 -eq 0 ]
	then
	arr1[$1]=$content
	else
	echo "this number should be unique, please enter another one: "
	checknumberPK $1 $content 
	fi
	;;
	*)
	echo  "you've entered a wrong format, please enter a number: "
	checknumberPK $1 $content 
	;;
	esac	
}


read -p "please enter the name of the table that you want to insert into: " tablename
findtable=0
	 for var in `ls -F $path` # list all the files in the provided path
	 do
	 if [[ ${var} == ${tablename} ]] #check if the table exist or not
	 then
	 ((findtable=1)) # table exist
	 
	num=1 #we use it in the loop
	numofcols=$(awk -F: 'NR == 1 {numofcols=NF} END {print numofcols}' 			"$tablename.metadata") # we get the number of cols from the table
		((numofcols+=1))
		
		while [ $num -lt $numofcols ]; do
		     columnitem=$(awk -F: -v num="$num" 'NR == 2 {print $num}' 				"$tablename.metadata")
		     # we store the value of the datatype from the 					metadata table

		    case $columnitem in
		        1)
			  index=$num-1
			  checkstring "$index"
			  ;;
		        2)
			  index=$num-1
			  checknumber "$index"
			  ;;
		        3)
		        	  index=$num-1
		        	  checkstringPK "$index"
		        	  ;; 
		        4)
		        	  index=$num-1
		        	  checknumberPK "$index"
		        	  ;;   
		        *)
			  echo "not valid"
			  ;;
		    esac

		    let num=$num+1 #increment
		done
		
	 		# Join array elements with a space separated using 				IFS=>(Internal Field Separator)
			cols_input=$(IFS=":"; echo "${arr1[*]}")
			# append the provided inputs to the table
			echo "$cols_input" >> $tablename
	
	 fi
	 done
	 #the table name doesn't exist because the findtable still equal 0
	 if [ $findtable -eq 0 ]
	 then
	 echo "this table doesn't exist ..."
	 fi
