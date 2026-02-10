const DIR = (path self | path dirname)

# Get current branch status for project repos
export def main [
  --npm-install(-n) # Install NPM dependencies after fetching repo
  --reset-to-dev # Reset to dev on all repos
  --npm-audit # Run NPM audit
  --sequential(-s) # Run sequentially instead of in parallel
] {
  let repos = open ($DIR | path join "branches.nuon")

  if $sequential {
    $repos | each {|r| process-repo $r --npm-install=$npm_install --reset-to-dev=$reset_to_dev --npm-audit=$npm_audit }
  } else {
    $repos | par-each {|r| process-repo $r --npm-install=$npm_install --reset-to-dev=$reset_to_dev --npm-audit=$npm_audit }
  }
}

# Function that runs the repo checks
def process-repo [repo: list<string> --npm-install --reset-to-dev --npm-audit] {
  let path = ($env.HOME | path join ($repo | path join))
  cd $path

  print $"--- Processing ($repo | path join)"

  let _ = (git fetch out> /dev/null err> /dev/null)

  if $reset_to_dev {
    git restore package-lock.json
    reset-to-dev out> /dev/null err> /dev/null
  }

  if $npm_install {
    npm install out> /dev/null err> /dev/null
    git restore package-lock.json
  }

  if $npm_audit {
    npm audit
  }

  let git = (gstat)

  print $"--- Finished ($repo | path join)"

  {
    repo: ($repo | path join),
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
