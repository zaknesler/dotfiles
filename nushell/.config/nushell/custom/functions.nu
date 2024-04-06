# Create a new directory and enter it
def mkd [dirname] {
    mkdir $dirname
    cd $dirname
}

# Initialize Git repository and create initial commit
def giic [] {
    git init
    git add .
    git commit -m "initial commit"
}

# Install Tailwind
def install [] {
    npm install -D tailwindcss@latest postcss@latest autoprefixer@latest
    npx tailwindcss init -p
}

# Create private GitHub repository in current directory
def ghcr [repo] {
    git init
    gh repo create $repo --private --source=. --remote=upstream
    git remote add origin "git@github.com:zaknesler/$1.git"
}
