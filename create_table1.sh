#!/bin/bash

#change dir to project dir
cd $HOME/Databases/$db_name/
#while loop to display the create menu 
while true ;
do
	printf '%96s\n' | tr ' ' -
	read -p "Now, you are in Table Creation Mode:
		1) Create table.
		2) Back to the use menu.
		enter choice [1 | 2]: " choice

	#create menu
	case $choice in
		"1") #list tables : 
			if [[ $t_s -gt 0 ]]
			then
				clear ; echo "These are the tables which already exist: "
				cd $HOME/Databases/$db_name/ ; ls
				printf '%96s\n' | tr ' ' -
			else
				clear ; echo "Welcome in table creation mode, Here you can create a new table please follow the table creation rules." 
				printf '%96s\n' | tr ' ' -
			fi

			echo "Table name rules: 
			1) Name should not be null.
			2) Name should not start with . or ..
			3) Name length should be less than 50 characters.
			4) Avoid special characters as >< ? * # '.
			5) File names are case sensitive.
			6) Name can not contain a space or numbers.
Number of columns rules: 
			1) The input should be number not string or null or other things.
			2) Number should be greater than 0 and less than 16. " 
			printf '%96s\n' | tr ' ' -

			#read table_name
			read -p "Please enter table name you want to create: " table_name

			#check if exit
			if [[ -f "$table_name" ]]
			then	
				#Table exist > nothing to do 
				clear
				echo "Table already exist, Try again with differt name"
			else
				#Table does not exist > db_name validation (name spelling and length)
				if ! [[ $table_name =~ ^[a-zA-Z]+$  && (( ${#table_name} -le 50 )) ]];
				then
					#if name not valid:
					clear
			 		echo "Invalid table name, please make sure that you enter a right name regarding these rules : 
					1) Name should not be null
					2) Name should not start with . or ..
					3) Name length should be less than 50 characters
					4) Avoid special characters as >< ? * # '
					5) File names are case sensitive
					6) Name can not contain a space " 
				else
					#if name valid > ask for columns number:
                    #read number of columns
                    read -p "( $table_name ) is valid name, Now how many columns do you need in this ( $table_name ) table? " col_number

                    #number of columns validation 
                    #number invalid >
                    if ! [[ $col_number =~ ^[0-9]+$ && (( $col_number -le 15 )) && (( $col_number -gt 0 )) ]] ;
                    then
						clear
                        echo "Invalid number, please make sure that you enter a right number regarding these rules : 
                        1) The input should be number not string or null or other thing
                        2) Number should be greater than 0 and less than 16 "

                    #number valid > run table creation scrpit 2 
                    else
                        export table_name ; export col_number
                        clear ; source $HOME/ProjectScripts/create_table2.sh
                    fi    
				fi
			fi		;;

		#back to the main menu
		"2")	clear ; break ; source $HOME/ProjectScripts/use_db.sh ;;

		 * ) 	clear ; echo "You entered an invalid option, Please try again."  ;;
		

	esac

done
