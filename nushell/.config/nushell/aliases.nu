
alias s- = su -l" # Always use login shell for s
alias sudo = sudo " # Enable alias expansion for sud

# Directory Shortcuts
alias dot = cd $"($env.XDG_CONFIG_HOME)/dotfiles"

# Vim
alias nv = nvim
alias v = nvim
alias vi = nvim
alias vim = nvim

# Git
alias gaa = git add -A
alias gac = git add -A and git commit -m
alias gb = git branch
alias gc = git commit -m
alias gco = git checkout
alias gcob = git checkout -b
alias gcom = git checkout main
alias gd = git diff
alias gf = git fetch
alias gi = git init
let glgfmt = "--pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)%an%Creset'"
alias glg = git log --graph $glgfmt --abbrev-commit
alias glgr = git log --reverse $glgfmt --abbrev-commit
alias gpl = git pull
alias gpsh = git push
alias grao = git remote add origin
alias gs = git status
alias gsh = git stash -u
alias gshp = git stash pop
alias nah = git reset --hard and git clean -df
alias wip = git add . and git commit -m 'wip' -q

# Rust
alias c = cargo

# NPM
alias n = npm
alias ni = npm install
alias no = npm outdated
alias nr = npm run
alias nrb = npm run build
alias nrd = npm run dev
alias nrs = npm run start
alias nrt = npm run test

# PNPM
alias pn = pnpm
alias pni = pnpm install
alias pno = pnpm outdated
alias pnr = pnpm run
alias pnrb = pnpm run build
alias pnrd = pnpm run dev
alias pnrs = pnpm run start
alias pnrt = pnpm run test

# Docker
alias dr = docker
alias drc = docker compose
alias drcb = docker compose build
alias drcd = docker compose down
alias drce = docker compose exec
alias drcr = docker compose run --rm
alias drcu = docker compose up -d
alias dr-clean = docker rmi \`docker images -f 'dangling=true' -q\` --force

# Python
alias pip = pip3
alias py = python3
alias python = python3

# Utilities
alias catssh = cat ~/.ssh/id_rsa.pub
alias own = sudo chown -R "$USER:$USER"
alias c~ = rm -rf ~/.aws ~/.azure ~/.yarnrc ~/errors.log ~/.sudo_as_admin_successful ~/.wget-hsts ~/.python_history ~/.tailwindcss ~/.omnisharp ~/.nuxtrc ~/.electron ~/.vue-templates ~/.dotnet ~/.racket_history

# Other
alias c. = code .
alias o. = o .
alias o = open

# XDG overrides
alias units = units --history $"($env.XDG_CACHE_HOME)/units_history"
alias wget = wget --hsts-file $"($env.XDG_CACHE_HOME)/wget-hsts"
alias yarn = yarn --use-yarnrc $"($env.XDG_CONFIG_HOME)/yarn/config"

# Always enable colored `grep` output
alias egrep = egrep --color=auto
alias fgrep = fgrep --color=auto
alias grep = grep --color=auto
