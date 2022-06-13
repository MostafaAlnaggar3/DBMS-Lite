#!/bin/bash

IFS=': ' read -a col_type_arr <<< `sed -n '1p' $HOME/Databases/$db_name/$table_name`
IFS=': ' read -a col_cons_arr <<< `sed -n '2p' $HOME/Databases/$db_name/$table_name`
IFS=': ' read -a col_name_arr <<< `sed -n '3p' $HOME/Databases/$db_name/$table_name`

col_metadata_ct=("PK" "null" "notnull" "String" "Int")
col_metadata_all=("${col_name_arr[@]}" "${col_metadata_ct[@]}")


echo -e "This is the meta data of this table ( $table_name ) :
Data type of the columns:\n \t`sed -n '1p' $HOME/Databases/$db_name/$table_name`
Constraint of the columns:\n \t`sed -n '2p' $HOME/Databases/$db_name/$table_name`
Name of the columns:\n \t`sed -n '3p' $HOME/Databases/$db_name/$table_name`
---------------------------------------------------------------------------------------------------------
Now you are in insertion mode please follow this rules to accept data from you:
\t1) PK is the first column, It should be (Not null , unique and integer).
\t2) Enter a valid value regarding the meta data which you entered before.
\t3) Be focused because if you enter an invalid value you will exit from the insertion process.
----------------------------------------------------------------------------------------------------------"

#validate PK value
echo -e "What is the value of this reocrd:\n \tColumn name: ( ${col_name_arr[0]} ), Data type: ( ${col_type_arr[0]} ) and Constraint: ( ${col_cons_arr[0]} ):" 
read pk_value

if ! [[ $pk_value =~ ^[0-9]+$ && (( $pk_value -gt 0 )) && (($pk_value != "" )) ]] 
then
    #invalid >Error nothing todo 
    clear
    echo "Error: Invalid value for this column { ${col_name_arr[0]} } please make sure that you entered a right value"
    printf '%96s\n' | tr ' ' - 

else
    #valid > check is exist or not
    cut -d : -f 1 $HOME/Databases/$db_name/$table_name | grep $pk_value >/dev/null    

    if [[ $? != 0 ]]
    then
    #PK not exist > store value of the PK and accept other values
        col_data_arr+=($pk_value": ")
        
        for (( i=1;i<${#col_name_arr[@]};i++))
        do
            #read record value
            echo -e "What is the value of this reocrd:\n \tColumn name: ( ${col_name_arr[i]} ), Data type: ( ${col_type_arr[i]} ) and Constraint: ( ${col_cons_arr[i]} ):" 
            read record_value

            #check input 
            if [ ${col_type_arr[i]} == "Int" ]
            then
                #check constraint
                if [ ${col_cons_arr[i]} == "notnull" ]
                then
                    #notnull > check value > valid (store value) > notvalid (error)
                    if ! [[ $record_value =~ ^[0-9]+$ && $record_value != "" ]]
                    then
                        clear
                        echo "Error: Invalid value for this column { ${col_name_arr[i]} } please make sure that you entered a right value"
                        printf '%96s\n' | tr ' ' -
                        break
                    else
                        col_data_arr+=($record_value": ")
                    fi

                elif [ ${col_cons_arr[i]} == "null" ]
                then
                #check if i enter a character
                    if  [[ $record_value =~ ^[0-9]+$ || $record_value = "" ]]
                    then
                        #check if the value = null or not >> null > append - || not null > append
                        if [[ $record_value == "" ]]
                        then
                            col_data_arr+=("-: ")
                        else
                            col_data_arr+=($record_value": ")
                        fi
                    else
                        clear
                        echo "Error: Invalid value for this column { ${col_name_arr[i]} } please make sure that you entered a right value"
                        printf '%96s\n' | tr ' ' - 
                        break
                    fi
                fi

            elif [ ${col_type_arr[i]} == "String" ]
            then
                if ! [[ ${col_metadata_all[*]} =~  " ${record_value} " && $record_value != "" ]]
                then
                    #check constraint
                    if [ ${col_cons_arr[i]} == "notnull" ]
                    then
                        if ! [[ $record_value =~ ^[a-zA-Z]+$  &&  $record_value != "" ]]
                        then
                            clear
                            echo "Error: Invalid value for this column { ${col_name_arr[i]} } please make sure that you entered a right value"
                            printf '%96s\n' | tr ' ' - 
                            break
                        else
                            col_data_arr+=($record_value": ")
                        fi

                    elif [ ${col_cons_arr[i]} == "null" ]
                    then
                        if  [[ $record_value =~ ^[a-zA-Z]+$ || $record_value = ""  ]]
                        then
                             if [[ $record_value == ""  ]]
                            then
                                col_data_arr+=("-: ")
                            else
                                col_data_arr+=($record_value": ")
                            fi
                        else
                            clear
                            echo "Error: Invalid value for this column { ${col_name_arr[i]} } please make sure that you entered a right value"
                            printf '%96s\n' | tr ' ' - 
                            break
                        fi
                    fi
                else
                    clear
                    echo "Error: Invalid value please make sure that you did not enter a reserved word"
                    printf '%96s\n' | tr ' ' -
                    break
                fi
            fi
        done
    else
    #PK exist > nothing to do
        clear
        echo "This value ( $pk_value ) already exit, PK column should have unique values."
        printf '%96s\n' | tr ' ' -
    fi
fi

#insert data in the table
while true ;
do
    if [[ ${#col_data_arr[@]} -eq ${#col_cons_arr[@]} ]]
    then 
        printf '%96s\n' | tr ' ' -
        echo -e "Column values:\n \t ${col_data_arr[@]}"
        read -p "Are you sure that you want to insert this column in this table ( $table_name )? [y/n]" ans
        printf '%96s\n' | tr ' ' -
        if [ $ans == "y" ]
        then
            echo ${col_data_arr[@]} >> $HOME/Databases/$db_name/$table_name
            echo "Column added successfully in ( $table_name ) table"
            break
        elif [ $ans == "n" ] 
        then
            echo "Insertion proccess canceled."
            break
        else		
            clear	
            echo "Error: You entered an incorrect option, Please try again."
        fi 
    else
        #invalid > break and go back to the creation menu
        echo "Insertion proccess failed"
        break
    fi
done