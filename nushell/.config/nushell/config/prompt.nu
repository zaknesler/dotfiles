def spacify [lines: list<string> sep: string = (char space)] {
    if ($lines | is-empty) { return "" }

    $lines | filter {|s| $s != ""} | str join $sep | str trim
}

export def create_left_prompt [] {
    let dir = match (do --ignore-shell-errors { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let path_color = if (is-admin) { ansi light_red } else { ansi deepskyblue2 }
    let separator_color = if (is-admin) { ansi red } else { ansi deepskyblue4b }
    let path_segment = $"($path_color)($dir)"

    let path = $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"

    let line = spacify [ $path (git_info) ]
    [ $line (char newline) (char newline) ] | str join
}

def git_info [] {
    # nu_plugin_gstat must be installed
    if (which gstat | is-empty) { return "" }
    if (gstat | get repo_name | is-empty) { return "" }

    def create-item [value: string items: list<string>] {
        match (gstat | get $value) {
            $value if $value > 0 => ([ ($items | str join) $value ] | str join)
            _ => ""
        }
    }

    let branch = match [ (gstat | get branch) (gstat | get tag) ] {
        [ $branch $tag ] if $branch != "no_branch" and $tag == "no_tag" => ([ (ansi seagreen3) $branch ] | str join)
        [ $branch $tag ] if $tag != "no_branch" and ($tag | is-not-empty) and $tag != "no_tag" => ([
                (ansi darkseagreen4a) "#"
                (ansi seagreen3) $branch
                (ansi darkseagreen4a) "@"
                (ansi seagreen3) $tag
            ] | str join)
        _ => ""
    }

    let items = spacify [
        $branch
        (create-item ahead [ (ansi yellow) (char upwards_arrow) ])
        (create-item behind [ (ansi yellow) (char downwards_arrow) ])
        (create-item wt_modified [ (ansi yellow) "!" ])
        (create-item wt_deleted [ (ansi yellow) "-" ])
        (create-item idx_modified_staged [ (ansi light_green) "+" ])
        (create-item idx_deleted_staged [ (ansi light_red) "-" ])
    ]

    match $items {
        $inner if ($inner | is-not-empty) => ([ (ansi darkseagreen4a) "[" $inner (ansi darkseagreen4a) "]" ] | str join)
        _ => ""
    }
}

export def create_right_prompt [] {
    let last_exit_code = match $env.LAST_EXIT_CODE {
        $code if $code != 0 => ([ (ansi rb) ($env.LAST_EXIT_CODE) ] | str join)
        _ => ""
    }

    let login = [ (whoami | str downcase) (sys | get host.hostname) ] | str join "@"
    let user = [ (ansi tan) $login ] | str join

    let type = match () {
        _ if ("/run/WSL" | path exists) => "wsl"
        _ if ($env | get -i SSH_TTY | is-not-empty) => "ssh"
        _ => ""
    }

    let session = match $type {
        $type if ($type | is-not-empty) => ([ (ansi lightslategrey) "[" (ansi lightslateblue) $type (ansi lightslategrey) "]" ] | str join)
        _ => ""
    }

    let time = [ (ansi white_dimmed) (date now | format date "%I:%M:%S %p") ]
        | str join
        | str replace --regex --all "([/:])" $"(ansi dark_gray_dimmed)${1}(ansi white_dimmed)"

    spacify [ $last_exit_code $user $session $time ] ([ (ansi reset) (char space) ] | str join)
}
