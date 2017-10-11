g() {
  local usage="$(cat <<USAGE
Usage: g [subcommand]
Helps get a go dev environment running for a project
Examples:
 (in home dir) $ g init --go 1.9 github.com/github/launch
    - clones the project into a new gopath
    - gets go version 1.9
    - do the "setup" step
 (in home dir) $ g start launch
    - cd to project path
    - set up PATH for go
 (in project dir) $ g start
    - set up PATH for go
USAGE
)"
  for arg; do
    case $arg in
      -h*|--h*)
        echo "$usage"
        return ;;
    esac
  done
  case "$1" in
    init)
      shift
      _g_init "$@" ;;
    start)
      shift
      _g_start "$@" ;;
    *)
      echo unknown command "$1"
      echo "$usage"
      return 1 ;;
  esac
}

# Initial setup for a project.
_g_init() {
  local usage="$(cat <<USAGE
Usage: g init [--go GOVERSION] PROJECT
where PROJECT is github.com/OWNER/REPO,
  OWNER/REPO, or REPO.
USAGE
)"
  local go_version
  local protoc_version
  local url
  while [ $# -gt 0 ]; do
    case "$1" in
      --go)
        go_version="$2"
        shift; shift ;;
      --protoc)
        protoc_version="$2"
        shift; shift ;;
      *)
        url="$(_g_normalize_url "$1")"
        shift;;
    esac
  done
  if [ $# -gt 0 ]; then
    echo "extra arguments: $*"
    echo "$usage"
    return 1
  fi
  if [ -z "$url" ]; then
    echo "missing repo URL"
    echo "$usage"
    return 1
  fi
  if [ -n "$go_version" ]; then
    _g_install_go "$go_version" || return 1
  fi
  if [ -n "$protoc_version" ]; then
    _g_install_protoc "$protoc_version" || return 1
  fi
  local local_name="$(basename "$url")"
  test -z "${HOME}" && local HOME=.
  local projectroot="${HOME}/go-dev/${local_name}"
  local config="${projectroot}/config"
  local gopath="${projectroot}/gopath"
  local worklink="${projectroot}/workdir"
  local workdir="${gopath}/src/${url}"
  local remote_url="git@$(echo "$url" | sed -e "s|/|:|")"
  if [ ! -d "$workdir/.git" ]; then
    echo "Cloning ${remote_url}..."
    rm -rf "${workdir}"
    git clone "${remote_url}" "${workdir}"
  fi
  echo "Writing config..."
  (
    echo "go_version=$go_version"
    if [ -n "$protoc_version" ]; then
      echo "protoc_version=$protoc_version"
    fi
  ) > "$config"
  echo "Linking the project's workdir..."
  rm -f "$worklink"
  ln -s "$workdir" "$worklink"
  echo "Setting environment and cd'ing to workdir"
  _g_enter "$projectroot" true "$go_version" "$protoc_version"
}

# Internal. Exports env vars so that go is configured correctly.
_go_version_env() {
  local go_version="$1"
  local go_path="$2"
  if [ -n "$go_version" ]; then
    if go version 2>/dev/null | grep -q "go$go_version" >/dev/null; then
      : # ok!
    else
      export GOROOT="$HOME/.goversions/${go_version}/go"
      export PATH="$GOROOT/bin:$PATH"
    fi
  fi
  export GOPATH="$go_path"
  export PATH="$GOPATH/bin:$PATH"
}

# Internal.
_protoc_version_env() {
  local protoc_version="$1"
  if [ -n "$protoc_version" ]; then
    if protoc version 2>/dev/null | grep -q "protoc $protoc_version" >/dev/null; then
      : # ok!
    else
      export PATH="$HOME/.goversions/protoc-${protoc_version}/bin:$PATH"
    fi
  fi
}

# Internal.
_g_normalize_url() {
  case "$1" in
    */*/*)
      echo "$1" ;;
    */*)
      echo "github.com/$1" ;;
    *)
      echo "github.com/github/$1" ;;
  esac
}

