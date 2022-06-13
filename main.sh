#!/bin/bash

#change dir to the home and check the project dir if exist or not 
cd 
dir=Databases
if ! [ -d $dir ]
then
        mkdir $dir 
fi

#check size of the databases directory >> check if it have directories
dir_s=`find $HOME/$dir -mindepth 1 -type d | wc -l`
export dir_s

#while loop to display the main menu
while true
do
	printf '%96s\n' | tr ' ' - # to print ------
	
	read -p "Now, you are in SQl simulation mode and these are the options:
		1) Create Database
		2) List Database
		3) Use Database 
		4) Drop Database 
		5) Exit
		Enter your choice [1 | 2 | 3 | 4 | 5]: " choice

	#main menu
	case $choice in
		"1" ) 	clear ; printf '%96s\n' | tr ' ' - ; source $HOME/ProjectScripts/create_db.sh ;;

		"2" )   if [[ $dir_s -gt 0 ]]
				then
					clear ; printf '%96s\n' | tr ' ' -  
					echo -e "These are the avilabale databases : "
					tree  $HOME/$dir/
					sleep 1
				else
					clear ; printf '%96s\n' | tr ' ' - ; echo "Oops, There are no databases to do this optoin, Please create a database first."
				fi ;;

		"3" ) 	if [[ $dir_s -gt 0 ]] ; then
					clear ; source  $HOME/ProjectScripts/use_db.sh
				else
					clear ; printf '%96s\n' | tr ' ' - ; echo "Oops, There are no databases to do this optoin, Please create a database first."
				fi ;;

		"4" ) 	if [[ $dir_s -gt 0 ]] ; then
					clear ; printf '%96s\n' | tr ' ' - ;  source $HOME/ProjectScripts/drop_db.sh
				else
					clear ; printf '%96s\n' | tr ' ' - ; echo "Oops, There are no databases to do this optoin, Please create a database first."
				fi ;;

		"5" ) 	echo "you will exit now from the simulation, thanks for your time :)" 
				printf '%96s\n' | tr ' ' - ; break ;;
				
		* ) 	echo "You entered an invalid option, Please try again." ;;

	esac
done
#to exit for the simulation
exit
