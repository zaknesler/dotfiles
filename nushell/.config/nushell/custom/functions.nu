# Initialize the current directory with .envrc and allow it
def --env load-direnv [] {
  if not (".envrc" | path exists) {
    "dotenv" | save .envrc
    print "Created .envrc"
  }

  direnv allow .
  direnv export json | from json | default {} | load-env
}

# Create a new directory and enter it
def --env mkcd [dirname: string]: nothing -> nothing {
  mkdir $dirname
  cd $dirname
}

# Initialize Git repository and create initial commit
def gii [] {
  git init
  git add -A
  git commit -m "initial"
}

# Add all changes and create "wip" commit
def wip [] {
  git add -A
  git commit -m 'wip' -q
}

# Discard all git changes
def nah [
  --yes (-y) # Accept yes/no prompt
] {
  if $yes or (input "you sure? (y/n): ") == "y"  {
    git reset --hard
    git clean -df
  }
}

# Initialize and create a private GitHub repository
def ghcr [repo: string] {
  git init
  gh repo create $repo --private --source=. --remote=upstream
  git remote add origin $"git@github.com:zaknesler/($repo).git"
}

# Run npm test filtering by test path and name
def ntt [
  path: string = ""
  name: string = ""
] {
  npm test $path -- -t $name
}

# Run pnpm test filtering by test path and name
def pntt [
  path: string = ""
  name: string = ""
] {
  pnpm test $path -- -t $name
}

# Reset all changes, git checkout to dev, pull new changes, and re-install npm deps
def reset-to-dev [] {
  git reset --hard
  git clean -df
  gco dev
  gpl
  npm i
}

# Get public IP address and location info
def myip [] {
  curl -s https://ipv4.wtfismyip.com/json
    | from json
    | transpose key value
    | update key { str replace "YourFucking" "" | str snake-case }
    | transpose --header-row
    | into record
}

# Download all images from a URL to the current directory
def gdl [
  ...urls: string # URL containing images to download
  --default-filename (-d) # Ignore custom filename format and use the default
] {
  if ($default_filename) {
    # Use gallery-dl with default filename handling
    gallery-dl -D . ...$urls
  } else {
    # Use custom filename format
    gallery-dl -D . --filename "{date:%Y-%m-%d}_{index}_{filename}.{extension}" ...$urls
  }
}
