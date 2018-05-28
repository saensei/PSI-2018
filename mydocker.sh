#!/bin/sh

### BEGIN INIT INFO
# Provides:          mydocker
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
### END INIT INFO


    case "$1" in
	start)
	    cd docker
	    sudo docker-compose up
	    ;;
	*)
	    exit 3
	    ;;
    esac
