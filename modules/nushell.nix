{pkgs, ...}: {
  programs.nushell = {
    enable = true;
    plugins = with pkgs.nushellPlugins; [
      query
      gstat
      polars
    ];
    extraConfig = let
      conf = builtins.toJSON {
        show_banner = false;
        edit_mode = "vi";
        buffer_editor = "hx";
        completions = {
          algorithm = "substring";
          sort = "smart";
          case_sensitive = false;
          quick = true;
          partial = true;
          use_ls_colors = true;
        };
        shell_integration = {
          osc2 = true;
          osc7 = true;
          osc8 = true;
        };
        use_kitty_protocol = true;
        bracketed_paste = true;
        use_ansi_coloring = true;
        error_style = "fancy";
        display_errors = {
          exit_code = false;
          termination_signal = true;
        };
        table = {
          mode = "single";
          index_mode = "always";
          show_empty = true;
          padding.left = 1;
          padding.right = 1;
          trim = {
            methodology = "wrapping";
            wrapping_try_keep_words = true;
            truncating_suffix = "...";
          };
          header_on_separator = true;
          abbreviated_row_count = null;
          footer_inheritance = true;
        };
        ls.use_ls_colors = true;
        rm.always_trash = false;
        menus = [
          {
            name = "completion_menu";
            only_buffer_difference = false;
            marker = "? ";
            type = {
              layout = "ide";
              min_competion_width = 0;
              max_completion_width = 150;
              max_completion_height = 25;
              padding = 0;
              border = false;
              cursor_offset = 0;
              description_mode = "prefer_right";
              min_description_width = 0;
              max_description_width = 50;
              max_description_height = 10;
              description_offset = 1;
              correct_cursor_pos = true;
            };
            style = {
              text = "white";
              selected_text = "white_reverse";
              match_text = {attr = "u";};
              selected_match_text = {attr = "ur";};
              description_text = "yellow";
            };
          }
        ];
        cursor_shape = {
          vi_insert = "line";
          vi_normal = "block";
        };
        highlight_resolved_externals = true;
      };
      completions = let
        completion = name: ''
          source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/${name}/${name}-completions.nu
        '';
      in
        names:
          builtins.foldl'
          (prev: str: "${prev}\n${str}") ""
          (map completion names);
    in ''
      $env.config = ${conf};
      ${completions ["git" "nix" "man" "rg" "gh" "glow" "bat"]}
    '';
    environmentVariables = {
      PROMPT_INDICATOR_VI_INSERT = "  ";
      PROMPT_INDICATOR_VI_NORMAL = "∙ ";
      PROMPT_COMMAND = "";
      PROMPT_COMMAND_RIGHT = "";
      NIXPKGS_ALLOW_UNFREE = "1";
      NIXPKGS_ALLOW_INSECURE = "1";
      SHELL = "${pkgs.nushell}/bin/nu";
      EDITOR = "hx";
      VISUAL = "hx";
      CARAPACE_BRIDGES = "inshellisense,carapace,zsh,fish,bash";
    };
    extraEnv = "$env.CARAPACE_BRIDGES = 'inshellisense,carapace,zsh,fish,bash'";
  };
}
