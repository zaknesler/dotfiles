alias s- = su -

# Dirs
alias dot = cd ($env.XDG_CONFIG_HOME | path join "dotfiles")
alias dt = cd ($env.HOME | path join "desktop")
alias co = cd ($env.HOME | path join "code")
alias s = start

# Neovim
alias nv = nvim
alias v = nvim
alias vi = nvim
alias vim = nvim

# ls
alias l = ls -a
alias la = ls -a
def ll [] { ls -la | reject inode num_links readonly target }
alias lll = ls -la

# Git
alias gaa = git add -A
alias gb = git branch
alias gc = git commit -m
alias gca = git commit --amend --no-edit
alias gco = git checkout
alias gcob = git checkout -b
alias gcom = git checkout main
alias gd = git diff
alias gf = git fetch
alias gi = git init
let glgfmt = "--pretty=format:%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)%an%Creset"
alias glg = git log --graph $glgfmt --abbrev-commit
alias glgr = git log --reverse $glgfmt --abbrev-commit
alias gpl = git pull
alias gpsh = git push
alias grao = git remote add origin
alias gs = git status
alias gsh = git stash -u
alias gshp = git stash pop
alias gshl = git stash list
alias gshs = git stash show -p
alias gshd = git stash drop
alias gsmu = git submodule update --init --recursive --remote
alias gundo = git reset --soft HEAD~1

# Rust
alias c = cargo

# npm/pnpm
alias n = npm
alias ni = npm install
alias no = npm outdated
alias nr = npm run
alias nrb = npm run build
alias nrd = npm run dev
alias nrs = npm run start
alias nrp = npm run preview
alias nrt = npm run test
alias pn = pnpm
alias pni = pnpm install
alias pno = pnpm outdated
alias pnr = pnpm run
alias pnrb = pnpm run build
alias pnrd = pnpm run dev
alias pnrs = pnpm run start
alias pnrp = pnpm run preview
alias pnrt = pnpm run test

# Docker
alias dr = docker
alias drc = docker-compose
alias drcb = docker-compose build
alias drcd = docker-compose down
alias drce = docker-compose exec
alias drcr = docker-compose run --rm
alias drcu = docker-compose up -d
alias dr-clean = docker rmi \`docker images -f 'dangling=true' -q\` --force

# Python
alias pip = pip3
alias py = python3
alias python = python3

# Misc
alias own = sudo chown -R ([$env.USER $env.USER] | str join ":")
alias c~ = rm -rf ~/.aws ~/.azure ~/.yarnrc ~/errors.log ~/.sudo_as_admin_successful ~/.wget-hsts ~/.python_history ~/.tailwindcss ~/.omnisharp ~/.nuxtrc ~/.electron ~/.vue-templates ~/.dotnet ~/.racket_history

alias units = units --history ($env.XDG_CACHE_HOME | path join "units_history")
alias wget = wget --hsts-file ($env.XDG_CACHE_HOME | path join "wget-hsts")
alias yarn = yarn --use-yarnrc ($env.XDG_CONFIG_HOME | path join "yarn" "config")

alias egrep = egrep --color=auto
alias fgrep = fgrep --color=auto
alias grep = grep --color=auto
