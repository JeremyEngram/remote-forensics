#!/bin/bash

read -p "name@host :> " name host
ssh $name@$host "command1; command2; command3" | tee -a remote_log.log
ssh $name@$host su -c "/path/to/command1 arg1 arg2"
