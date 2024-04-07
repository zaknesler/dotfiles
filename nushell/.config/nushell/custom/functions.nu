# Create a new directory and enter it
def mkd [dirname: string] {
    mkdir $dirname
    cd $dirname
}

# Initialize Git repository and create initial commit
def giic [] {
    git init
    git add .
    git commit -m "initial commit"
}

# Add all current changes and author new commit
def gac [] {
    alias gac = git add -A
    git commit -m
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

# Install Tailwind
def install [] {
    npm install -D tailwindcss@latest postcss@latest autoprefixer@latest
    npx tailwindcss init -p
}

# Create private GitHub repository in current directory
def ghcr [repo: string] {
    git init
    gh repo create $repo --private --source=. --remote=upstream
    git remote add origin $"git@github.com:zaknesler/($repo).git"
}
