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

# Install Tailwind, PostCSS, and Autoprefixer
def install-tw [] {
  pnpm install -D tailwindcss@latest postcss@latest autoprefixer@latest
  npx tailwindcss init -p
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

# Reset all changes, git checkout to dev, pull new changes, and re-install npm deps
def reset-to-dev [] {
  git reset --hard
  git clean -df
  gco dev
  gpl
  npm i
}

# Download all images from a URL to the current directory
def gdl [
  url: string # URL containing images to download
  --default-filename (-d) # Ignore custom filename format and use the default
] {
  if ($default_filename) {
    # Use gallery-dl with default filename handling
    gallery-dl -D . $url
  } else {
    # Use custom filename format
    gallery-dl -D . --filename "{date:%Y-%m-%d}_{index}_{filename}.{extension}" $url
  }
}

def yt-dl-plex [
  url: string  # URL to download
  --cookies-from-browser (-b): string  # Browser to extract cookies from (e.g., brave, chrome, firefox)
  --cookies (-c): string  # Path to cookies file
] {
  let args = [
    -o "%(upload_date>%Y-%m-%d)s %(title)s/%(title)s [%(id)s].%(ext)s"
    -f "bv*[height<=1080]+ba/b[height<=1080]"
    --parse-metadata "title:(?P<meta_title>.+)"
    --parse-metadata "uploader:(?P<meta_artist>.+)"
    --parse-metadata "uploader:(?P<meta_album>.+)"
    --parse-metadata "%(upload_date>%Y-%m-%d)s:(?P<meta_date>.+)"
    --parse-metadata "description:(?s)(?P<meta_description>.+)"
    --parse-metadata "description:(?s)(?P<meta_synopsis>.+)"
    --parse-metadata "description:(?s)(?P<meta_comment>.+)"
    --parse-metadata "webpage_url:(?P<meta_comment>.+)"
    --parse-metadata ":(?P<meta_genre>)YouTube"
    --embed-metadata
    --embed-chapters
    --embed-thumbnail
    --write-thumbnail
    -o "thumbnail:%(upload_date>%Y-%m-%d)s %(title)s/%(title)s [%(id)s]-thumb.%(ext)s"
    --convert-thumbnails jpg
    --write-info-json
    --merge-output-format mp4
    --postprocessor-args "ffmpeg:-movflags +faststart"
  ]

  let cookie_args = if ($cookies_from_browser | is-not-empty) {
    [--cookies-from-browser $cookies_from_browser]
  } else if ($cookies | is-not-empty) {
    [--cookies $cookies]
  } else {
    []
  }

  yt-dlp ...($args | append $cookie_args | append $url)
}
