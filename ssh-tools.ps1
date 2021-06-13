
function global:ssh-which {
  if (-not (Test-Path -Path ~/.ssh/.active -PathType Leaf)) {
    echo "No active key yet"
  } else {
    echo "Active key: ""$(Get-Content ~/.ssh/.active)"""
  }
}

function global:ssh-list {
  echo "Existing profiles:"
  Get-ChildItem -Path ~/.ssh -Name -Directory
}

function global:ssh-create {
  if ($args.Count -lt 3) {
    echo "[usage] ssh-create <profile> <email> ""<username>"""
    return
  }
  $profile=$args[0]
  $email=$args[1]
  $username=$args[2]

  echo "Generating new key for ""$profile"""
  Remove-Item –Path ~/.ssh/$profile -Recurse -Erroraction 'silentlycontinue' > $null
  mkdir ~/.ssh/$profile -Erroraction 'silentlycontinue' > $null
  ssh-keygen -q -b 4096 -t rsa -f "$env:USERPROFILE/.ssh/$profile/id_rsa" -C "$email" -N """"
  echo "[user]" "	email = $email" "	name = $username" "" | Set-Content -Path ~/.ssh/$profile/.gitconfig -Erroraction 'silentlycontinue' > $null

  echo "Files created:"; Get-ChildItem -Path ~/.ssh/$profile -Name -File
}

function global:ssh-stash {
  if ($args.Count -ge 1) {
    $profile=$args[0]
    echo $profile | Set-Content -Path ~/.ssh/.active -Erroraction 'silentlycontinue' > $null
  }

  if (-not (Test-Path -Path ~/.ssh/.active -PathType Leaf)) {
    echo "No active key to stash"
    return
  }

  $active=$(Get-Content ~/.ssh/.active)
  mkdir ~/.ssh/$active -Erroraction 'silentlycontinue' > $null
  Copy-Item -Force ~/.ssh/id_rsa* ~/.ssh/$active/ -Erroraction 'silentlycontinue' > $null
  Copy-Item -Force ~/.ssh/known_hosts ~/.ssh/$active/ -Erroraction 'silentlycontinue' > $null
  Copy-Item -Force ~/.gitconfig ~/.ssh/$active/ -Erroraction 'silentlycontinue' > $null

  echo "SSH key stashed to ""$active"""
}

function global:ssh-switch {
  if ($args.Count -lt 1) {
    echo "[usage] ssh-switch <profile>"
    return
  }
  $profile=$args[0]

  if (-not (Test-Path -Path ~/.ssh/$profile/id_rsa -PathType Leaf)) {
    echo "No profile ""$profile"" exists"
    return
  }

  ssh-stash
  Copy-Item -Force ~/.ssh/$profile/.gitconfig ~/ -Erroraction 'silentlycontinue' > $null
  Copy-Item -Force ~/.ssh/$profile/id_rsa* ~/.ssh -Erroraction 'silentlycontinue' > $null
  Copy-Item -Force ~/.ssh/$profile/known_hosts ~/.ssh -Erroraction 'silentlycontinue' > $null
  echo $profile | Set-Content -Path ~/.ssh/.active -Erroraction 'silentlycontinue' > $null
  ssh-which
}
