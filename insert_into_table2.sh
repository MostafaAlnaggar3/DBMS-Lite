#!/bin/bash 

#store metadata in arraies
IFS=': ' read -a col_type_arr <<< `sed -n '1p' $HOME/Databases/$db_name/$table_name`
IFS=': ' read -a col_cons_arr <<< `sed -n '2p' $HOME/Databases/$db_name/$table_name`
IFS=': ' read -a col_name_arr <<< `sed -n '3p' $HOME/Databases/$db_name/$table_name`

#check datatype
for ((i=0;i<${#col_type_arr[@]};i++))
do
	if [[ ${col_type_arr[i]} == "Int" || ${col_type_arr[i]} == "String" ]]
	then 
		col_typecheck1_arr+=("valid")
	else
		col_typecheck1_arr+=("invalid")
fi
done

#check constraint
for ((z=0;z<${#col_cons_arr[@]};z++))
do
	if [[ ${col_cons_arr[z]} == "PK" || ${col_cons_arr[z]} == "null" || ${col_cons_arr[z]} == "notnull" ]]
	then 
		col_typecheck2_arr+=("valid")
	else
		col_typecheck2_arr+=("invalid")
fi
done

#check if 3 first lines is null or not 
if ! [[ ${#col_type_arr[@]} -eq 0 || ${#col_cons_arr[@]} -eq 0 || ${#col_name_arr[@]} -eq 0 ]]
then
    #check size of the arraies that have metadata
    if  [ ${#col_name_arr[@]} -eq ${#col_cons_arr[@]} ] && [ ${#col_type_arr[@]} -eq ${#col_name_arr[@]} ]
    then
        #check if type check arraies are valid
        if [[ ${col_typecheck1_arr[@]}  =~ "invalid" || ${col_typecheck2_arr[@]} =~ "invalid" ]]
        then
           echo "This table ( $table_name ) is not valid for insertion process because there is a problem in metadata."
        else
             clear ; source $HOME/ProjectScripts/insert_into_table3.sh
        fi

    else
        echo "This table ( $table_name ) is not valid for insertion process because there is a problem in metadata."
    fi
    
else
     echo "This table ( $table_name ) is not valid for insertion because process there is a problem in metadata."
fi