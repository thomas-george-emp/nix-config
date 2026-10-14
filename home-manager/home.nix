{
  pkgs,
  config,
  lib,
  ...
}:
{
  home.stateVersion = "26.05";

  home.pointerCursor = {
    enable = true;
    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
    size = 32;
    gtk.enable = true;
  };

  home.sessionVariables = {
    PICO_SDK_PATH = "${config.home.homeDirectory}/pico/pico-sdk";
  };

  # Kitty terminal
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    themeFile = "gruvbox-dark";
    settings = {
      shell = "fish";
    };
  };

  # Fish shell
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      		set -g fish_greeting ""
      		if not set -q TMUX; and command -q tmux 
      		tmux new-session -A -s main 
      		end
      		set -g fish_key_bindings fish_vi_key_bindings
      	'';
    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
    ];
  };

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      telescope-nvim
      gruvbox-flat-nvim
      plenary-nvim
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      conform-nvim
    ];
    extraPackages = with pkgs; [
      ripgrep
      fd

      lua-language-server
      stylua

      nil
      nixfmt

      clang-tools

      rust-analyzer
      rustfmt

      zig
      zls

      pyright
      ruff
    ];
    initLua = builtins.readFile ./config/nvim/init.lua;

  };

  # TMUX terminal multiplexer
  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = builtins.readFile ./config/tmux/tmux.conf;
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "Thomas George";
      email = "thomas-george-emp@gmail.com";
    };
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."github.com" = {
      identityFile = "~/.ssh/id_ed25519";
      identitiesOnly = true;
      addKeysToAgent = "yes";
    };
  };

  services.ssh-agent.enable = true;

  # Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./config/hypr/hyprland.lua;
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };

      animations = {
        enabled = true;
        fade_in = {
          duration = 300;
          bezier = "easeOutQuint";
        };
        fade_out = {
          duration = 300;
          bezier = "easeOutQuint";
        };
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "600, 100";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(235, 219, 178)"; # fg  #ebdbb2
          inner_color = "rgb(60, 56, 54)"; # bg1 #3c3836
          outer_color = "rgb(250, 128, 114)"; # salmon #fa8072
          check_color = "rgb(250, 189, 47)"; # yellow #fabd2f
          fail_color = "rgb(251, 73, 52)"; # red #fb4934
          outline_thickness = 5;
          placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          shadow_passes = 2;
        }
      ];
    };
  };

  services.hyprpaper.enable = true;
  xdg.configFile."hypr/hyprpaper.conf".source = ./config/hypr/hyprpaper.conf;
  xdg.configFile."hypr/wallpapers".source = ./config/hypr/wallpapers;

}
