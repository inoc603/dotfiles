###############################################################################
# Docker 
###############################################################################

# Clean inactive containers and temperary images
alias dclean="\
  docker ps -aq -f status=exited -f status=created | xargs docker rm;\
  docker images -q -f dangling=true | xargs docker rmi"

# Stop and delete all containers
alias dpurge='docker rm -f `docker ps -q`'

# Get PID of container
alias dpid='docker inspect -f {{.State.Pid}}'

# Shorthand for docker-compose
alias dcu='docker-compose up'
alias dcd='docker-compose down'

