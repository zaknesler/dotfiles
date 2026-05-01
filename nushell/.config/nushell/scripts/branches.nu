const DIR = (path self | path dirname)

# Get current branch status for project repos
export def main [
  --npm-install(-N) # Install NPM dependencies after fetching repo
  --reset-to-dev(-R) # Reset to dev on all repos
  --npm-audit(-A) # Run NPM audit
  --npm-link(-L) # Run NPM link for dependencies
  --latest(-U) # Update to latest internal packages
  --sequential(-s) # Run sequentially instead of in parallel
] {
  let repos = open ($DIR | path join "branches.nuon")

  let options = {
    npm_install: $npm_install,
    reset_to_dev: $reset_to_dev,
    npm_audit: $npm_audit,
    npm_link: $npm_link,
    latest: $latest,
  }

  if $sequential {
    $repos | each {|r| process-repo $r $options }
  } else {
    $repos | par-each {|r| process-repo $r $options } | collect
  }
}

# Function that runs the repo checks
def process-repo [repo: record, options: record] {
  let path = ($env.HOME | path join ($repo.path | path join))
  cd $path

  print $"\n\n\n\n--- Processing ($repo.path | path join)"

  let _ = (git fetch out+err> /dev/null)

  if $options.reset_to_dev {
    git restore package-lock.json
    git reset --hard
    git clean -df
    git checkout dev
    git pull
  }

  if $options.npm_install {
    try { npm install out+err> /dev/null }
    git restore package-lock.json
  }

  if $options.npm_link and ($repo.woop_packages | length) > 0 {
    try { npm link ...$repo.woop_packages }
  } else if $options.latest and ($repo.woop_packages | length) > 0 {
    try { npm install ...($repo.woop_packages | each { |p| $"($p)@latest" }) }
  }

  if $options.npm_audit {
    try { npm audit }
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
