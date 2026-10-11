{pkgs, config, lib, ...}: {
	home.stateVersion = "26.05";

	home.pointerCursor = {
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
		{ name = "tide"; src = pkgs.fishPlugins.tide.src; }
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
    
    # Hyprland 
    wayland.windowManager.hyprland = { 
     enable = true; 
     extraConfig = builtins.readFile ./config/hypr/hyprland.lua;
    };

     services.hyprpaper.enable = true;
     xdg.configFile."hypr/hyprpaper.conf".source = ./config/hypr/hyprpaper.conf;
     xdg.configFile."hypr/wallpapers".source = ./config/hypr/wallpapers;


}

