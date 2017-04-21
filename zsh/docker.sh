# Clean inactive containers and temperary images
alias dclean="\
  docker ps -aq -f status=exited -f status=created | xargs docker rm;\
  docker images -q -f dangling=true | xargs docker rmi"

# Stop and delete all containers
alias dpurge='docker rm -f `docker ps -q`'

# Get PID of container
alias dpid='docker inspect -f {{.State.Pid}}'

# ------------------
# Docker compose
# ------------------

alias dcu='docker-compose up'
alias dcd='docker-compose down'

# ------------------
# Docker machine
# ------------------

alias dm='docker-machine'

# Change docker machine environment
function de () {
    eval `docker-machine env $1`
}
