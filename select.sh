#!/usr/bin/bash

shopt -s extglob
cd "$path"

read -p "Please enter the name of the table that you want to show its content: " tablename
findtable=0

for var in $(ls -F "$path"); do
    if [[ $var == $tablename ]]; then
        findtable=1 # Table exists
        select selectMenu in selectAll selectColumn selectRangeOfColumns selectMultipleColumns selectRecords exit; do
            case $selectMenu in
                selectAll)
                    cat "$tablename"  # printing the whole table
                    echo "(1)=>selectAll                 (2)=>selectColumn      (3)=>selectRangeOfColumns"
                    echo "(4)=>selectMultipleColumns     (5)=>selectRecords     (6)=>exit"
                    ;;
                selectColumn)
                    read -p "Please enter the name of the column that you want to show: " columnName
                    typeset -i searchcolname=0
                    searchcolname=$(awk -F: -v colname="$columnName" '{if (NR==1) for(i=1; i<=NF; i++) if(colname==$i) print i }' "$tablename")  #getting the column field number
                    if [ $searchcolname -eq 0 ]; then # if the column not found
                        echo "You've entered a wrong column name"
                    fi

                    if [ $searchcolname -gt 0 ]; then # the column number is gt 0 so we can proceed
                        cut -d: -f$searchcolname "$tablename" #printing the column
                    fi
                    echo "(1)=>selectAll                 (2)=>selectColumn      (3)=>selectRangeOfColumns"
                    echo "(4)=>selectMultipleColumns     (5)=>selectRecords     (6)=>exit"
                    ;;
                selectRangeOfColumns)
                    read -p "Please enter the name of the start column: " startcol
                    read -p "Please enter the name of the end column: " endcol
                    typeset -i start=0
                    typeset -i end=0
                    start=$(awk -F: -v colname="$startcol" '{if (NR==1) for(i=1; i<=NF; i++) if(colname==$i) print i }' "$tablename") #get the startcolumn number from the table
                    end=$(awk -F: -v colname="$endcol" '{if (NR==1) for(i=1; i<=NF; i++) if(colname==$i) print i }' "$tablename") #get the endcolumn number from the table

                    if [ $start -eq 0 -o $end -eq 0 ]; then # if column not found
                        echo "You've entered a wrong name for one/both of the columns"
                    fi

                    if [ $start -gt $end ]; then # if iam entering the column in decreasing order like this cut -d: -f5-3 table name
                        echo "Your input is in a decreasing range, and this is not valid"
                    fi

                    if [ $start -gt 0 -a $end -gt 0 ]; then
                        cut -d: -f$start-$end "$tablename"
                    fi
                    echo "(1)=>selectAll                 (2)=>selectColumn      (3)=>selectRangeOfColumns"
                    echo "(4)=>selectMultipleColumns     (5)=>selectRecords     (6)=>exit"
                    ;;
                selectMultipleColumns)
                    typeset -i columnflag=0
                    declare -a fieldNumbers #we use this array to store the column numbers
                    read -p "Please enter the name of the columns that you want to show: " cols
                    fieldNumbers=() # empty the array every time i take input
                    IFS=' ' read -ra columns_array <<< "$cols" #convert the input string into array like this id name number => [id name number] 
                    for column in "${columns_array[@]}"; do
                        columnflag=$(awk -F: -v colname="$column" '{if (NR==1) for(i=1; i<=NF; i++) if(colname==$i) print i }' "$tablename") #getting the column number
                        if [ $columnflag -eq 0 ]; then
                            echo "You've entered a wrong column name"	
                            break # if it didn't find one of the columns the loop will break
                        fi

                        fieldNumbers+=("$columnflag") #append the column array to the array   
                    done

                    if [ $columnflag -gt 0 ]; then 	
                        modifiedcols=$(IFS=,; echo "${fieldNumbers[*]}") #convert spaces to ,
                        cut -d: -f"$modifiedcols" "$tablename"
                    fi
                    echo "(1)=>selectAll                 (2)=>selectColumn      (3)=>selectRangeOfColumns"
                    echo "(4)=>selectMultipleColumns     (5)=>selectRecords     (6)=>exit"
                    ;;
                selectRecords)
                    read -p "Please enter the value that you want to search about: " value
                    awk -v key="$value" -F: '{for (i=1; i<=NF; i++) {if ($i == key) {print $0}}}' "$tablename" # if the input value found it will print the whole record
                    echo "(1)=>selectAll                 (2)=>selectColumn      (3)=>selectRangeOfColumns"
                    echo "(4)=>selectMultipleColumns     (5)=>selectRecords     (6)=>exit"
                    ;;
                    exit)
                    echo "back to second menu  (1)=>createtable   (2)=>listtables    (3)=>dropTable    (4)=>insertTable"
                    echo "(5)=>selectTable   (6)=>deleteTable   (7)=>updateTable   (8)=>exit "
                    break 
                    ;;
            esac
        done
    fi
done

# The table name doesn't exist because findtable still equals 0
if [ $findtable -eq 0 ]; then
    echo "This table doesn't exist."
fi

