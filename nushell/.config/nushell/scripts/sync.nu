const DIR = (path self | path dirname)

const YT_DLP_FORMAT = ([
  "bv*[height<=2160][vcodec^=avc1]+ba"
  "bv*[height<=2160][vcodec^=avc]+ba"
  "bv*[height<=2160][vcodec!*=av01]+ba"
  "b[height<=2160]"
] | str join "/")

def load-groups [config_path: string] {
  let raw = open $config_path

  if ($raw | is-empty) {
    []
  } else if ("channels" in ($raw | first | columns)) {
    $raw
  } else {
    # Legacy flat list of channels
    [{name: "default", config: {}, args: [], channels: $raw}]
  }
}

export def download [
  --config (-f): string  # Path to config file
  --cookies-from-browser (-b): string  # Browser to extract cookies from
  --cookies (-c): string  # Path to cookies file
  --dry-run (-d)  # Show what would be downloaded without downloading
  --filter-group (-g): string  # Specific group name(s) to sync, comma-separated
  --filter-channel (-l): string  # Specific channel name(s) to download, comma-separated
  --no-break-on-existing  # Don't stop when reaching existing videos
] {
  # Default to sync.nuon in the same directory as this script
  let config_path = if ($config | is-empty) {
    $DIR | path join "sync.nuon"
  } else {
    $config
  }

  let all_groups = load-groups $config_path

  # Filter to specific groups if requested (supports comma-separated list)
  let groups = if ($filter_group | is-not-empty) {
    let group_filters = ($filter_group | split row "," | each { |g| $g | str trim })
    $all_groups | where {|g|
      $group_filters | any {|filter| $g.name =~ $"\(?i\)($filter)"}
    }
  } else {
    $all_groups
  }

  if ($groups | is-empty) {
    if ($filter_group | is-not-empty) {
      print $"[err] No groups matching '($filter_group)' found in config"
    } else {
      print "No groups found in config"
    }
    return
  }

  let cli_cookies_given = ($cookies_from_browser | is-not-empty) or ($cookies | is-not-empty)

  for group in $groups {
    let group_config = ($group | get -o config | default {})
    let group_args = ($group | get -o args | default [])
    let staging = ($group_config | get -o staging)

    let eff_cookies_from_browser = if $cli_cookies_given {
      $cookies_from_browser
    } else {
      $group_config | get -o cookies_from_browser
    }
    let eff_cookies = if $cli_cookies_given {
      $cookies
    } else {
      $group_config | get -o cookies
    }

    # Filter to specific channels if requested (supports comma-separated list)
    let all_channels = ($group | get -o channels | default [])
    let channels = if ($filter_channel | is-not-empty) {
      let channel_filters = ($filter_channel | split row "," | each { |c| $c | str trim })
      $all_channels | where {|ch|
        $channel_filters | any {|filter| $ch.name =~ $"\(?i\)($filter)"}
      }
    } else {
      $all_channels
    }

    if ($channels | is-empty) {
      # Skip groups silently when a channel filter matched nothing in them
      if ($filter_channel | is-empty) {
        print $"\n=== Group: ($group.name) — no channels configured, skipping ==="
      }
      continue
    }

    print $"\n=== Group: ($group.name) — syncing ($channels | length) channel\(s\) ==="
    if ($eff_cookies | is-not-empty) {
      print $"  Cookies file: ($eff_cookies)"
    } else if ($eff_cookies_from_browser | is-not-empty) {
      print $"  Cookies from browser: ($eff_cookies_from_browser)"
    }
    if ($staging | is-not-empty) {
      print $"  Staging directory: ($staging)"
    }
    if ($group_args | is-not-empty) {
      print $"  Extra yt-dlp args: ($group_args | str join ' ')"
    }

    for channel in $channels {
      print $"\n--- Syncing: ($channel.name) ---"
      print $"  URL: ($channel.url)"
      print $"  Path: ($channel.path)"

      # Ensure directory exists
      mkdir ($channel.path | path expand)

      # Get the latest video date already downloaded
      let existing_videos = (
        try {
          ls ($channel.path | path expand | path join "**" "*.mp4")
          | where type == file
          | get name
          | each { |f| $f | parse "{date}_{rest}" | get date.0? }
          | compact
          | sort
          | reverse
        } catch {
          [] # Return empty list if no files found
        }
      )

      # Determine the minimum date from config (optional `after` field)
      let config_after = if ($channel | get -o after | is-not-empty) {
        let raw = $channel.after | str replace -a "-" ""
        print $"  Config minimum date: ($channel.after)"
        $raw
      } else {
        null
      }

      let date_after = if ($existing_videos | is-empty) {
        if ($config_after | is-not-empty) {
          print "  No existing videos found, using config minimum date"
          $config_after
        } else {
          print "  No existing videos found, downloading all"
          "19700101"  # Download all videos if none exist
        }
      } else {
        let latest_date = $existing_videos | first
        let latest_yyyymmdd = $latest_date | str replace -a "-" ""
        print $"  Latest video date: ($latest_date)"
        # Use the later of the two dates (config minimum vs latest existing)
        if ($config_after | is-not-empty) and ($config_after | into int) > ($latest_yyyymmdd | into int) {
          print "  Using config minimum date (later than latest video)"
          $config_after
        } else {
          $latest_yyyymmdd
        }
      }

      print $"  Downloading videos after: ($date_after)"

      # Run yt-dlp
      try {
        process-video {
          url: $channel.url
          output_path: $channel.path
          date_after: $date_after
          cookies_from_browser: $eff_cookies_from_browser
          cookies: $eff_cookies
          dry_run: $dry_run
          no_break_on_existing: $no_break_on_existing
          channel_name: $channel.name
          title_dir: true
          extra_args: $group_args
          staging: $staging
        }
        print $"[ok] Synced ($channel.name)"
      } catch { |err|
        # The debug field is a string, need to check if it contains exit_code: 101
        if ($err.debug | str contains "exit_code: 101") {
          print $"[ok] Synced ($channel.name) \(reached existing video\)"
        } else {
          print $"[err] Could not sync ($channel.name): ($err.msg)"
        }
      }
    }
  }

  print "\n=== Sync complete ==="
}

