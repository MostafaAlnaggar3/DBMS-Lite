#!/bin/bash

#while loop to display the drop table menu 
while true;
do
	printf '%96s\n' | tr ' ' -
	read -p "Now, you are in table drop mode:
		1) Drop table
		2) Back to the use menu	
		enter choice [1 | 2]: " choice

	#drop database menu
	case $choice in 
		"1") 	#list tables : 
			clear ; echo "These are the tables in ( $db_name ) database you can delete one from it : " ; ls 
			printf '%96s\n' | tr ' ' -

			#read db_name
			read -p  "Enter the table name you want to drop  : "  table_name

			#name validation
			if ! [[ $table_name =~ ^[a-zA-Z]+$  && (( ${#table_name} -le 50 )) ]]
			then
				#invalid > do nothing
				echo "Erro: Please make sure that you enter a valid table name."
			
			#valid > remove process
			else

				#check if table exit (check name and make sure that is not null)
				if [ -f $table_name ] && [[ $table_name != "" ]] 
				then
					printf '%96s\n' | tr ' ' -
					#table exist > confirmation message for the delete process
					read -p  "Are you sure you want to drop ( $table_name ) table ? enter an answer (y/n)" answer

					#if y > delete or n > cancel
					if [ $answer == "y" ] 
					then
						rm $table_name
						clear 
						echo -e "( $table_name ) table deleted successfully."
					elif [ $answer == "n" ] 
					then
						echo "Cancelled deleting ( $table_name ) table."
					else			
						echo "Error: Incorrect answer, Please try again, Please try again by enter [y | n]."
					fi
				else
					clear

					#table not exist
					echo "Error: ( $table_name ) Table does not exist, please make sure that you enter a correct name."
					echo -e "\n \t \t \t \t \t \t******************************************"
					sleep 1
				fi 

			fi ;;

		#back to the use menu
		"2")	clear ; break ; source $HOME/ProjectScripts/use_db.sh;;

		#unvalid option from the menu
		 * ) 	clear ; echo "You entered an incorrect option, Please try again." ;;
	esac
	
done