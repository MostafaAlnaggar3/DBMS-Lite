#!/bin/bash

#while loop to display the use menu 
while true ;
do
	printf '%96s\n' | tr ' ' -

	read -p "Now, you are in database use mode:
		1) Connect to a database
		2) Back to the main menu
		enter choice [1 | 2]: " choice
	
	#use menu
	case $choice in
		"1") 	#list databases : 
			clear ; echo "These are the databases you can connect to one of them : "
			cd $HOME/Databases/ 
			printf '%96s\n' | tr ' ' -
			ls
			printf '%96s\n' | tr ' ' -
			tree $HOME/Databases/
			printf '%96s\n' | tr ' ' -
	 
			#read db_name
			read -p "Enter the database name you want to use : " db_name 
			
			#check if exit (check name and make sure that is not null)
			if [ -d $HOME/Databases/$db_name/ ] && [[ $db_name != "" ]] 
			then
				#database exist > display actions menu
				cd $HOME/Databases/$db_name/
				t_s=`find $HOME/Databases/$db_name -mindepth 1 -type f | wc -l`
				echo $t_s
				export t_s
				export db_name
				clear
				
				#action loop
				while true;
				do
					printf '%96s\n' | tr ' ' -
					echo -e "Now you are in the database use menu of ( $db_name ) database, There are some rules you should know before choosing any option from the menu:
			1) You will make one process after your choice.
			2) You need to make a refresh to the database after the action you will make ( go back to [ databse use menu ] ).
			3) If you enter invalid input in any operation you will exit from it, So make sure from every input you will enter.
						-------------------------------------------"
					read -p "List of options:
			1) Create table
			2) Insert into table
			3) List all tables
			4) Select from table
			5) Update table
			6) Delete from table
			7) Drop table
			8) Back database use mode
			enter choice [1 | 2 | 3 | 4 | 5 | 6 | 7 | 8]: " option 
				
					#action menu
					case $option in 
						"1" ) 	clear ; source $HOME/ProjectScripts/create_table1.sh ;;

						"2" ) 	if [[ $t_s -gt 0 ]] ; then
									clear ; source $HOME/ProjectScripts/insert_into_table1.sh
								else
									clear ;  echo "Oops, There are no tables to do this optoin, Please create a table first." 
								fi ;;

						"3" ) 	if [[ $t_s -gt 0 ]] ; then
									clear ; echo -e "These are the tables in ( $db_name ) database : "; tree $HOME/Databases/$db_name
									sleep 1
								else
									clear ;  echo "Oops, There are no tables to do this optoin, Please create a table first." 
								fi	  ;;

						"4" ) 	if [[ $t_s -gt 0 ]] ; then
									clear ; printf '%96s\n' | tr ' ' - ; source $HOME/ProjectScripts/select_from_table1.sh
								else
									clear ;  echo "Oops, There are no tables to do this optoin, Please create a table first." 
								fi ;;
					
						"5" ) 	if [[ $t_s -gt 0 ]] ; then
									clear ; source $HOME/ProjectScripts/update_table1.sh
								else
									clear ;  echo "Oops, There are no tables to do this optoin, Please create a table first." 
								fi ;;

						"6" ) 	if [[ $t_s -gt 0 ]] ; then
									clear ; printf '%96s\n' | tr ' ' - ; source $HOME/ProjectScripts/delete_from_table1.sh
								else
									clear ;  echo "Oops, There are no tables to do this optoin, Please create a table first."
								fi ;;
						
						"7" ) 	if [[ $t_s -gt 0 ]] ; then
									clear ; source $HOME/ProjectScripts/drop_table.sh
								else
									clear ;  echo "Oops, There are no tables to do this optoin, Please create a table first." 
								fi ;;
								 
						"8" ) clear ; break ;;

						  * ) clear ; echo "You entered an incorrect option, Please try again." ;;
					esac
				done
			else 
				#database not exist
				echo "( $db_name ) database does not exist , Please enter a vaild name"
			fi ;;

		#back to the main menu
		"2")	clear ; break ; source $HOME/ProjectScripts/main.sh;;

		#unvalid option from the menu
		 * ) 	clear ; echo "You entered an invalid option, Please try again." ; printf '%96s\n' | tr ' ' - ;;
	esac
done