
function SSHWhich() {
  if [ ! -f ~/.ssh/.active ]; then
    echo "No active key yet"
  else
    echo "Active key: \"$(cat ~/.ssh/.active)\""
  fi
}

function SSHInit() {
  if [ -z "$3" ]; then
    echo "[usage] ssh-init <profile> <email> \"<username>\""
    return 1
  fi
  echo "Generating new key for \"$1\""
  rm -rf ~/.ssh/$1 &> /dev/null
  mkdir -p ~/.ssh/$1 &> /dev/null
  ssh-keygen -t rsa -b 4096 -C "$2" -N '' -f ~/.ssh/$1/id_rsa &> /dev/null
  printf "[user]\n\temail = $2\n\tname = $3\n" > ~/.ssh/$1/.gitconfig &> /dev/null
  printf "Files created:\n$(ls -a ~/.ssh/$1 | grep -v '^[\.]*$')\n"
}

function SSHStash() {
  if [ ! -f ~/.ssh/.active ]; then
    echo "No active key to stash"
  else
    active=$(cat ~/.ssh/.active) &> /dev/null
    mkdir -p ~/.ssh/$active &> /dev/null
    cp -f ~/.ssh/id_rsa* ~/.ssh/$active/ &> /dev/null
    cp -f ~/.ssh/known_hosts ~/.ssh/$active/ &> /dev/null
    cp -f ~/.gitconfig ~/.ssh/$active/ &> /dev/null
    echo "SSH key stashed to \"$active\""
  fi
}

function SSHSwitch() {
  if [ -z "$1" ]; then
    echo "[usage] ssh-switch <profile>"
    return 1
  fi
  if [ ! -f ~/.ssh/$1/id_rsa ]; then
    echo "No profile \"$1\" exists"
    return 2
  fi
  SSHStash
  cp -f ~/.ssh/$1/.gitconfig ~/ &> /dev/null
  cp -f ~/.ssh/$1/id_rsa* ~/.ssh &> /dev/null
  cp -f ~/.ssh/$1/known_hosts ~/.ssh &> /dev/null
  echo $1 > ~/.ssh/.active
  SSHWhich
}

alias ssh-init="SSHInit"
alias ssh-switch="SSHSwitch"
alias ssh-stash="SSHStash"
alias ssh-which="SSHWhich"