# Internal.
_g_install_go() {
  local go_version="$1"
  if go version 2>/dev/null | grep -q "go$go_version" 2>/dev/null; then
    return 0
  fi
  local os
  local pkg_sha
  if [ "$(uname -s)" = "Darwin" ]; then
    os=darwin-amd64
    case "${go_version}" in
      1.9.1)
        pkg_sha=59bc6deee2969dddc4490b684b15f63058177f5c7e27134c060288b7d76faab0 ;;
      1.8.1)
        pkg_sha=25b026fe2f4de7c80b227f69588b06b93787f5b5f134fbf2d652926c08c04bcd ;;
      *)
        echo Unsupported go version "$go_version"
        return 1 ;;
    esac
  else
    os=linux-amd64
    case "${go_version}" in
      1.9.1)
        pkg_sha=07d81c6b6b4c2dcf1b5ef7c27aaebd3691cdb40548500941f92b221147c5d9c7 ;;
      1.8.1)
        pkg_sha=a579ab19d5237e263254f1eac5352efcf1d70b9dacadb6d6bb12b0911ede8994 ;;
      *)
        echo Unsupported go version "$go_version"
        return 1 ;;
    esac
  fi
  local pkg="go${go_version}.${os}.tar.gz"
  local url="https://storage.googleapis.com/golang/${pkg}"
  local archive="$HOME/.goversions/${pkg}"
  local install_dir="$HOME/.goversions/${go_version}"
  local installed_go="$install_dir/go/bin/go"
  if [ -f "$installed_go" ] && $installed_go version | grep "go$go_version" 2>/dev/null; then
    return 0
  fi
  mkdir -p ~/.goversions || return 1
  if ! _g_check_sha256_sum "$archive" "$pkg_sha"; then
    echo Downloading "$url" ...
    rm -f "$archive"
    curl -o "$archive" "$url"
    if ! _g_check_sha256_sum "$archive" "$pkg_sha"; then
      echo Downloaded archive has unexected sha256 checksum
      return 1
    fi
  fi
  mkdir -p "$install_dir"
  tar xfz "$archive" -C "$install_dir" || return 1
  echo Installed "$($install_dir/go/bin/go version)"
}

_g_install_protoc() {
  local protoc_version="$1"
  local version_string="protoc ${protoc_version}"
  if protoc version 2>/dev/null | grep -q "$version_string"; then
    return 0
  fi
  local os
  if [ "$(uname -s)" = "Darwin" ]; then
    os=osx
  else
    os=linux
  fi
  local pkg="protoc-${protoc_version}-${os}-x86_64.zip"
  local url="https://github.com/google/protobuf/releases/download/v${protoc_version}/${pkg}"
  local archive="$HOME/.goversions/${pkg}"
  local tmparchive="${archive}.tmp"
  local install_dir="$HOME/.goversions/protoc-${protoc_version}"
  local installed_protoc="${install_dir}/bin/protoc"
  if [ -f "$installed_protoc" ] && $installed_protoc --version | grep -q "$version_string"; then
    return 0
  fi
  if [ ! -f "$archive" ]; then
    echo Downloading "$url" ...
    mkdir -p ~/.goversions || return 1
    rm -f "$tmparchive"
    curl -L -o "$tmparchive" "$url"
    if ! unzip -l "$tmparchive" >/dev/null; then
      return 1
    fi
    mv "$tmparchive" "$archive"
  fi
  unzip -d "$install_dir" -q "$archive"
  echo Installed protoc version "$protoc_version"
}

# Internal
_g_check_sha256_sum() {
  local file="$1"
  local expected="$2"
  local actual="$(shasum -a 256 "$file" | awk '{print $1}')"
  test "$expected" = "$actual"
}

# Internal
_g_start() {
  local projectroot="$1"
  local cd_to_project=true
  if [ -z "$projectroot" ]; then
    cd_to_project=false
    projectroot="$(pwd -P)"
    while echo "$projectroot" | grep -q go-dev && [ go-dev != "$(basename "$(dirname "$projectroot")")" ]; do
      projectroot="$(dirname "$projectroot")"
    done
  elif [ -d "$projectroot" ]; then
    projectroot="$(cd "$projectroot"; pwd -P)"
  else
    projectroot="$HOME/go-dev/${projectroot}"
  fi
  local config="$projectroot/config"
  local go_version
  local protoc_version
  if [ ! -f "$config" ]; then
    echo "$1 doesn't look like a project that I can set up ($projectroot)"
    return 1
  else
    eval "$(grep ^go_version= "$config")"
    eval "$(grep ^protoc_version= "$config")"
  fi
  _g_enter "$projectroot" "$cd_to_project" "$go_version" "$protoc_version"
}

_g_enter() {
  local projectroot="$(cd "$1"; pwd -P)"
  local cd_to_project="$2"
  local go_version="$3"
  local protoc_version="$4"
  if [ "$cd_to_project" = "true" ]; then
    cd "$projectroot/workdir" || return 1
  fi
  _go_version_env "$go_version" "$projectroot/gopath"
  _protoc_version_env "$protoc_version"
  go version || return 1
  test -z "$protoc_version" || protoc --version || return 1
  echo GOPATH="$GOPATH"
  echo pwd="$(pwd)"
}

_g_reload() {
  . "$BASH_SOURCE"
}