# Download one or more URLs
export def video [
  ...urls: string  # URL(s) of the video(s) to download
  --path (-p): string  # Directory to save the video to (defaults to current directory)
  --cookies-from-browser (-b): string  # Browser to extract cookies from (e.g., brave, chrome, firefox)
  --cookies (-c): string  # Path to cookies file
  --staging (-s): string  # Download to this local directory first, then move to --path
  --title-dir (-t) # Store videos in a subdirectory named after the video title
  --dry-run (-d)  # Show what would be downloaded without downloading
] {
  let target_path = if ($path | is-empty) { "." } else { $path }

  print $"Downloading ($urls | length) video\(s\) to: ($target_path)"

  # Maybe create target directory if it doesn't exist
  if $title_dir {
    mkdir ($target_path | path expand)
  }

  # Use date_after of "19700101" to download the video regardless of date
  let date_after = "19700101"

  for url in $urls {
    # Run yt-dlp for each video
    try {
      process-video {
        url: $url
        output_path: $target_path
        date_after: $date_after
        cookies_from_browser: $cookies_from_browser
        cookies: $cookies
        dry_run: $dry_run
        no_break_on_existing: true
        title_dir: $title_dir
        staging: $staging
      }
      print $"[ok] Downloaded video\(s\)"
    } catch { |err|
      print $"[err] Could not download video\(s\): ($err.msg)"
    }
  }
}

# List configured channels across all groups
export def list [
  --config (-f): string  # Path to config file (defaults to sync.nuon in script directory)
] {
  let config_path = if ($config | is-empty) {
    $DIR | path join "sync.nuon"
  } else {
    $config
  }

  if not ($config_path | path exists) {
    print "No configuration file found"
    return
  }

  load-groups $config_path
  | each {|g|
    $g.channels | each {|c|
      {
        group: $g.name
        name: $c.name
        url: $c.url
        path: $c.path
        after: ($c | get -o after)
      }
    }
  }
  | flatten
}


# Internal helper function to run yt-dlp with specified arguments
def process-video [options: record] {
  let url = $options.url
  let output_path = $options.output_path
  let date_after = $options.date_after
  let cookies_from_browser = $options.cookies_from_browser?
  let cookies = $options.cookies?
  let dry_run = $options.dry_run? | default false
  let no_break_on_existing = $options.no_break_on_existing? | default false
  let channel_name = $options.channel_name?
  let title_dir = $options.title_dir? | default false
  let extra_args = $options.extra_args? | default []
  let staging = $options.staging?

  # Templates must stay relative (yt-dlp ignores -P if -o is an absolute path)
  let video_template = if $title_dir {
    ["%(upload_date>%Y-%m-%d)s_%(title).200B" "%(title).200B_[%(id)s].%(ext)s"] | path join
  } else {
    "%(upload_date>%Y-%m-%d)s_%(title).200B_[%(id)s].%(ext)s"
  }

  let thumbnail_template = if $title_dir {
    ["%(upload_date>%Y-%m-%d)s_%(title).200B" "%(title).200B_[%(id)s]-thumb.%(ext)s"] | path join
  } else {
    "%(upload_date>%Y-%m-%d)s_%(title).200B_[%(id)s]-thumb.%(ext)s"
  }

  let path_args = if ($staging | is-not-empty) {
    mkdir ($staging | path expand)
    [-P $"home:($output_path | path expand)" -P $"temp:($staging | path expand)"]
  } else {
    [-P $"home:($output_path | path expand)"]
  }

  # Build yt-dlp arguments
  let base_args = [
    # Main video output
    -o $video_template
    --restrict-filenames  # Removes special characters, use underscores, etc.
    -f $YT_DLP_FORMAT

    # Only download videos after the latest one we have
    --dateafter $date_after

    # Don't write playlist metadata files
    --no-write-playlist-metafiles

    # Metadata mapping
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

    # Thumbnail in same directory as video
    -o (["thumbnail:" $thumbnail_template] | str join)
    --convert-thumbnails jpg

    --write-info-json
    --merge-output-format mp4
    --postprocessor-args "ffmpeg:-movflags +faststart"

    # Resume/failure handling
    --retries 5
    --fragment-retries 5
    --abort-on-unavailable-fragments

    # Use download archive to avoid re-downloading
    --download-archive ([$output_path ".downloaded"] | path join)
  ]

  # Add break-on-existing unless disabled
  let break_args = if $no_break_on_existing {
    []
  } else {
    [--break-on-existing]
  }

  let cookie_args = if ($cookies_from_browser | is-not-empty) {
    [--cookies-from-browser $cookies_from_browser]
  } else if ($cookies | is-not-empty) {
    [--cookies ($cookies | path expand)]
  } else {
    []
  }

  # Override artist/album with the config channel name if provided
  let channel_name_args = if ($channel_name | is-not-empty) {
    [--replace-in-metadata "meta_artist,meta_album" ".+" $channel_name]
  } else {
    []
  }

  let dry_run_args = if $dry_run {
    [--simulate --print "%(upload_date>%Y-%m-%d)s - %(title)s [%(id)s]"]
  } else {
    []
  }

  let all_args = ($base_args | append $path_args | append $channel_name_args | append $break_args | append $cookie_args | append $extra_args | append $dry_run_args | append $url)

  # Run yt-dlp
  yt-dlp ...$all_args
}
