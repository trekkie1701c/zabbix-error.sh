#!/bin/bash

# Script for Zabbix to run when an error is encountered.  Zabbix will write the most recent error
# message to a file (or, you should configure it to), then pipe the message out to an irssi client
# Attached to an IRC server.
# You can configure your settings below.

# Set your own settings here to connect to your irc server or bouncer.
# I recommend connecting to ZNC, so that you can have multiple clients report to the same server
server=irc.foo.net
port=1234
password=password1

# Enter a nick you or an operator can be reached by here; this will cause irssi to query you.

oper=badmin

# Add a channel here to report to.  Remember to escape the #.

channel=\#status

# Define your error file.  Use an absolute path, not a relative one.
errfile=/var/lib/zabbix/error.msg

# Add a prepend message here for your errors.  This is useful if your IRC client won't notify on nicks
# But will notify on highlights.
prepend=WARNING

# I like to add some waits in here, as this is a script meant to run
# When the server isn't necessarily at it's best.
# Set your own number here in seconds.  0 to disable.

delay=10

# Copy Error Message to the error variable
error=$(<$errfile)
# Launch irssi in background with screen
screen -d -m irssi
# And connect it to our server.  We'll give it a few seconds to start up, just in case the server is laggy
# Since, you know, this script is only called when an error is detected
# Leave the hanging quotes,or irssi won't do anything.
sleep $delay
screen -X stuff "/connect $server $port $password
"
# Then get in to the channel
sleep $delay
screen -X stuff "/join $channel
"
sleep $delay
# And post the error message
screen -X stuff "$prepend $error
"
screen -X stuff "/query $oper $prepend $error
"
sleep $delay
#Then exit
screen -X stuff "/exit
"
