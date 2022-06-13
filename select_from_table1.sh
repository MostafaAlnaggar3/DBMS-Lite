#!/bin/bash
#change dir to project dir
cd $HOME/Databases/$db_name/

clear ; 
echo "These are the tables in ( $db_name ) which you can select data from one of them : "
cd $HOME/Databases/$db_name/ ; ls
printf '%96s\n' | tr ' ' -

#read table_name
read -p "Please enter table name which you want to select data from it: " table_name

#check if exit
if [[ -f "$table_name" ]]
then
file_size=`wc -l < $HOME/Databases/$db_name/$table_name`
	while true ;
	do
		if [[ $file_size -gt 3 ]]
		then
			printf '%96s\n' | tr ' ' -
			read -p "Now, you are in select from ( $table_name ) table mode:
				1) Select all.
				2) Select by where.
				3) Back to use menu.
				enter choice [1 | 2 | 3]: " choice

			case $choice in
				"1") 	clear ; echo "( $table_name ) data:"
						sed -n '3,$p' "$HOME/Databases/$db_name/$table_name" ;;

				"2")  	export table_name
						clear ; source $HOME/ProjectScripts/select_from_table2.sh ;;

				"3") 	clear ; break ; source $HOME/ProjectScripts/use_db.sh ;;
				
				* ) 	clear ; echo "Error: Invalid option, Please try again." ;;
			esac
		else
			echo "( $table_name ) This table does not have data to select."
			break
		fi
	done
else
	clear
	echo -e "Error: ( $table_name ) table does not exist please make sure that you enter a valid table name."
	echo -e "\n\t \t \t \t \t \t******************************************"
	sleep 1
fi