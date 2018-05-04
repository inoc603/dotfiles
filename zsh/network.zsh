###############################################################################
# Network
###############################################################################

# Kill process using the given port
# USAGE: freeport PORT
freeport () {
  	lsof -n -i:$1 | grep LISTEN | awk '{ print $2 }' | uniq | xargs kill -9
}

# Check whether the given port is in use
# USAGE: checkport PORT
checkport () {
	lsof -n -i:$1 | grep LISTEN
}

# Get IP adress on ethernet.
myip() {
	case `uname` in
		Darwin)	interface='en0'		;;
		*)	interface='eth0'	;;
	esac

	case $1 in
		4)	filter='$1=="inet"'	;;
		6)	filter='$1=="inet6"'	;;
		*)	filter='/inet/'		;;
	esac

	MY_IP=$(ifconfig ${interface} | awk "${filter} { print \$2  }" |
		sed -e s/addr://)
	echo ${MY_IP:-"Not connected"}
}

