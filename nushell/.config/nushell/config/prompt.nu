export def create_left_prompt [] {
    let dir = match (do --ignore-shell-errors { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

export def create_right_prompt [] {
    let sep = ([ (ansi reset) (char space) ] | str join)

    let last_exit_code = match $env.LAST_EXIT_CODE {
        $code if $code != 0 => ([ (ansi rb) ($env.LAST_EXIT_CODE) ] | str join)
        _ => ""
    }

    let time = (
        [ (ansi white_dimmed) (date now | format date "%I:%M:%S %p") ]
        | str join
        | str replace --regex --all "([/:])" $"(ansi dark_gray_dimmed)${1}(ansi white_dimmed)"
    )

    let git_branch = match (gstat | get branch) {
        $branch if $branch != "no_branch" => ([ (ansi seagreen2) $branch ] | str join)
        _ => ""
    }

    let git_modified = match (gstat | get wt_modified) {
        $modified if $modified > 0 => ([ (ansi yellow) "!" $modified ] | str join)
        _ => ""
    }

    let git_inner = [ $git_branch $git_modified ] | filter {|s| $s != ""} | str join " " | str trim
    let git = if $git_inner != "" { ([ (ansi darkseagreen4a) "[" $git_inner (ansi darkseagreen4a) "]" ] | str join) } else { "" }

    let login = ([ (whoami | str downcase) (sys | get host.hostname) ] | str join "@")
    let user = ([ (ansi tan) $login ] | str join)

    ([ (ansi reset) $git $user $last_exit_code $time (ansi reset) ] | filter {|s| $s != ""} | str join $sep | str trim)
}
