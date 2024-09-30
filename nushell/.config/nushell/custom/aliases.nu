alias s- = su -

alias dot = cd ($env.XDG_CONFIG_HOME | path join "dotfiles")
alias dt = cd ($env.HOME | path join "desktop")

alias nv = nvim
alias v = nvim
alias vi = nvim
alias vim = nvim

alias la = ls -a
alias ll = ls -al

alias gaa = git add -A
alias gb = git branch
alias gc = git commit -m
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

alias c = cargo

alias n = npm
alias ni = npm install
alias no = npm outdated
alias nr = npm run
alias nt = npm test
alias nrb = npm run build
alias nrd = npm run dev
alias nrs = npm run start
alias nrt = npm run test

alias pn = pnpm
alias pni = pnpm install
alias pno = pnpm outdated
alias pnr = pnpm run
alias pnrb = pnpm run build
alias pnrd = pnpm run dev
alias pnrs = pnpm run start
alias pnrt = pnpm run test

alias dr = docker
alias drc = docker compose
alias drcb = docker compose build
alias drcd = docker compose down
alias drce = docker compose exec
alias drcr = docker compose run --rm
alias drcu = docker compose up -d
alias dr-clean = docker rmi \`docker images -f 'dangling=true' -q\` --force

alias pip = pip3
alias py = python3
alias python = python3

alias catssh = cat ~/.ssh/id_*.pub
alias own = sudo chown -R ([$env.USER $env.USER] | str join ":")
alias c~ = rm -rf ~/.aws ~/.azure ~/.yarnrc ~/errors.log ~/.sudo_as_admin_successful ~/.wget-hsts ~/.python_history ~/.tailwindcss ~/.omnisharp ~/.nuxtrc ~/.electron ~/.vue-templates ~/.dotnet ~/.racket_history

alias o = open
alias e = explorer

alias units = units --history ($env.XDG_CACHE_HOME | path join "units_history")
alias wget = wget --hsts-file ($env.XDG_CACHE_HOME | path join "wget-hsts")
alias yarn = yarn --use-yarnrc ($env.XDG_CONFIG_HOME | path join "yarn" "config")

alias egrep = egrep --color=auto
alias fgrep = fgrep --color=auto
alias grep = grep --color=auto
