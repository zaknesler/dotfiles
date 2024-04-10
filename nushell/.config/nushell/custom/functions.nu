# Create a new directory and enter it
def --env mkcd [dirname: string]: nothing -> nothing {
    mkdir $dirname
    cd $dirname
}

# Initialize Git repository and create initial commit
def giic [] {
    git init
    git add .
    git commit -m "initial commit"
}

# Add all changes and create "wip" commit
def wip [] {
    git add -A
    git commit -m 'wip' -q
}

# Discard all git changes
def nah [] {
    git reset --hard
    git clean -df
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
def ntt [path: string name: string] {
    npm test $path -- -t $name
}
