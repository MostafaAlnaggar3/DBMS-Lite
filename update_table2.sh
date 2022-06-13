#!/bin/bash

IFS=': ' read -a col_type_arr <<< `sed -n '1p' $HOME/Databases/$db_name/$table_name`
IFS=': ' read -a col_name_arr <<< `sed -n '3p' $HOME/Databases/$db_name/$table_name`


col_metadata_ct=("PK" "null" "notnull" "String" "Int")
col_metadata_all=("${col_name_arr[@]}" "${col_metadata_ct[@]}")

file_size=`wc -l < $HOME/Databases/$db_name/$table_name`

printf '%96s\n' | tr ' ' -

echo -e "Name of the columns that you can choose one of them: \n \t`sed -n '3p' $HOME/Databases/$db_name/$table_name` "

printf '%96s\n' | tr ' ' -

read -p "Please Enter a column you look forward to search with :" column_search

#check column name if exist or not >> exist > take value || not exist > error
if [[ ${col_name_arr[@]} =~ $column_search ]]
then

    #get index of the column want to search by it
    if [[ "${col_name_arr[0]}" == "$column_search" ]]
    then
        WHERE_FIELD=1
    else 
        WHERE_FIELD=$(awk 'BEGIN{FS=":"}{if(NR==3){for(i=1;i<=NF;i++){if($i==" '$column_search'") print i}}}' $table_name)
    fi

    #check if index of column >> if it haven`t a value > error || have a value > take value
    if [[ $WHERE_FIELD == "" ]]
    then
        clear
        echo -e "( $column_search ) column does not exit in ( $table_name ), Please enter a valid column name to search by it"
   
    #if column index have a value > take value which we will search by it
    else
        read -p "Please enter the value of the column YOU WANT TO SEARCH WITH WHERE CLAUSE: " value
        
        #check value is a reserved word or not >> not reserved > update proccess || reserved > error
        if ! [[  "${col_metadata_all[@]}" =~ " ${value} " ]]
        then
            #check if value exist in the column index >> not exist > error || exist > column which we will update it
            if [[ "${col_name_arr[0]}" == "$column_search" ]]
            then
                res=$(awk 'BEGIN{FS=": "}{if ($'$WHERE_FIELD'=="'$value'") print $'$WHERE_FIELD'}' $table_name)
            else 
                res=$(awk 'BEGIN{FS=":"}{if ($'$WHERE_FIELD'==" '$value'") print $'$WHERE_FIELD'}' $table_name)
            fi

            if [[ $res == "" ]]
            then
                clear
                echo "Error: This value ( $value ) does not exist in this column ( $column_search )"
            
            else
                #get number of records that have the value 
                if [[ "${col_name_arr[0]}" == "$column_search" ]]
                then
                    NR=$(awk 'BEGIN{FS=":"}{if($'$WHERE_FIELD' == "'$value'") print NR}' $HOME/Databases/$db_name/$table_name )
                else 
                    NR=$(awk 'BEGIN{FS=":"}{if($'$WHERE_FIELD' == " '$value'") print NR}' $HOME/Databases/$db_name/$table_name )
                fi
                
                #store it into an array and display them
                IFS=' ' read -a var <<< `echo $NR`            
                printf '%96s\n' | tr ' ' -
                echo -e "This value apper ( ${#var[@]} ) times \n \t Number of records:( ${var[@]} )"
                for ((j=4;j<=$file_size;j++))
                do
                    for ((i=0;i<${#var[@]};i++))
                    do
                        if [[ $j == ${var[i]} ]] 
                        then
                            echo -e "\t \t$j) `sed -n ''"$j"'p' $HOME/Databases/$db_name/$table_name`"
                        fi
                    done
                done
                printf '%96s\n' | tr ' ' -

                #get record number which we need to make an update in it 
                read -p "Enter the number of record which you want to update:"  RN 
                printf '%96s\n' | tr ' ' -

                #check if it valid or not 
                if [[ ${var[@]} =~ ${RN} ]]
                then
                    #get the column which we need to update value in it 
                    echo -e "Which column you want to update?\n \t`sed -n '3p' $HOME/Databases/$db_name/$table_name`"
                    printf '%96s\n' | tr ' ' -
                    read  UPDATED_COLUMN

                    #check if update column exist or not >> if exist > get index || not exist > error
                    if [[ "${col_name_arr[@]}" =~  (^|[[:space:]])"$UPDATED_COLUMN"($|[[:space:]]) ]]
                    # if [[ "${col_name_arr[@]}" =~ " ${UPDATED_COLUMN} " ]]
                    then 
                        if [[ "${col_name_arr[0]}" == "$UPDATED_COLUMN" ]]
                        then
                            UPDATED_INDEX=1
                        else 
                            UPDATED_INDEX=$(awk 'BEGIN{FS=":"}{if(NR==3){for(i=1;i<=NF;i++){if($i==" '$UPDATED_COLUMN'") print i}}}' $table_name)
                        fi

                        #get old value
                        OLD_VALUE=$(awk 'BEGIN{FS=":"}{if(NR=="'$RN'"){for(i=1;i<=NF;i++){if(i=="'$UPDATED_INDEX'") print $i}}}' $table_name 2>>./.error.log)

                        #get new value
                        read -p "Please enter the NEW value that you want to update in this column ( $UPDATED_COLUMN ):" NEW_VALUE

                        #check data type
                        if [ ${col_type_arr[UPDATED_INDEX -1]} == "String" ]
                        then
                            #check value >> if the value valid > update process || value is not valid > error
                            if ! [[ $NEW_VALUE =~ ^[a-zA-Z]+$ ]]
                            then
                                clear
                                echo "Error: Invalid value please make sure that you entered a right value for this column ( $UPDATED_COLUMN )"
                            else
                                if ! [[ "${col_metadata_all[@]}" =~ " ${NEW_VALUE} " ]]
                                then
                                    echo -e "Old value:$OLD_VALUE \nNew value: $NEW_VALUE"
                                    read -p "Are you sure you want to update this value ? (y/n)" answer
                                    if [ $answer == "y" ] 
                                    then
                                        sed -i -e ''"$RN"'s/'"$OLD_VALUE"'/'" $NEW_VALUE"'/' $HOME/Databases/$db_name/$table_name 
                                        clear
                                        echo "Record ( $RN ) in this table ( $table_name ) Updated successfully"
                                    elif [ $answer == "n" ] 
                                    then
                                        clear
                                        echo "Cancelled updateing record ( $RN ) in this table ( $table_name )."
                                    else		
                                        echo "Error: You entered an incorrect option, Please try again."
                                    fi
                                else
                                    clear
                                    echo "Error: Invlaid value, Please try again."
                                fi
                            fi
                    

                        elif [ ${col_type_arr[UPDATED_INDEX -1]} == "Int" ]
                        then
                            #if column is PK >> validate if exist or not
                            if [ $UPDATED_INDEX == 1 ]
                            then
                                #grep by new value
                                cut -d : -f 1 $HOME/Databases/$db_name/$table_name | grep $NEW_VALUE >/dev/null        
                                if [[ $? != 0 ]]
                                then
                                    if ! [[ $NEW_VALUE =~ ^[0-9]+$ && $NEW_VALUE != "" ]]
                                    then
                                        clear
                                        echo "Error: Invalid value please make sure that you entered a right value for this column ( $UPDATED_COLUMN )"
                                    else
                                        echo -e "Old value:$OLD_VALUE \nNew value: $NEW_VALUE"
                                        read -p  "Are you sure you want to update this value ? (y/n)" answer
                                        if [ $answer == "y" ] 
                                        then
                                            if [[ "${col_name_arr[0]}" == "$UPDATED_COLUMN" ]]
                                            then
                                                sed -i -e ''"$RN"'s/'"$OLD_VALUE"'/'"$NEW_VALUE"'/' $HOME/Databases/$db_name/$table_name 
                                            else 
                                                sed -i -e ''"$RN"'s/'"$OLD_VALUE"'/'" $NEW_VALUE"'/' $HOME/Databases/$db_name/$table_name 
                                            fi
                                            echo "Record ( $RN ) in this table ( $table_name ) Updated successfully"
                                        elif [ $answer == "n" ] 
                                        then
                                            echo "Cancelled updateing record ( $RN ) in this table ( $table_name )."
                                        else		
                                            echo "You entered an incorrect option, Please try again."
                                        fi
                                    fi
                                else
                                    clear
                                    echo "Error: This vaule is already exist please make sure that you enter a unique value in PK column"
                                fi

                            #if it int and not PK 
                            else
                                if ! [[ $NEW_VALUE =~ ^[0-9]+$ && $NEW_VALUE != "" ]]
                                then
                                    clear
                                    echo "Error: Invalid value please make sure that you entered a right value for this column ( $UPDATED_COLUMN )"
                                else
                                    echo -e "Old value:$OLD_VALUE \nNew value: $NEW_VALUE"
                                    read -p  "Are you sure you want to update this value ? (y/n)" answer
                                    if [ $answer == "y" ] 
                                    then
                                        if [[ "${col_name_arr[0]}" == "$UPDATED_COLUMN" ]]
                                        then
                                            sed -i -e ''"$RN"'s/'"$OLD_VALUE"'/'"$NEW_VALUE"'/' $HOME/Databases/$db_name/$table_name 
                                        else 
                                            sed -i -e ''"$RN"'s/'"$OLD_VALUE"'/'" $NEW_VALUE"'/' $HOME/Databases/$db_name/$table_name 
                                        fi
                                        echo "Record ( $RN ) in this table ( $table_name ) Updated successfully"
                                    elif [ $answer == "n" ] 
                                    then
                                        echo "Cancelled updateing record ( $RN ) in this table ( $table_name )."
                                    else		
                                        echo "You entered an incorrect option, Please try again."
                                    fi
                                fi
                            fi
                            
                        else
                            echo "Error: Meta data is invalid "
                        fi
                    else 
                        clear
                        echo "Error: Please make sure from column name"
                    fi
                else
                    clear
                    echo "Error: Invlaid value, Please try again."
                fi
            fi
        else
            clear
            echo "Error: Invlaid value, Please try again."
        fi
    fi

else 
    clear
    echo -e "( $column_search ) column does not exit in ( $table_name ), Please enter a valid column name to search by it"
fi