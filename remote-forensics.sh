#!/bin/bash

read -p "name@host :> " name host
ssh $name@$host "command1; command2; command3" | tee -a remote_log.log
