#!/bin/bash

read -p " Enter username : " username

echo " you enterd $username "

sudo useradd -m $username

echo " New User added "
