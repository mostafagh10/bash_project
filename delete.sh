#!/usr/bin/bash

shopt -s extglob

cd $path

read -p "please enter the name of the table that you want to delete into: " tablename
findtable=0
	 for var in `ls -F $path` # list all the files in the provided path
	 do
	 if [[ ${var} == ${tablename} ]] #check if the table exist or not
	 then
	 ((findtable=1)) # table exist
	 #-----------------------------------------------------make select to choose the way to delete
	 echo "(1)=>DeleteAllData (2)=>DeleteRow (3)=>DeleteColumn (4)=> DeleteRangeOfCOlumns)"
	 read -p "enter the number of choice for your way to delete : " numofchoice
	 #----------------------------------------------------first choice
	 if [ $numofchoice -eq 1 ]
	 then
	 sed -i '2,$d' $tablename
	 echo "all the data in table $tablename was deleted"
	 fi
	 #-----------------------------------------------------second choice
	 if [ $numofchoice -eq 2 ]
	 then
	 read -p "enter the column name : " colname
	 #-----------------------------------------------------check if the column name exist or not
	 typeset -i flag1=0
	 flag1=$(awk -F: -v colname="$colname" '{if (NR==1) for(i=1; i<=NF; i++) if(colname==$i) print i }' "$tablename")
	 if [ $flag1 -eq 0 ]
         then
         echo "the column name not fount ... "
         fi
         if [ $flag1 -gt 0 ]
         then
         read -p "enter the value : " rowvalue
         #---------countdeletedrows to count the rows which deleted
         typeset -i countDeletedRows=0
     #save the records which is not contains the rowvalue in the colname in anotherfile called table.temp & then move the data from it to the original file
	  awk -v key="$rowvalue" -v flag1="$flag1" -v countDeletedRows="$countDeletedRows" -F: '
	{
	  found = 0;
	  if ($flag1 == key) {
	    found = 1;
	    countDeletedRows++;
	  }
	  if (found == 0) {
	    print $0 > "tablename.temp";
	  }
	}
	END {
	  print countDeletedRows,"rows was affected";  # Print the count at the end
	}' "$tablename"
         #moving the data from table.temp file to original file
         mv tablename.temp $tablename
         fi #end the if statement for flag1
         fi #end the if statement for number of choice for deleting
	 #------------------------------------------- choice number 3
	 if [ $numofchoice -eq 3 ]
	 then
		 read -p "Please enter the name of the column that you want to delete: " columnName
		 #searchcolname variable to get the position of column (first,second,....etc)
		            typeset -i searchcolname=0
		            searchcolname=$(awk -F: -v colname="$columnName" '{if (NR==1) for(i=1; i<=NF; i++) if(colname==$i) print i }' "$tablename")  #getting the column field number
		            if [ $searchcolname -eq 0 ]; then # if the column not found
		                echo "You've entered a wrong column name"
		            fi

		            if [ $searchcolname -gt 0 ]; then # the column number is gt 0 so we can proceed
		            numofcols=$(awk -F: 'NR == 1 {numofcols=NF} END {print numofcols}' "$tablename.metadata")

		      #in case we entered the column number not the last one
		      if [ $searchcolname -lt $numofcols ]
		      then
		      awk -F: -v searchcolname="$searchcolname" -v numofcols="$numofcols" '{
			  line = "";
			  for (i = 1; i <= NF; i++) {
			    if (i != searchcolname && i != numofcols) {
			      line = line $i ":";
			    }
			    if (i == numofcols && i != searchcolname) {
			     line = line $i;
			    }
			  }
			  printf "%s\n", line > "tablename.temp";
			}' "$tablename"
			
		      awk -F: -v searchcolname="$searchcolname" -v numofcols="$numofcols" '{
			  line = "";
			  for (i = 1; i <= NF; i++) {
			    if (i != searchcolname && i != numofcols) {
			      line = line $i ":";
			    }
			    if (i == numofcols && i != searchcolname) {
			     line = line $i;
			    }
			  }
			  printf "%s\n", line > "tablename.temp2";
			}' "$tablename.metadata"
		      fi
		      
		      #in case we entered the column number = last column
		      if [ $searchcolname -eq $numofcols ]
		      then
		      awk -F: -v searchcolname="$searchcolname" -v numofcols="$numofcols" '{
			  line = "";
			  for (i = 1; i < NF; i++) {
			    if (i != searchcolname && i != numofcols-1) {
			      line = line $i ":";
			    }
			    if (i == numofcols-1 && i != searchcolname) {
			     line = line $i;
			    }
			  }
			  printf "%s\n", line > "tablename.temp";
			}' "$tablename"
			
		      awk -F: -v searchcolname="$searchcolname" -v numofcols="$numofcols" '{
			  line = "";
			  for (i = 1; i < NF; i++) {
			    if (i != searchcolname && i != numofcols-1) {
			      line = line $i ":";
			    }
			    if (i == numofcols-1 && i != searchcolname) {
			     line = line $i;
			    }
			  }
			  printf "%s\n", line > "tablename.temp2";
			}' "$tablename.metadata"
		      fi     
		         
		            mv tablename.temp $tablename
		            mv tablename.temp2 $tablename.metadata
		            fi
		            
	 fi
	 
	 if [ $numofchoice -eq 4 ]
	 then
	 print "DeleteRangeOfCOlumns"
	 fi
	 
	 if [ $numofchoice -gt 4 ]
	 then
	 echo "invalid option"
	 fi
	 
	 fi
	 done
	 #the table name doesn't exist because the findtable still equal 0
	 if [ $findtable -eq 0 ]
	 then
	 echo "this table doesn't exist ..."
	 fi
