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

# Download all images from a list of URLs to the current directory
def gdl [
  ...urls: string  # URL containing images to download
  --default-filename (-d)              # Ignore custom filename format and use the default
  --cookies-from-browser (-b): string  # Browser to extract cookies from (e.g., brave, chrome, firefox)
  --cookies (-C): string               # Path to cookies file
  --args (-a): list<string>            # Extra arguments to pass through to gallery-dl (e.g., --args [--no-mtime --retries 5])
] {
  let args = [
    "-D" "."
    "-c" $"($env.XDG_CONFIG_HOME)/gallery-dl/gallery-dl.conf"
    (if $default_filename { null } else { ["--filename" "{date:%Y-%m-%d}_{index}_{filename}.{extension}"] })
    (if $cookies_from_browser != null { ["--cookies-from-browser" $cookies_from_browser] } else { null })
    (if $cookies != null { ["--cookies" $cookies] } else { null })
    (if $args != null { $args } else { null })
  ]
  | flatten
  | compact

  gallery-dl ...$args ...$urls
}

# Create backup of file with timestamp
def bak [file: string] {
  let timestamp = (date now | format date "%Y%m%d_%H%M%S")
  cp $file $"($file).($timestamp).bak"
  print $"Backed up to ($file).($timestamp).bak"
}

# Compress files/directories into a tar.gz archive
def tarpls [
  output: string # Output archive filename (without .tar.gz extension)
  ...paths: string # Files or directories to compress
  --exclude-vendor (-e) # Exclude common vendor folders (node_modules, vendor, .git, etc.)
] {
  let tarfile = if ($output | str ends-with ".tar.gz") {
    $output
  } else if ($output | str ends-with ".tar") {
    $"($output).gz"
  } else {
    $"($output).tar.gz"
  }

  if ($paths | is-empty) {
    print "Error: No files or directories specified"
    return
  }

  # Convert paths to relative (strip current directory prefix)
  let cwd = ($env.PWD | path expand)
  let relative_paths = ($paths | each { |p|
    let expanded = ($p | path expand)
    if ($expanded | str starts-with $cwd) {
      $expanded | str replace $"($cwd)/" ""
    } else {
      $p
    }
  })

  # Common vendor/build folders to exclude
  let exclude_patterns = [
    "*.log"
    ".cargo"
    ".DS_Store"
    ".git"
    ".hg"
    ".idea"
    ".next"
    ".nuxt"
    ".pytest_cache"
    ".svn"
    ".venv"
    ".vscode"
    "__pycache__"
    "build"
    "dist"
    "node_modules"
    "target"
    "Thumbs.db"
    "vendor"
    "venv"
  ]

  if $exclude_vendor {
    let exclude_args = ($exclude_patterns | each { |pat| ["--exclude" $pat] } | flatten)
    tar -czf $tarfile ...$exclude_args ...$relative_paths
    print $"Created ($tarfile) (excluded vendor folders)"
  } else {
    tar -czf $tarfile ...$relative_paths
    print $"Created ($tarfile)"
  }
}

# Extract common archive formats
def extract [file: string] {
  match ($file | path parse | get extension) {
    "zip" => { unzip $file },
    "tar" => { tar -xf $file },
    "gz" => { tar -xzf $file },
    "bz2" => { tar -xjf $file },
    _ => { print "Unknown archive format" }
  }
}

# Amend last commit without editing message
def gca [] {
  git commit --amend --no-edit
}

# Undo last commit but keep changes staged
def gundo [] {
  git reset --soft HEAD~1
}

# Stop all processes by port
def killport [port: int] {
  let pid = (lsof -ti $":($port)")
  if ($pid | is-empty) {
    print $"No process found on port ($port)"
  } else {
    kill -9 $pid
    print $"Killed process ($pid) on port ($port)"
  }
}
