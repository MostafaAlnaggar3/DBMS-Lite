#!/bin/bash

col_metadata_all=("PK" "null" "notnull" "String" "Int")

#arrays for store metadata
col_name_arr=()
col_type_arr=()
col_cons_arr=()

#check -n
echo "Now you will enter the meta data of the table which you want to create please make sure that you are following the rules:
    1) The first column will be the [ PK ] which is (Not null , unique and integer) make sure that you will enter the right PK in this column.
    2) Make sure that you enter a valid colunms name and choose a valid option of data type and constraint.
    3) If you enter invalid data you will break from the creation mode."
printf '%96s\n' | tr ' ' -

#loop to take the metadata from the user 
for ((i=1; i<=col_number; i++))
do
    #read column name :   
    read -p "Enter name of the column ( $i ):" column_name

    #invalid > nothing to do 
    if ! [[ $column_name =~ ^[a-zA-Z]+$  && (( ${#column_name} -le 50 )) ]];
    then 
        clear
        #column name validation 
        echo "Error: invalid column name, please make sure that you enter a valid name regarding these rules : 
                1) Name should not be null
                2) Name should not start with . or ..
                3) Name length should be less than 50 characters
                4) Avoid special characters as >< ? * # '
                5) File names are case sensitive
                6) Name can not contain a space
                7) Name can not use a reserved word ("PK" "null" "notnull" "String" "Int") " 
        break

    #valid >store name in the array of the names> ask for column data type
    else
        if ! [[ ${col_metadata_all[@]} =~ (^|[[:space:]])"$column_name"($|[[:space:]]) ]] 
        then
            
            if ! [[ ${col_name_arr[@]} =~ $column_name ]] 
            then
                #store column name 
                #add PK info in the first column 
                if (( i == 1 ))
                then
                    col_name_arr+=(" $column_name:") 
                    col_type_arr+=(" Int:")
                    col_cons_arr+=(" PK:")

                else (( i != 1))
                    col_name_arr+=( "$column_name:" )

                    #available data type
                    read -p "Choose the Data Type of the ( $column_name ):
                                1) Int.
                                2) String. : " column_type    

                    #vaild choice > store data type in the array of the data type
                    case $column_type in 
                        "1" ) col_type_arr+=("Int:") ;;
                        "2" ) col_type_arr+=("String:") ;;
                        * ) clear ; echo "Error: please choose a valid data type." 
                            break ;;
                    esac 

                    #available constrain
                    read -p "Choose the Constraint Type of the ( $column_name ):
                                1) Null.
                                2) Not null. : " column_cons    

                    #vaild choice > store constraint in the array of the constraint
                    case $column_cons in 
                        "1" ) col_cons_arr+=("null:") ;;
                        "2" ) col_cons_arr+=("notnull:") ;;
                        * ) clear ; echo "Error: please choose a constraint type. " 
                            break ;;
                    esac
                fi
            else
                clear
                echo "Error: invalid column name."
                break
            fi    
        else
                clear
                echo "Error: invalid column name."
                break
        fi
    fi
done

#check if size of the array equal to the column number to make the file and append the meta data in it 
if [[ $col_number -eq ${#col_cons_arr[@]} ]]
then
    #valid > make a new file
    touch $table_name

    #append meta data in the table file 
    echo ${col_type_arr[@]} >> $table_name
    echo ${col_cons_arr[@]} >> $table_name
    echo ${col_name_arr[@]} >> $table_name
    clear
    echo "( $table_name ) table created successfully and this is the metadata which you entered: "
    cat $table_name
    printf '%96s\n' | tr ' ' -

else
    printf '%96s\n' | tr ' ' -
    #invalid > break and go back to the creation menu
    echo "Error: Create proccess failed"
fi