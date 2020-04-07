devsvc() {
  case "$1" in
    start)
      _devsvc_all start ;;
    stop)
      _devsvc_all stop ;;
    *)
      echo "Usage: devsvc [start|stop]" ;;
  esac
}

_devsvc_all() {
  local cmd="$1"
  ("_devsvc_gh_$cmd")
  ("_devsvc_launch_mysql_$cmd")
}

_devsvc_gh_start() {
  cd ~/github/mhagger-docker-test-env
  echo Starting services for github/github...
  bin/start || true
}

_devsvc_gh_stop() {
  cd ~/github/mhagger-docker-test-env
  echo Stopping services for github/github...
  bin/stop || true
}

_devsvc_launch_mysql_start() {
  : # launch will start others as needed.
}

_devsvc_launch_mysql_stop() {
  echo Stopping launch test mysql
  docker stop launch-test-mysql57

  echo Stopping docker-compose services for github/launch...
  cd ~/go-dev/launch/gopath/src/github.com/github/launch
  script/docker-compose stop
}
