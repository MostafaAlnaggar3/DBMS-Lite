#!/bin/bash

#change dir to project dir
cd $HOME/Databases/

#while loop to display the create menu 
while true ;
do
	read -p "Now, you are in Database Creation Mode:
		1) Create database.
		2) Back to the main menu.
		enter choice [1 | 2]: " choice

	#create menu
	case $choice in
		"1")	#list databases : 
			if [[ $dir_s -gt 0 ]] 
			then
				clear ; printf '%96s\n' | tr ' ' - ; echo "These are the databases which already exist : "
				cd $HOME/Databases/ ; ls
			else 
				clear ; printf '%96s\n' | tr ' ' - ; echo "Welcome in creation database mode, Here you can create a new database please take care of database name rules."
			fi

			printf '%96s\n' | tr ' ' - 

			echo "Database name rules : 
			1) Name should not be null.
			2) Name should not start with . or .. or numbers.
			3) Name length should be less than 50 characters.
			4) Avoid any special characters like >< ? * # '.
			5) Names are case sensitive.
			6) Name should not contain a space. " 

			printf '%96s\n' | tr ' ' - 

			#read db_name
			read -p "Please enter a valid database name: " db_name

			#check if exit
			if [[ -d "$db_name" ]]
			then	
				#database exist > nothing to do 
				clear
				echo "Database already exist, Try again with differt name "
				printf '%96s\n' | tr ' ' - 

			else
				#database not exist > db_name validation (name spelling and length)
				if ! [[ $db_name =~ ^[a-zA-Z]+$  && (( ${#db_name} -le 50 )) ]];
				then
					#if name not valid:
					clear; printf '%96s\n' | tr ' ' - 

					echo "Invalid database name, please make sure that you enter a right name regarding these rules : 
			1) Name should not be null
			2) Name should not start with . or .. or numbers
			3) Name length should be less than 50 characters
			4) Avoid any special characters like >< ? * # '
			5) File names are case sensitive
			6) Name should not contain a space" 

					printf '%96s\n' | tr ' ' - ;

				else
					#if name valid > create dir by db_name:
					clear
					printf '%96s\n' | tr ' ' - 

					mkdir $db_name
					echo -e "( $db_name ) database created created successfully\n \tPlease make a refresh for the databases by EXIT from the simulatoin."
					
					printf '%96s\n' | tr ' ' - 
				fi
			fi		;;

		#back to the main menu
		"2")	clear ; break ; source $HOME/ProjectScripts/main.sh;;
		
		#invalid option from the menu
		 * ) 	 clear ; printf '%96s\n' | tr ' ' - ; echo "You entered an invalid option, Please try again." ; printf '%96s\n' | tr ' ' - ; ;;

	esac

done