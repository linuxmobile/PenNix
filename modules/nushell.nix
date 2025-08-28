{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nushell
    carapace
    starship
    helix
    bat
    eza
    ripgrep
    fd
    skim
    yazi
    wl-clipboard
    zoxide
  ];

  users.users.root.shell = pkgs.nushell;

  system.activationScripts.nushellConfig = ''
    mkdir -p /root/.config/nushell

    cat > /root/.config/nushell/env.nu << 'EOF'
    load-env {
      "CARAPACE_BRIDGES": "inshellisense,carapace,zsh,fish,bash"
      "EDITOR": "hx"
      "NIXPKGS_ALLOW_INSECURE": "1"
      "NIXPKGS_ALLOW_UNFREE": "1"
      "PROMPT_COMMAND": ""
      "PROMPT_COMMAND_RIGHT": ""
      "PROMPT_INDICATOR_VI_INSERT": "  "
      "PROMPT_INDICATOR_VI_NORMAL": "∙ "
      "SHELL": "${pkgs.nushell}/bin/nu"
      "VISUAL": "hx"
    }

    $env.config.color_config = {
      separator: "#665c54"
      leading_trailing_space_bg: "#bdae93"
      header: "#b8bb26"
      date: "#d3869b"
      filesize: "#83a598"
      row_index: "#8ec07c"
      bool: "#fb4934"
      int: "#b8bb26"
      duration: "#fb4934"
      range: "#fb4934"
      float: "#fb4934"
      string: "#bdae93"
      nothing: "#fb4934"
      binary: "#fb4934"
      cellpath: "#fb4934"
      hints: dark_gray

      shape_garbage: { fg: "#fbf1c7" bg: "#fb4934" }
      shape_bool: "#83a598"
      shape_int: { fg: "#d3869b" attr: b }
      shape_float: { fg: "#d3869b" attr: b }
      shape_range: { fg: "#fabd2f" attr: b }
      shape_internalcall: { fg: "#8ec07c" attr: b }
      shape_external: "#8ec07c"
      shape_externalarg: { fg: "#b8bb26" attr: b }
      shape_literal: "#83a598"
      shape_operator: "#fabd2f"
      shape_signature: { fg: "#b8bb26" attr: b }
      shape_string: "#b8bb26"
      shape_filepath: "#83a598"
      shape_globpattern: { fg: "#83a598" attr: b }
      shape_variable: "#d3869b"
      shape_flag: { fg: "#83a598" attr: b }
      shape_custom: { attr: b }
    }
    EOF

    cat > /root/.config/nushell/config.nu << 'EOF'
    $env.config = {
      "bracketed_paste": true
      "buffer_editor": "hx"
      "cursor_shape": {
        "vi_insert": "line"
        "vi_normal": "block"
      }
      "display_errors": {
        "exit_code": false
        "termination_signal": true
      }
      "edit_mode": "vi"
      "error_style": "fancy"
      "highlight_resolved_externals": true
      "ls": {
        "use_ls_colors": true
      }
      "menus": [{
        "marker": "? "
        "name": "completion_menu"
        "only_buffer_difference": false
        "style": {
          "description_text": "yellow"
          "match_text": {
            "attr": "u"
          }
          "selected_match_text": {
            "attr": "ur"
          }
          "selected_text": "white_reverse"
          "text": "white"
        }
        "type": {
          "border": false
          "correct_cursor_pos": true
          "cursor_offset": 0
          "description_mode": "prefer_right"
          "description_offset": 1
          "layout": "ide"
          "max_completion_height": 25
          "max_completion_width": 150
          "max_description_height": 10
          "max_description_width": 50
          "min_competion_width": 0
          "min_description_width": 0
          "padding": 0
        }
      }]
      "rm": {
        "always_trash": false
      }
      "shell_integration": {
        "osc2": true
        "osc7": true
        "osc8": true
      }
      "show_banner": false
      "table": {
        "abbreviated_row_count": null
        "footer_inheritance": true
        "header_on_separator": true
        "index_mode": "always"
        "mode": "single"
        "padding": {
          "left": 1
          "right": 1
        }
        "show_empty": true
        "trim": {
          "methodology": "wrapping"
          "truncating_suffix": "..."
          "wrapping_try_keep_words": true
        }
      }
      "use_ansi_coloring": true
      "use_kitty_protocol": true
    }

    $env.CARAPACE_BRIDGES = "inshellisense,carapace,zsh,fish,bash"

    source ~/.cache/carapace/init.nu
    source ~/.cache/starship/init.nu
    source ~/.cache/zoxide/init.nu

    alias "c" = clear
    alias "cat" = bat --number --color=always --paging=never --tabs=2 --wrap=never
    alias "grep" = rg
    alias "l" = eza -lF --time-style=long-iso --icons
    alias "ll" = eza -h --git --icons --color=auto --group-directories-first -s extension
    alias "q" = exit
    alias "temp" = cd /tmp/
    alias "tree" = eza --tree --icons --tree
    EOF

    mkdir -p /root/.cache/carapace
    mkdir -p /root/.cache/starship
    mkdir -p /root/.cache/zoxide

    ${pkgs.carapace}/bin/carapace _carapace nushell > /root/.cache/carapace/init.nu

    ${pkgs.starship}/bin/starship init nu > /root/.cache/starship/init.nu

    ${pkgs.zoxide}/bin/zoxide init nushell > /root/.cache/zoxide/init.nu

    chown -R root:root /root/.config /root/.cache
    chmod -R 755 /root/.config /root/.cache
  '';
}
