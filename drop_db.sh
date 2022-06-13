#!/bin/bash

#while loop to display the drop menu
while true;
do
	read -p "Now, you are in database drop mode:
		1) Drop databases.
		2) Back to the main menu.	
		enter choice [1 | 2]: " choice

	#drop database menu
	case $choice in 
		"1") 	#list databases : 
			clear ; printf '%96s\n' | tr ' ' - ; echo "These are the databases you can delete one from it: "
			cd $HOME/Databases/ ; ls 
			printf '%96s\n' | tr ' ' - ;

			#read db_name
			read -p  "Enter the Database name you want to drop : "  db_name
			printf '%96s\n' | tr ' ' - ;

			#name validation
			if ! [[ $db_name =~ ^[a-zA-Z]+$  && (( ${#db_name} -le 50 )) ]]
			then
				#invalid > do nothing
				clear
				printf '%96s\n' | tr ' ' -
				echo "Please make sure that you enter a valid name."
				printf '%96s\n' | tr ' ' - ;
			
			#valid > remove process
			else
				#check if exit (check name and make sure that is not null)
				if [ -d $db_name ] && [[ $db_name != "" ]]
				then
					#database exist > confirmation message for the delete process
					read -p  "Are you sure you want to drop ( $db_name ) database ? enter an answer (y/n)" answer
					printf '%96s\n' | tr ' ' -
					
					#if y > delete or n > cancel
					if [ $answer == "y" ] 
					then
						clear
						rm -r $db_name 
						printf '%96s\n' | tr ' ' -
						echo -e "( $db_name ) database deleted successfully."
						printf '%96s\n' | tr ' ' -

					elif [ $answer == "n" ] 
					then
						clear
						printf '%96s\n' | tr ' ' -
						echo "Cancelled deleting ( $db_name ) database."
						printf '%96s\n' | tr ' ' -

					else	
						clear		
						echo "You entered an incorrect option, Please try again by enter [y | n]."
						printf '%96s\n' | tr ' ' -
					fi
					
				else
					clear
					#database does not exist
					echo "( $db_name ) database doesn't exit."
					printf '%96s\n' | tr ' ' -
				fi
			fi
			;;

		#back to the main menu
		"2")	clear ; break ; source $HOME/ProjectScripts/main.sh;;

		#unvalid option from the menu
		* ) 	clear ; echo "You entered an invalid option, Please try again." ; printf '%96s\n' | tr ' ' - ;;
	esac
done