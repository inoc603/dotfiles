###############################################################################
# Git
###############################################################################

# Set local git user info to github account. You should set GITHUB_USER and
# GITHUB_EMAIL in zshenv
me() {
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
gh() {
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

	echo $p
	git clone $1 ~/src/$p
}

# Change the commits author from one to another, across all commits
# USAGE: fix_git_author WRONG_EMAIL CORRECT_NAME CORRECT_EMAIL
fix_git_author() {
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
