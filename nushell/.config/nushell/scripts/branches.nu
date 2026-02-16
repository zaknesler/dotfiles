const DIR = (path self | path dirname)

# Get current branch status for project repos
export def main [
  --npm-install(-n) # Install NPM dependencies after fetching repo
  --reset-to-dev # Reset to dev on all repos
  --npm-audit # Run NPM audit
  --npm-link # Run NPM link for dependencies
  --sequential(-s) # Run sequentially instead of in parallel
] {
  let repos = open ($DIR | path join "branches.nuon")

  if $sequential {
    $repos | each {|r| process-repo $r --npm-install=$npm_install --reset-to-dev=$reset_to_dev --npm-audit=$npm_audit --npm-link=$npm_link }
  } else {
    $repos | par-each {|r| process-repo $r --npm-install=$npm_install --reset-to-dev=$reset_to_dev --npm-audit=$npm_audit --npm-link=$npm_link }
  }
}

# Function that runs the repo checks
def process-repo [repo: record --npm-install --reset-to-dev --npm-audit --npm-link] {
  let path = ($env.HOME | path join ($repo.path | path join))
  cd $path

  print $"--- Processing ($repo.path | path join)"

  let _ = (git fetch out> /dev/null err> /dev/null)

  if $reset_to_dev {
    git restore package-lock.json
    reset-to-dev out> /dev/null err> /dev/null
  }

  if $npm_install {
    npm install out> /dev/null err> /dev/null
    git restore package-lock.json
  }

  if $npm_link and ($repo.npm_link | length) > 0 {
    npm link ...$repo.npm_link out> /dev/null err> /dev/null
  }

  if $npm_audit {
    npm audit
  }

  let git = (gstat)

  print $"--- Finished ($repo.path | path join)"

  {
    repo: ($repo.path | path join),
    branch: ($git | get branch),
    behind: ($git | get behind),
    ahead: ($git | get ahead),
    untracked: ($git | get wt_untracked),
    modified: ($git | get wt_modified),
    deleted: ($git | get wt_deleted),
    type_changed: ($git | get wt_type_changed),
    renamed: ($git | get wt_renamed),
  }
}
