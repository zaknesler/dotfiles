# Nushell Environment Config File
# version = "0.91.0"

# Ensure XDG variables are set
$env.XDG_CACHE_HOME = ($env.HOME | path join ".cache")
$env.XDG_CONFIG_HOME = ($env.HOME | path join ".config")
$env.XDG_DATA_HOME = ($env.HOME | path join ".local" "share")
$env.XDG_RUNTIME_DIR = ($env.XDG_CACHE_HOME | path join "runtime")

use ($nu.default-config-dir | path join 'config' 'prompt.nu') [create_left_prompt, create_right_prompt]

$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins')
]

# XDG Supported Directories
$env.CARGO_HOME = ($env.XDG_DATA_HOME | path join "cargo")
$env.CONDARC = ($env.XDG_CONFIG_HOME | path join "conda" "condarc")
$env.CUDA_CACHE_PATH = ($env.XDG_CACHE_HOME | path join "nv")
$env.DOCKER_CONFIG = ($env.XDG_CONFIG_HOME | path join "docker")
$env.GNUPGHOME = ($env.XDG_DATA_HOME | path join "gnupg")
$env.NPM_CONFIG_USERCONFIG = ($env.XDG_CONFIG_HOME | path join "npm" "npmrc")
$env.NVM_DIR = ($env.XDG_DATA_HOME | path join "nvm")
$env.PLTUSERHOME = ($env.XDG_DATA_HOME | path join "racket")
$env.PM2_HOME = ($env.XDG_CONFIG_HOME | path join "pm2")
$env.RUSTUP_HOME = ($env.XDG_DATA_HOME | path join "rustup")
$env.WGETRC = ($env.XDG_CONFIG_HOME | path join "wgetrc")
$env.BUNDLE_USER_CONFIG = ($env.XDG_CONFIG_HOME | path join "bundle")
$env.BUNDLE_USER_CACHE = ($env.XDG_CACHE_HOME | path join "bundle")
$env.BUNDLE_USER_PLUGIN = ($env.XDG_DATA_HOME | path join "bundle")
$env.NUGET_PACKAGES = ($env.XDG_CACHE_HOME | path join "NuGetPackages")
$env.GEM_HOME = ($env.XDG_DATA_HOME | path join "gem")
$env.GEM_SPEC_CACHE = ($env.XDG_CACHE_HOME | path join "gem")
$env.IPYTHONDIR = ($env.XDG_CONFIG_HOME | path join "jupyter")
$env.JUPYTER_CONFIG_DIR = ($env.XDG_CONFIG_HOME | path join "jupyter")
$env.TEXMFHOME = ($env.XDG_DATA_HOME | path join "texmf")
$env.TEXMFVAR = ($env.XDG_CACHE_HOME | path join "texlive" "texmf-var")
$env.TEXMFCONFIG = ($env.XDG_CONFIG_HOME | path join "texlive" "texmf-config")

$env.EDITOR = "nvim"

# NVM
$env.NVM_AUTO_USE = true

# PNPM
$env.PNPM_HOME = ($env.XDG_DATA_HOME | path join "pnpm")

# Node REPL
$env.NODE_REPL_HISTORY = ($env.XDG_DATA_HOME | path join "node_repl_history")
$env.NODE_REPL_HISTORY_SIZE = "32768"
$env.NODE_REPL_MODE = "sloppy"

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr
$env.PYTHONIOENCODING = "UTF-8"

# Highlight section titles in manual pages
$env.LESS_TERMCAP_md = "${yellow}"

# Do not use a less history file
$env.LESSHISTFILE = "-"

# Don’t clear the screen after quitting a manual page
$env.MANPAGER = "less -X"

# Avoid issues with `gpg` as installed via Homebrew
# https://stackoverflow.com/a/42265848/96656
$env.GPG_TTY = (is-terminal --stdin)

# Path configuration
use std "path add"

path add $env.PNPM_HOME --append

if not ($env | get GOPATH -i | is-empty) {
    path add ($env.GOPATH | path join "bin") --append
}

if not ($env | get GOROOT -i | is-empty) {
    path add ($env.GOROOT | path join "bin") --append
}

# Mac OS
if (sys | get host.name) == "Darwin" {
    path add ($env.HOME | path join "Library/Python/3.9/bin")
    path add "/usr/local/opt/coreutils/libexec/gnubin" --append
    path add "/usr/local/opt/openjdk/bin" --append
    path add "/opt/homebrew/bin" --append

    $env.JAVA_HOME = "/usr/local/opt/openjdk/libexec/openjdk.jdk/Contents/Home"
    $env.JDK_HOME = "/usr/local/opt/openjdk/libexec/openjdk.jdk/Contents/Home"
}

# Linux
if (sys | get host.name) == "Debian GNU/Linux" {
    $env.JAVA_HOME = "/usr/lib/jvm/default-java"
    $env.CLASSPATH = "/usr/share/java/gtk.jar:."
}

# Unix-like
if (sys | get host.name) in ["Darwin", "Debian GNU/Linux"] {
    path add "/usr/local/bin"
    path add "/usr/local/go/bin"
    path add ($env.HOME | path join ".local" "share" "npm" "bin")
    path add ($env.HOME | path join ".local" "share" "bob" "nvim-bin")
    path add ($env.HOME | path join ".local" "bin")
    path add ($env.HOME | path join ".bun" "bin")
    path add ($env.XDG_DATA_HOME | path join "cargo" "bin")
    path add $env.XDG_DATA_HOME
}
