#!/bin/bash

IFS=': ' read -a col_type_arr <<< `sed -n '1p' $HOME/Databases/$db_name/$table_name`
IFS=': ' read -a col_name_arr <<< `sed -n '3p' $HOME/Databases/$db_name/$table_name`

col_metadata_ct=("PK" "null" "notnull" "String" "Int")
col_metadata_all=("${col_name_arr[@]}" "${col_metadata_ct[@]}")

file_size=`wc -l < $HOME/Databases/$db_name/$table_name`

#check this 

echo -e "Names of the columns that you can choose one of them:\n \t`sed -n '3p' $HOME/Databases/$db_name/$table_name` "

printf '%96s\n' | tr ' ' -

read -p "Please enter column name: " col_name

if ! [[ $col_name =~ ^[a-zA-Z]+$  && (( ${#col_name} -le 50 )) ]];
then
     echo "Error: Please make sure that you enter a right column name."
else
    if [[ "${col_name_arr[0]}" == "$col_name" ]]
    then
        col_index=1
    else 
        col_index=$(awk 'BEGIN{FS=":"}{if(NR==3){for(i=1;i<=NF;i++){if($i==" '$col_name'") print i}}}' $table_name)
    fi
    
    if [[ $col_index == "" ]]
    then
        echo "Error: Column name does not exist."
    else
        read -p "Please enter the value of the column: " value
        if [ ${col_type_arr[col_index - 1]} == "String" ]
        then
            if ! [[ ${col_metadata_all[*]} =~ " ${value} " ]]
            then
                if ! [[ $value =~ ^[a-zA-Z]+$  &&  $value != "" ]]
                then
                    echo "Error: Invalid value please make sure that you entered a right value"
                else
                    res=$(awk 'BEGIN{FS=":"}{if ($'$col_index'==" '$value'") print $'$col_index'}' $HOME/Databases/$db_name/$table_name)
                    if [[ $res = "" ]]
                    then
                        clear
                        echo "Error: This value ( $value ) does not exist."

                    else
                        NR=$(awk 'BEGIN{FS=":"}{if($'$col_index' == " '$value'") print NR}' $HOME/Databases/$db_name/$table_name )
                        IFS=' ' read -a line_number <<< `echo $NR`
                        printf '%96s\n' | tr ' ' -
                        
                        echo -e "This value apper ( ${#line_number[@]} ) times \n \t Number of record:( ${line_number[@]} )"
                        for ((j=4;j<=$file_size;j++))
                        do
                            for ((i=0;i<${#line_number[@]};i++))
                            do
                                if [[ $j == ${line_number[i]} ]] 
                                then
                                    echo -e "\t \t$j) `sed -n ''"$j"'p' $HOME/Databases/$db_name/$table_name`"
                                fi
                            done
                        done
                        printf '%96s\n' | tr ' ' -
                        read -p "Enter the number of record which you want to delete:"  del_value     
                        if [[ ${line_number[@]} =~ ${del_value} ]]
                        then
                            printf '%96s\n' | tr ' ' -
                            read -p "Are you sure you want to delete this record ( $del_value )? (y/n)" ans
                            if [ $ans == "y" ]
                            then
                                sed -i ''"$del_value"'d' $HOME/Databases/$db_name/$table_name
                                clear
                                echo "This record ( $del_value ) deleted successfully from this table ( $table_name )."
                            elif [ $ans == "n" ] 
                            then
                                clear
                                echo "Cancel deleting proccess from this table ( $table_name )."
                            else
                                clear		
                                echo "Error: You entered an incorrect option, Please try again."
                            fi
                        else
                            clear
                            echo "Error: Invlaid value, Please try again."
                        fi
                    fi
                fi
            else
                echo "Error: invalid value."
            fi

        elif [ "${col_type_arr[col_index - 1]}" == "Int" ]
        then
            if ! [[ $value =~ ^[0-9]+$ && $value != "" ]]
            then
                clear
                echo "Error: Invalid input please make sure that you entered a right value"
            else
                if [[ "${col_name_arr[0]}" == "$col_name" ]]
                then
                    res=$(awk 'BEGIN{FS=":"}{if ($'$col_index'=="'$value'") print $'$col_index'}' $HOME/Databases/$db_name/$table_name)
                else 
                    
                    res=$(awk 'BEGIN{FS=":"}{if ($'$col_index'==" '$value'") print $'$col_index'}' $HOME/Databases/$db_name/$table_name)
                fi
                if [[ $res = "" ]]
                then
                        echo "Error: This value ( $value ) does not exist."
                else
                    if [[ "${col_name_arr[0]}" == "$col_name" ]]
                    then
                        NR=$(awk 'BEGIN{FS=":"}{if($'$col_index' == "'$value'") print NR}' $HOME/Databases/$db_name/$table_name )
                    else 
                        NR=$(awk 'BEGIN{FS=":"}{if($'$col_index' == " '$value'") print NR}' $HOME/Databases/$db_name/$table_name )
                    fi
                    IFS=' ' read -a line_number <<< `echo $NR`
                    printf '%96s\n' | tr ' ' -
                    echo -e "This value apper ( ${#line_number[@]} ) times \n \t Number of record:( ${line_number[@]} )"
                    for ((j=4;j<=$file_size;j++))
                    do
                        for ((i=0;i<${#line_number[@]};i++))
                        do
                            if [[ $j == ${line_number[i]} ]] 
                            then
                                echo -e "\t \t$j) `sed -n ''"$j"'p' $HOME/Databases/$db_name/$table_name`"
                            fi
                        done
                    done
                    printf '%96s\n' | tr ' ' -
                    read -p "Enter the number of record which you want to delete:"  del_value     
                    if [[ ${line_number[@]} =~ ${del_value} ]]
                    then
                        printf '%96s\n' | tr ' ' -
                        read -p "Are you sure you want to delete this record ( $del_value )? (y/n)" ans
                        if [ $ans == "y" ]
                        then
                            sed -i ''"$del_value"'d' $HOME/Databases/$db_name/$table_name
                            clear
                            echo "This record ( $del_value ) deleted successfully from this table ( $table_name )."
                        elif [ $ans == "n" ] 
                        then
                            clear
                            echo "Cancel deleting proccess from this table ( $table_name )."
                        else
                            clear		
                            echo "Error: You entered an incorrect option, Please try again."
                        fi
                    else
                        clear
                        echo "Error: Invlaid value, Please try again."
                    fi
                fi
            fi
        else
            echo "Error: Invalid metadata."
        fi
    fi
fi