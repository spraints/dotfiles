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
  ("_devsvc_gh_mysql_$cmd")
  ("_devsvc_gh_es_$cmd")
  ("_devsvc_launch_mysql_$cmd")
}

_devsvc_gh_mysql_start() {
  echo Starting mysql for github/github...
  cd ~/github/mhagger-docker-test-env
  bin/mysqld-start
}

_devsvc_gh_mysql_stop() {
  echo Stopping mysql for github/github...
  cd ~/github/mhagger-docker-test-env
  bin/mysqld-stop
}

_devsvc_gh_es_start() {
  echo Starting elasticsearch for github/github...
  cd ~/github/mhagger-docker-test-env
  bin/elasticsearch-start
}

_devsvc_gh_es_stop() {
  echo Stopping elasticsearch for github/github...
  cd ~/github/mhagger-docker-test-env
  bin/elasticsearch-stop
}

_devsvc_launch_mysql_start() {
  : # no-op, launch will start this as needed.
}

_devsvc_launch_mysql_stop() {
  echo Stopping docker-compose services for github/launch...
  cd ~/go-dev/launch/gopath/src/github.com/github/launch
  script/docker-compose stop
}
