{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    starship
  ];

  system.activationScripts.starshipConfig = ''
    mkdir -p /root/.config

    cat > /root/.config/starship.toml << 'EOF'
    add_newline = true
    format = "[╭──╼](bold blue) $hostname $os\n[┆](bold blue) $directory$git_branch$git_commit$git_state$git_metrics$git_status$nix_shell\n[╰─>](bold blue) $character\n"
    palette = "base16"

    [character]
    disabled = false
    error_symbol = "[✗](bold red) "
    format = "$symbol"
    success_symbol = "[❯](bold green)"

    [cmd_duration]
    disabled = false
    format = "was [$duration](bold green)"
    min_time = 250
    show_milliseconds = false
    show_notifications = false

    [hostname]
    disabled = false
    format = "[$hostname]($style)"
    ssh_only = false
    style = "bold red"

    [nix_shell]
    disabled = false
    format = "[   ](fg:blue bold)"
    heuristic = false
    impure_msg = ""
    pure_msg = ""
    unknown_msg = ""

    [os]
    disabled = false
    format = "on [($name $codename$version $symbol )]($style)"
    style = "bold blue"

    [time]
    disabled = false
    format = " [$time]($style)"
    style = "pale blue"
    time_format = "%H:%M"
    utc_time_offset = "local"

    [palettes.base16]
    base00 = "#1d2021"
    base01 = "#3c3836"
    base02 = "#504945"
    base03 = "#665c54"
    base04 = "#bdae93"
    base05 = "#d5c4a1"
    base06 = "#ebdbb2"
    base07 = "#fbf1c7"
    base08 = "#fb4934"
    base09 = "#fe8019"
    base0A = "#fabd2f"
    base0B = "#b8bb26"
    base0C = "#8ec07c"
    base0D = "#83a598"
    base0E = "#d3869b"
    base0F = "#d65d0e"
    base10 = "#1d2021"
    base11 = "#1d2021"
    base12 = "#fb4934"
    base13 = "#fabd2f"
    base14 = "#b8bb26"
    base15 = "#8ec07c"
    base16 = "#83a598"
    base17 = "#d3869b"
    black = "#1d2021"
    blue = "#83a598"
    bright-black = "#665c54"
    bright-blue = "#83a598"
    bright-cyan = "#8ec07c"
    bright-green = "#b8bb26"
    bright-magenta = "#d3869b"
    bright-purple = "#d3869b"
    bright-red = "#fb4934"
    bright-white = "#fbf1c7"
    bright-yellow = "#fabd2f"
    brown = "#d65d0e"
    cyan = "#8ec07c"
    green = "#b8bb26"
    magenta = "#d3869b"
    orange = "#fe8019"
    purple = "#d3869b"
    red = "#fb4934"
    white = "#d5c4a1"
    yellow = "#fabd2f"
    EOF

    chown root:root /root/.config/starship.toml
    chmod 644 /root/.config/starship.toml
  '';
}
