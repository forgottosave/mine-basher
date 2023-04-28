#
# Mine Basher
#
# Mine-Sweeper in bash, main file
#
# @author Timon Ole Ensel
# https://github.com/forgottosave/mine-basher
#
# @license MIT
#

#!/bin/bash

##### GLOBAL VARs
# game fixed
SPF=130 # milliseconds per frame
Y_MAX=16
X_MAX=32
MINE_COUNT=10
# game state
POS=$(($Y_MAX / 2 * $X_MAX + $X_MAX / 2)) # cursor position
GRD="~" # tile under cursor
# colors
RED='\033[0;31m'
GRN='\033[0;32m'
BLU='\033[0;34m'
YLW='\033[0;33m'
# characters
PLR="#" # cursor
NOO="~" # water
LND=" " # land (rim shows numbers)
# additional files needed
THIS_DIR=$(dirname "$0")
# array of mine-positions
declare -a FIFO


##### ARGUMENT PARSING
case $1 in
-h|--help)
	echo "help doesn't exist yet"
    exit 0
;;
esac


##### METHODS
# game end
stop_game() { # $1=message
	echo "$1"
	exit 0
}
# define interrupt action
interrupt() {
	stop_game "Game interrupted by user."
}
trap interrupt INT
# convert x- and y-coordinates to POS-value
pos_to_x() {
    ret=$(($1 % $X_MAX))
    echo "$ret"
}
pos_to_y() {
    ret=$(($1 / $X_MAX + 1))
    echo "$ret"
}
# draw a `pixel` on screen
draw_det() { # $1=y $2=x $3=character
    printf "\033[1D\033[s\033[$1A\033[$2C$2\033[u"
}
draw() { # $1=position $2=character
	x=$(pos_to_x "$1")
    y=$(pos_to_y "$1")
	draw_det y x "$2"
}
# startup sequence
startup() {
	## TODO
		# distribute mines
	# draw gamepanel & start
	for row in $(seq 0 $Y_MAX)
	do
    	line=""
    	for col in $(seq 0 $(($X_MAX - 2)))
    	do
    	    line="${line}${NOO}"
    	done
    	echo " ${line} "
	done
}
# calculates and loads one frame
# @return 0 if dead, 1 if alive after frame
loadframe() {
	printf "\033[1D"
    # print debug info"
    printf "\033[1A\033[K"
    echo "frame=$var, input=$input, position=$POS"
	# frame
    printf "\033[s"
    # update player here
    printf "\033[u"
    # catch user input
    read -n 1 -s -t .02 input
    [[ $? -gt 128 ]] && return 1
	return 1
}

##### GAME
startup
# game loop
starttime=`date +%s%N`
var=0
while true; do
	newtime=`date +%s%N`
	nextframe=$(($starttime + $SPF * 1000000))
	if [[ "$newtime" -gt "$nextframe" ]]; then
		starttime=`date +%s%N`
		if loadframe; then
			break
		fi
	fi
	#sleep 1
	var=$((var + 1))
done



