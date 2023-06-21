#!/bin/bash

# Set the IP range for your wireless home network
ip_range="192.168.1.0/24"

# Set the search directory path for your OSINT project on each device (e.g., "/home/user/Documents/OSINT_Project")
search_dir="/path/to/search/directory"

# Set the target device information where you want to copy all files found.
target_device="user@192.168.1.X:/path/to/target/directory"

# Loop through all IPs in the specified IP range and check if SSH is available
for ip in $(nmap -p 22 --open $ip_range | grep "Nmap scan report" | awk '{print $NF}')
do
    # Check if SSH is available on this IP address
    ssh_result=$(ssh -o ConnectTimeout=5 -q user@$ip 'echo connected')
    if [ "$ssh_result" == "connected" ]; then
        
        # Search for files and directories in the specified search directory on this device using find command over ssh.
        echo "Searching $ip..."
        
        # Get list of all file paths from remote machine that match our search criteria, excluding any symlinks or parent directories etc.
        file_paths=$(ssh user@$ip "find ${search_dir}/* ! -type d ! -lname '*'")
        
        # Copy each file found via rsync client over ssh connection to local system at destination folder location as set by variable: `$target_device`
        echo "Copying matching files from ${ip}:${search_dir}/"
		rsync --archive --progress --relative --rsh='ssh' "${file_paths}" "${target_device}"
		
	else 
	    echo "$ip not responding or does not have SSH access."
	fi
done
