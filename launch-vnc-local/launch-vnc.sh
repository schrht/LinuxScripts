#!/bin/bash

# Create VNC at 5901 if needed
vncserver -list | grep -q "^:1\s"
[ $? != 0 ] && vncserver :1

# Start VNC Viewer and connect
vncviewer localhost:5901 -geometry=1024*768 -PasswordFile=$HOME/.vnc/passwd &
