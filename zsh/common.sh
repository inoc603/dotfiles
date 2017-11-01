
alias c='clear'

# Fast navigating
alias cd..='cd ../'
alias ..='cd ../'
alias ...='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../../'
alias .6='cd ../../../../../../'

# List and find
alias la='ls -a'
alias ll='ls -FGlAhp'
alias lf='la | grep'
alias llf='ll | grep'
alias pf='ps -e | grep'

# Pretty print path
alias path='echo -e ${PATH//:/\\n}'

alias todo='nvim ~/.todo.md'

# Kill process using the given port
# USAGE: freeport PORT
function freeport () {
  lsof -n -i:$1 | grep LISTEN | awk '{ print $2 }' | uniq | xargs kill -9
}

# Check whether the given port is in use
# USAGE: checkport PORT
function checkport () {
  lsof -n -i:$1 | grep LISTEN
}

# Get IP adress on ethernet.
function myip() {
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

# Set local git user info to github account. You should set GITHUB_USER and
# GITHUB_EMAIL in zshenv
function me() {
  if [ -z ${GITHUB_USER+x} ]
  then
    echo "GITHUB_USER is unset"
    return 0
  fi

  if [ -z ${GITHUB_EMAIL+x} ]
  then
    echo "GITHUB_EMAIL is unset"
    return 0
  fi

  git config user.name "$GITHUB_USER"
  git config user.email "$GITHUB_EMAIL"
}

# clone git repos in a GOPATH-like fashion
# USAGE: gh GIT_URL
function gh() {
  p=$(echo $1 | sed -n 's/^https:\/\/\(.*\)\.git$/\1/p')
  if [ -z $p ]
  then
    p=$(echo $1 | sed -n 's/^git@\(.*\)\.git$/\1/p' | sed -e 's/\:/\//g')
  fi

  if [ -z $p ]
  then
    echo 'not a valid git repo url'
    return 1
  fi

  host=$(get_git_host $p)
  echo $p
  git clone $1 ~/src/$p
}

function get_git_host() {
  host=$(echo $1 | sed -n 's/^git@\([^:]*\):.*/\1/p')
  if [ "$host" == "" ]; then
    host=$(echo $1 | sed -n 's/^https:\/\/\([^:\/]*\).*/\1/p')
  fi
  echo $host
}

function gu() {
  host=$(get_git_host $(git remote get-url origin))
  echo $host
}

# Change the commits author from one to another, across all commits
# USAGE: fix_git_author WRONG_EMAIL CORRECT_NAME CORRECT_EMAIL
function fix_git_author() {
  git filter-branch -f --env-filter '
  OLD_EMAIL="'$1'"
  CORRECT_NAME="'$2'"
  CORRECT_EMAIL="'$3'"
  if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
  then
      export GIT_COMMITTER_NAME="$CORRECT_NAME"
      export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
  fi
  if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
  then
      export GIT_AUTHOR_NAME="$CORRECT_NAME"
      export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
  fi
  ' --tag-name-filter cat -- --branches --tags
}
