#!/bin/bash
#get all the settings
read_settings(){
	counter=0;
	while IFS=$'\t' read -r -a settings 
	do
		((counter++))
		project[$counter]=${settings[0]}
		ssh_dev[$counter]=${settings[1]}
		dir_dev[$counter]=${settings[2]}
		ssh_live[$counter]=${settings[3]}
		dir_live[$counter]=${settings[4]}
	done < gitsynch_settings
}
read_settings
#script to synch my git repos
while :
do
	reset   
	echo
	echo
	echo "	--------------------------------"
	echo "		M A I N - M E N U 	"
	echo "	--------------------------------"
	echo
	#read in all the projects
	for (( i=1; i<=${counter}; i++ ));
	do
		echo "		${i}. ${project[$i]}"
		echo
	done
	echo "		a. Add Setting"
	echo
	echo "		x. Exit"
	echo  
	printf "	>"
	read -s -n 1 choice
	if [ $choice = "x" ]; then
		reset
		exit
	fi
	regex='^[0-9ax]+$'
	if ! [[ $choice =~ $regex ]] ; then
		   echo "error: Not a number" >&2; continue; 
	fi
	if [ $choice = 0 -o "$choice" -gt "$counter" ]; then
		continue
	fi
	if [ $choice = "a" ]; then
		#we build the settings
		reset
		echo "	--------------------------------"
		echo "		M A I N - M E N U 	"
		echo "	--------------------------------"
		echo
		echo "	1. Project Name"
		printf "	>"
		read projectname
		echo "	2. SSH dev server location (user@domain.com or localhost)"
		printf "	>"
		read sshdevlocation
		echo "	3. Absolute path to working folder on ${sshdevlocation}"
		printf "	>"
		read devpath
		echo "	4. SSH live server location (user@domain.com or localhost)"
		printf "	>"
		read sshlivelocation
		echo "	5. Absolute path to working folder on ${sshlivelocation}"
		printf "	>"
		read livepath
		#now append it to the file with each setting separated by tabs
		echo "${projectname}	${sshdevlocation}	${devpath}	${sshlivelocation}	${livepath}" >> gitsynch_settings
		read_settings
		continue;

	fi
	clear
	echo
	echo
	echo "	--------------------------------"
	echo "		Project ${project[$choice]}	"
	echo "	--------------------------------"
	echo
	echo "		1. Push Changes"
	echo
	echo "		2. Pull"
	echo
	echo "		3. Push then Pull"
	echo
	echo "		4. Check statuses"
	echo
	echo "		5. Overwrite Changes"
	echo
	echo "		e. Edit Project"
	echo
	echo "		d. Delete Project"
	echo
	echo "		m. Main Menu"
	echo
	printf "	>"
	read -s -n 1 action
	regex='^[1-4emd]+$'
	if ! [[ $choice =~ $regex ]] ; then
		   echo "error: Not a number" >&2; continue; 
	fi
	case $action in
		1) 
			echo "Pushing....."
			echo "Type your commit comment and press [Enter]: "
			echo
			printf "	>"
			read comment
			if [ ${ssh_dev[$choice]} = 'localhost' ]; then
				#no need to ssh
				echo "working locally"
				cd ${dir_dev[$choice]}; git show --oneline -s; git add *; git commit -m "${comment}"; git push
			else
				echo "tunnelling to: ${ssh_dev[$choice]}"
				ssh ${ssh_dev[$choice]} "cd ${dir_dev[$choice]}; git show --oneline -s; git add *; git commit -m '$comment'; git push"
			fi
			read -p "Completed. Press [Enter] key to Continue" readEnterKey
			;;
		2) 
			echo "Pull"
			ssh ${ssh_live[$choice]} "cd ${dir_live[$choice]}; git show --oneline -s; git pull; git show --oneline -s"
			read -p "Completed. Press [Enter] key to Continue" readEnterKey
			;;
		3) 
			echo "Push and pull"
			echo "Type your commit comment and press [Enter]: "
			echo
			printf "	>"
			read comment
			if [ ${ssh_dev[$choice]} = 'localhost' ]; then
				echo
				cd ${dir_dev[$choice]}; git show --oneline -s; git add *; git commit -m "${comment}"; git push
			else
				echo
				ssh ${ssh_dev[$choice]} "cd ${dir_dev[$choice]}; git show --oneline -s; git add *; git commit -m '${comment}'; git push"
			fi
			if [ ${ssh_live[$choice]} = 'localhost' ]; then
				echo
				cd ${dir_live[$choice]}; git show --oneline -s; git pull; git show --oneline -s
			else
				echo
				ssh ${ssh_live[$choice]} "cd ${dir_live[$choice]}; git show --oneline -s; git pull; git show --oneline -s"
			fi
			read -p "Completed. Press [Enter] key to Continue" readEnterKey
			;;
		4)
			if [ ${ssh_dev[$choice]} = 'localhost' ]; then
				#no need to ssh
				echo
				echo "Development git show: "
				cd ${dir_dev[$choice]}; git show --oneline -s; 
			else
				echo "Development git show: "
				ssh ${ssh_dev[$choice]} "cd ${dir_dev[$choice]}; git show --oneline -s"
			fi
			if [ ${ssh_live[$choice]} = 'localhost' ]; then
				#no need to ssh
				echo
				echo "Production git show: "
				cd ${dir_live[$choice]}; git show --oneline -s; 
			else
				echo "Production git show: "
				ssh ${ssh_live[$choice]} "cd ${dir_live[$choice]}; git show --oneline -s"
			fi
			read -p "Completed. Press [Enter] key to Continue" readEnterKey
			;;
		5)
			#ask em if they are sure
			echo "	Are you sure you want to overwrite the changes on the live server? ${project[$choice]} [y/n]"
			echo "	This will perform git fetch_all"
			printf "	>"
			read -s -n 1 delete_choice
			if [ $delete_choice = 'n' ]; then
				continue
			fi
			if [ $delete_choice = 'y' ]; then
				#we need to read the file in until we get to the row stored in $choice
				sed -i "${choice}d" gitsynch_settings
				read_settings
			fi
			continue
			;;
		d)
			#ask em if they are sure
			echo "	Are you sure you want to delete ${project[$choice]} [y/n]"
			printf "	>"
			read -s -n 1 delete_choice
			if [ $delete_choice = 'n' ]; then
				continue
			fi
			if [ $delete_choice = 'y' ]; then
				#we need to read the file in until we get to the row stored in $choice
				sed -i "${choice}d" gitsynch_settings
				read_settings
			fi
			continue
			;;
		e)
			reset
			#get the settings
			echo "	--------------------------------"
			echo "		Editing ${project[$choice]}	"
			echo "	--------------------------------"
			echo
			#read the line into an array.
			echo "	Change Project name? (${project[$choice]}) [y/n]"
			printf "	>"
			read -s -n 1 change_name
			if [ $change_name = 'y' ]; then
				#we change the name.
				echo "	Please type the new name and press [Enter]"
				read new_name
			else
				new_name=${project[$choice]};
			fi
			echo "	Change dev SSH? (${ssh_dev[$choice]}) [y/n]"
			printf "	>"
			read -s -n 1 change_dev_ssh
			if [ $change_dev_ssh = 'y' ]; then
				#we change the dev ssh
				echo "	Please type the new dev ssh and press [Enter]"
				printf "	>"
				read new_dev_ssh
			else
				new_dev_ssh=${ssh_dev[$choice]};
			fi
			echo "	Change dev working folder? (${dir_dev[$choice]}) [y/n]"
			printf "	>"
			read -s -n 1 change_dir_dev
			if [ $change_dir_dev = 'y' ]; then
				#we change the dev path 
				echo "	Please type the new dev files path and press [Enter]"
				printf "	>"
				read new_dev_dir
			else
				new_dev_dir=${dir_dev[$choice]};
			fi
			echo "	Change live SSH? (${ssh_live[$choice]}) [y/n]"
			printf "	>"
			read -s -n 1 change_live_ssh
			if [ $change_live_ssh = 'y' ]; then
				#we change the live ssh
				echo "	Please type the new live ssh and press [Enter]"
				printf "	>"
				read new_live_ssh
			else
				new_live_ssh=${ssh_dev[$choice]};
			fi
			echo "	Change live working folder? (${dir_live[$choice]}) [y/n]"
			printf "	>"
			read -s -n 1 change_dir_live
			if [ $change_dir_live = 'y' ]; then
				#we change the live path 
				echo "	Please type the new live files path and press [Enter]"
				read new_live_dir
			else
				new_live_dir=${dir_live[$choice]};
			fi
			sed -i.bak "s,${project[$choice]}	${ssh_dev[$choice]}	${dir_dev[$choice]}	${ssh_live[$choice]}	${dir_live[$choice]},${new_name}	${new_dev_ssh}	${new_dev_dir}	${new_live_ssh}	${new_live_dir},g" gitsynch_settings
			sleep 20

		    		
			read_settings
			continue
			;;
		M)	
			continue
			;;
		*)	
			;;
	esac
done
