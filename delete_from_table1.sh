#!/bin/bash
clear
printf '%96s\n' | tr ' ' -

echo "These are the tables in ($db_name) database which you can delete data from one of them : "
cd $HOME/Databases/$db_name/ ; ls

printf '%96s\n' | tr ' ' -
read -p "Please enter table name you which you want to delete data from it: " table_name
clear

if [[ -f "$table_name" ]]
then

file_size=`wc -l < $HOME/Databases/$db_name/$table_name`
	while true ;
	do
		printf '%96s\n' | tr ' ' -
		if [[ $file_size -gt 3 ]]
		then
			read -p "Now, you are in delete from mode:
				1) Delete all data from table.
				2) Delete from table useing where.
				3) Back to the use menu.
				enter choice [1 | 2 | 3]: " choice

			#create menu
			case $choice in
				"1") 	clear ; echo "( $table_name ) data:"
						sed -n '4,$p' "$HOME/Databases/$db_name/$table_name" 

						printf '%96s\n' | tr ' ' -
						read -p "Are you sure you want to delete all data in the tabel ( $table_name )? (y/n) " ans
						
						if [ $ans == "y" ] 
						then
							sed -i '4,$d' "$HOME/Databases/$db_name/$table_name"  
							clear ; echo "All data in this table ( $table_name ) deleted successfully"

						elif [ $ans == "n" ] 
						then
							clear ; echo "Cancelled deleting data in this table ( $table_name )."
						else			
							clear ; echo "You entered an incorrect option, Please try again."
						fi ;;

				"2")  
						export table_name
						clear ; source $HOME/ProjectScripts/delete_from_table2.sh ;;

				#back to the main menu
				"3")	clear ; break ; source $HOME/ProjectScripts/use_db.sh ;;
				#unvalid option from the menu
				* ) 	clear ; echo "You entered an incorrect option, Please try again." ;;
			esac
			
		else
			echo "This table ( $table_name ) does not have data to delete"
			break
		fi
	done
else
	echo "Error: ( $table_name ) Table does not exist, please make sure that you enter a correct name."
	echo -e "\n \t \t \t \t \t \t******************************************"
	sleep 1
fi