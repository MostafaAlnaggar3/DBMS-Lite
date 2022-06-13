#!/bin/bash

IFS=': ' read -a col_type_arr <<< `sed -n '1p' $HOME/Databases/$db_name/$table_name`
IFS=': ' read -a col_name_arr <<< `sed -n '3p' $HOME/Databases/$db_name/$table_name`

col_metadata_ct=("PK" "null" "notnull" "String" "Int")
col_metadata_all=("${col_name_arr[@]}" "${col_metadata_ct[@]}")

echo -e "Name of the columns that in ( $table_name ) table you can choose one of them:\n\t`sed -n '3p' $HOME/Databases/$db_name/$table_name` "

printf '%96s\n' | tr ' ' -

read -p "Please enter column name: " col_name

if ! [[ $col_name =~ ^[a-zA-Z]+$  && (( ${#col_name} -le 50 )) ]];
then
     echo "Error: Invalid column name"
else

    #get column index
    if [[ "${col_name_arr[0]}" == "$col_name" ]]
    then
        # col_index=$(awk 'BEGIN{FS=":"}{if(NR==3){for(i=1;i<=NF;i++){if($i=="'$col_name'") print i}}}' $table_name)
        col_index=1
    else 
        col_index=$(awk 'BEGIN{FS=":"}{if(NR==3){for(i=1;i<=NF;i++){if($i==" '$col_name'") print i}}}' $table_name)
    fi
    
    #check if column exsit or not, exist > take value | not exist > error
    if [[ $col_index == "" ]]
    then
        echo "Error: ( $col_name ) does not exist"
    else
        read -p "Please enter the value of the column: " value
        
        if [ ${col_type_arr[col_index - 1]} == "String" ]
        then
            if ! [[ ${col_metadata_all[*]} =~ " ${value} " ]]
            then
                if ! [[ $value =~ ^[a-zA-Z]+$  &&  $value != "" ]]
                then
                    echo "Error: Invalid value please make sure that you entered a valid value"
                else
                    #check if value exist or not in the column
                    res=$(awk 'BEGIN{FS=":"}{if ($'$col_index'==" '$value'") print $'$col_index'}' $HOME/Databases/$db_name/$table_name)
                    if [[ $res = "" ]]
                    then
                         echo "Error: This value ($value) does not exist"
                    else
                        clear
                        #number of record that have value
                        NR=$(awk 'BEGIN{FS=":"}{if($'$col_index' == " '$value'") print NR}' $HOME/Databases/$db_name/$table_name )
                        IFS=' ' read -a nr_arr <<< `echo $NR`
                        echo "This value ( $value ) apper ${#nr_arr[@]} times :"
                        printf '%96s\n' | tr ' ' -
                        for ((i=0;i<=${#nr_arr[@]};i++))
                        do
                            n=${nr_arr[i]}
                            awk "NR==${n}" $HOME/Databases/$db_name/$table_name 2>/dev/null
                        done
                    fi
                fi
            else
                echo "Error: invalid value "
            fi

        elif [ ${col_type_arr[col_index - 1]} == "Int" ]
        then
            if ! [[ $value =~ ^[0-9]+$ && $value != "" ]]
            then
                echo "Error: Invalid input please make sure that you entered a right value"
            else

                #check if value exist or not in the column
                if [[ "${col_name_arr[0]}" == "$col_name" ]]
                then
                    res=$(awk 'BEGIN{FS=":"}{if ($'$col_index'=="'$value'") print $'$col_index'}' $HOME/Databases/$db_name/$table_name)
                else 
                    res=$(awk 'BEGIN{FS=":"}{if ($'$col_index'==" '$value'") print $'$col_index'}' $HOME/Databases/$db_name/$table_name)
                fi
                if [[ $res = "" ]]
                then
                        echo "Error: This value ($value) does not exist"
                else
                    clear
                    #number of record that have value
                    if [[ "${col_name_arr[0]}" == "$col_name" ]]
                    then
                        NR=$(awk 'BEGIN{FS=":"}{if($'$col_index' == "'$value'") print NR}' $HOME/Databases/$db_name/$table_name )
                    else 
                        NR=$(awk 'BEGIN{FS=":"}{if($'$col_index' == " '$value'") print NR}' $HOME/Databases/$db_name/$table_name )
                    fi
                    IFS=' ' read -a nr_arr <<< `echo $NR`
                    echo "This value apper ${#nr_arr[@]} times:"
                    printf '%96s\n' | tr ' ' -
                    for ((i=0;i<=${#nr_arr[@]};i++))
                    do
                        n=${nr_arr[i]}
                        awk "NR==${n}" $HOME/Databases/$db_name/$table_name 2>/dev/null
                    done
                    
                fi
            fi
        fi
    
    fi
fi