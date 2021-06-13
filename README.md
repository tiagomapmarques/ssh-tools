# SSH tools
Tools to manage the ssh keys of a user profile.

You can use these tools on a Bash or PowerShell terminals.

## Installation
 1. clone project into `~/.ssh` folder
    - git clone https://github.com/tiagomapmarques/ssh-tools.git ~/.ssh
 2. add appropriate script to a terminal profile
    - Bash: add `source ~/.ssh/ssh-tools.sh` to `~/.bash_profile`
    - PowerShell: add `~/.ssh/ssh-tools.ps1` to `~/Documents/PowerShell/profile.ps1`
 3. restart your terminal

## Quick usage
 * create new ssh key with `ssh-create <profile> <email> "<username>"`
 * list existing keys with `ssh-list`
 * check active ssh key with `ssh-which`
 * switch to an existing key with `ssh-switch <profile>`
 * save active ssh key and configuration with `ssh-stash`

>WARNING: If you already have a key before cloning the repo, you can add it to the tool by using `ssh-stash <profile>` - this will force the tool to create a new profile with the existing key. Do _**not**_ use `ssh-create` for this or your existing key may be overwritten.

## Updating
 1. `cd ~/.ssh`
 2. `git pull`

## Dependencies
 * Bash or Powershell 7
 * ssh-keygen
