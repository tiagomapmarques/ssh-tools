# SSH tools
Tools to create, save, switch and check ssh keys.

## Install guide
 1. clone project into ~/.ssh folder
 2. import ssh tools to ~/.bash_profile by adding `source ~/.ssh/scripts.sh` to the file
 3. restart your shell

## Quick usage guide
 * create new ssh key with `ssh-init <profile> <email> "<username>"`
 * switch to that key with `ssh-switch <profile>`
 * check what ssh key you are using with `ssh-which`
 * save current ssh key with `ssh-stash`
