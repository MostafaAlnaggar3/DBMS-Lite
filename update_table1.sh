#!/bin/bash
clear
printf '%96s\n' | tr ' ' -

echo "These are the tables in ( $db_name ) database which you can update data in one of them : "
cd $HOME/Databases/$db_name/ ; ls

printf '%96s\n' | tr ' ' -
#read table_name
read -p "Please enter table name which you want to update data in it: " table_name
clear

if [[ -f "$table_name" ]]
then
file_size=`wc -l < $HOME/Databases/$db_name/$table_name`
	while true ;
	do
		if [[ $file_size -gt 3 ]]
		then
		printf '%96s\n' | tr ' ' -
			read -p "Now, you are in update mode:
		1) Updata value in the table.
		2) Back to the use menu.
		enter choice [1 | 2]: " choice

			#create menu
			case $choice in
				"1") 	export table_name ; clear ; source $HOME/ProjectScripts/update_table2.sh ;;
				#back to the main menu
				"2")	clear ; break ; source $HOME/ProjectScripts/use_db.sh ;;
				#unvalid option from the menu
				* ) 	clear ; echo "Error: You entered an incorrect choice, Please try again."  ;;

			esac
		else
			echo "This table ( $table_name ) does not have data to update."
			break
		fi
	done
else
	echo "Error: ( $table_name ) Table does not exist, please make sure that you enter a correct name."
	echo -e "\n \t \t \t \t \t \t******************************************"
	sleep 1
fi