
function ssh-which() {
  if [ ! -f ~/.ssh/.active ]; then
    echo "No active key yet"
  else
    echo "Active key: \"$(cat ~/.ssh/.active)\""
  fi
}

function ssh-list() {
  current=$(pwd)
  echo "Existing profiles:"
  cd ~/.ssh
  find * -type d
  cd $current
}

function ssh-create() {
  if [ $# -lt 3 ]; then
    echo "[usage] ssh-create <profile> <email> \"<username>\""
    return 1
  fi
  profile=$1
  email=$2
  username=$3

  echo "Generating new key for \"$profile\""
  rm -rf ~/.ssh/$profile &> /dev/null
  mkdir -p ~/.ssh/$profile &> /dev/null
  ssh-keygen -q -b 4096 -t rsa -f ~/.ssh/$profile/id_rsa -C "$email" -N ''
  printf "[user]\n\temail = $email\n\tname = $username\n" > ~/.ssh/$profile/.gitconfig &> /dev/null

  printf "Files created:\n$(ls -p -a ~/.ssh/$profile | grep -v / | grep -v '^[\.]*/$')\n"
}

function ssh-stash() {
  if [ $# -ge 1 ]; then
    profile=$1
    echo $profile > ~/.ssh/.active &> /dev/null
  fi

  if [ ! -f ~/.ssh/.active ]; then
    echo "No active key to stash"
    return 1
  fi

  active=$(cat ~/.ssh/.active)
  mkdir -p ~/.ssh/$active &> /dev/null
  cp -f ~/.ssh/id_rsa* ~/.ssh/$active/ &> /dev/null
  cp -f ~/.ssh/known_hosts ~/.ssh/$active/ &> /dev/null
  cp -f ~/.gitconfig ~/.ssh/$active/ &> /dev/null

  echo "SSH key stashed to \"$active\""
}

function ssh-switch() {
  if [ $# -lt 1 ]; then
    echo "[usage] ssh-switch <profile>"
    return 1
  fi
  profile=$1

  if [ ! -f ~/.ssh/$profile/id_rsa ]; then
    echo "No profile \"$profile\" exists"
    return 2
  fi

  ssh-stash
  cp -f ~/.ssh/$profile/.gitconfig ~/ &> /dev/null
  cp -f ~/.ssh/$profile/id_rsa* ~/.ssh &> /dev/null
  cp -f ~/.ssh/$profile/known_hosts ~/.ssh &> /dev/null
  echo $profile > ~/.ssh/.active &> /dev/null
  ssh-which
}
