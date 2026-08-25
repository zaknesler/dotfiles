const DIR = (path self | path dirname)

# Get current branch status for project repos
export def main [
  --npm-install   # Install NPM dependencies after fetching repo
  --reset-to-dev  # Reset to dev on all repos
  --npm-audit     # Run NPM audit
  --npm-audit-fix # Run NPM audit
  --npm-link      # Run NPM link for dependencies
  --latest        # Update to latest internal packages
  --sequential    # Run sequentially instead of in parallel
] {
  let repos = open ($DIR | path join "branches.nuon")

  let options = {
    npm_install: $npm_install,
    reset_to_dev: $reset_to_dev,
    npm_audit: $npm_audit,
    npm_audit_fix: $npm_audit_fix,
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

  if $options.npm_link and ($repo.packages | length) > 0 {
    try { npm link ...$repo.packages }
  } else if $options.latest and ($repo.packages | length) > 0 {
    try { npm install ...($repo.packages | each { |p| $"($p)@latest" }) }
  }

  if $options.npm_audit {
    try { npm audit }
  } else if $options.npm_audit_fix {
    try { npm audit fix }
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
    stashes: ($git | get stashes),
  }
}
