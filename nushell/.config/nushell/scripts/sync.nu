const DIR = (path self | path dirname)

export def download [
  --config (-f): string  # Path to config file (defaults to sync.nuon in script directory)
  --cookies-from-browser (-b): string  # Browser to extract cookies from (e.g., brave, chrome, firefox)
  --cookies (-c): string  # Path to cookies file
  --dry-run (-d)  # Show what would be downloaded without downloading
] {
  # Default to sync.nuon in the same directory as this script
  let config_path = if ($config | is-empty) {
    $DIR | path join "sync.nuon"
  } else {
    $config
  }

  # Load channel configuration
  let channels = open $config_path

  print $"Syncing ($channels | length) channels..."

  for channel in $channels {
    print $"\n=== Syncing: ($channel.name) ==="
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
        | each { |f|
            # Extract date from filename YYYY-MM-DD
            $f | parse "{date}_{rest}" | get date.0?
          }
        | compact
        | sort
        | reverse
      } catch {
        []  # Return empty list if no files found
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
      print "  Latest video date: ($latest_date)"
      # Use the later of the two dates (config minimum vs latest existing)
      if ($config_after | is-not-empty) and ($config_after | into int) > ($latest_yyyymmdd | into int) {
        print "  Using config minimum date (later than latest video)"
        $config_after
      } else {
        $latest_yyyymmdd
      }
    }

    print $"  Downloading videos after: ($date_after)"

    # Build yt-dlp arguments
    let base_args = [
      # Main video output
      -o ([$channel.path "%(upload_date>%Y-%m-%d)s_%(title).200B" "%(title).200B_[%(id)s].%(ext)s"] | path join)
      --restrict-filenames  # Removes special characters, use underscores, etc.
      -f "bv*[height<=1080]+ba/b[height<=1080]"

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
      -o (["thumbnail:" ([$channel.path "%(upload_date>%Y-%m-%d)s_%(title).200B" "%(title).200B_[%(id)s]-thumb.%(ext)s"] | path join)] | str join)
      --convert-thumbnails jpg

      --write-info-json
      --merge-output-format mp4
      --postprocessor-args "ffmpeg:-movflags +faststart"

      # Use download archive to avoid re-downloading
      --download-archive ([$channel.path ".downloaded"] | path join)
    ]

    let cookie_args = if ($cookies_from_browser | is-not-empty) {
      [--cookies-from-browser $cookies_from_browser]
    } else if ($cookies | is-not-empty) {
      [--cookies $cookies]
    } else {
      []
    }

    let dry_run_args = if $dry_run {
      [--simulate --print "%(upload_date>%Y-%m-%d)s - %(title)s [%(id)s]"]
    } else {
      []
    }

    let all_args = ($base_args | append $cookie_args | append $dry_run_args | append $channel.url)

    # Run yt-dlp
    try {
      yt-dlp ...$all_args
      print $"✓ Synced ($channel.name)"
    } catch { |err|
      print $"✗ Failed to sync ($channel.name): ($err.msg)"
    }
  }

  print "\n=== Sync complete ==="
}

# Helper command to add a new channel
export def add [
  url: string
  path: string
  name: string
  --config (-f): string  # Path to config file (defaults to sync.nuon in script directory)
  --after (-a): string  # Minimum date to download from (YYYY-MM-DD)
] {
  let config_path = if ($config | is-empty) {
    $DIR | path join "sync.nuon"
  } else {
    $config
  }

  let channels = if ($config_path | path exists) {
    open $config_path
  } else {
    []
  }

  let new_channel = {url: $url, path: $path, name: $name, after: (if ($after | is-not-empty) { $after } else { null })}
  let updated = ($channels | append $new_channel)

  $updated | save -f $config_path
  print $"Added channel: ($name)"
}

# Helper command to list configured channels
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

  open $config_path | table
}
