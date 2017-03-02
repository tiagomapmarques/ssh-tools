# SSH tools
Tools to create, save, switch and check ssh keys.

## Install guide
 1. clone project into `~/.ssh` folder
 2. add `source ~/.ssh/ssh-tools.sh` to `~/.bash_profile`
 3. restart your shell

## Quick usage guide
 * create new ssh key with `ssh-init <profile> <email> "<username>"`
 * switch to that key with `ssh-switch <profile>`
 * check active ssh key with `ssh-which`
 * save active ssh key and configuration with `ssh-stash`

## Updating
 1. `cd ~/.ssh`
 2. `git pull`

## Dependencies
 * bash (shell script)
 * ssh-keygen
