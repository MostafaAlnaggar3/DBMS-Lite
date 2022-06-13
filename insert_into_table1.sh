#!/bin/bash

#change dir to project dir
cd $HOME/Databases/$db_name/

#while loop to display the create menu 
while true ;
do
	printf '%96s\n' | tr ' ' -
	read -p "Now, you are in table insertion mode:
		1) Insert into table.
		2) Back to the use menu.
		enter choice [1 | 2]: " choice

	#create menu
	case $choice in
		"1") #list tables : 
			clear ; echo "These are the tables in ( $db_name ) database which you can insert into one of them : "
			cd $HOME/Databases/$db_name/ ; ls
			printf '%96s\n' | tr ' ' -
			#read table_name
			read -p "Please enter table name you want to insert data into it: " table_name

			#check if exit
			if [[ -f "$table_name" ]]
			then	
				#Table exist > insert into 
				export table_name
				clear ; source $HOME/ProjectScripts/insert_into_table2.sh
				
			else
				clear
				echo "( $table_name ) table does not exist please make sure that you enter a right table name"
			fi		;;

		#back to the main menu
		"2")	clear ; break ; source $HOME/ProjectScripts/use_db.sh ;;
		#unvalid option from the menu
		 * ) 	clear ; echo "You entered an incorrect option, Please try again." ;;

	esac

done
