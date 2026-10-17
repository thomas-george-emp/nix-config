# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:
{

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Automatic updating
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";

  # Automatic cleanup
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 15d";
  nix.settings.auto-optimise-store = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "thorno"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  # Enable networking
  networking.networkmanager.enable = true;

  # rtkit (optional, recommended) allows Pipewire to use the realtime scheduler for increased performance.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment the following
    #jack.enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    font-awesome
    material-icons
  ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."thorno" = {
    isNormalUser = true;
    description = "thorno";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.fish;

  };

  home-manager.backupFileExtension = "backup";
  home-manager.users."thorno" = import ./home-manager/home.nix;
  programs.fish.enable = true;

  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    # Generally useful utilites
    wget
    usbutils

    # Web Browser
    firefox

    # Music
    spotify

    # Fun with friends
    discord

    # Hyprland
    hyprland
    hyprpaper
    hypridle

    # Wayland stuff
    grim
    swappy
    slurp
    wl-clipboard
    eww
    mako

    # File manager
    kdePackages.dolphin
    kdePackages.kio # needed since 25.11
    kdePackages.kio-fuse # to mount remote filesystems via FUSE
    kdePackages.kio-extras # extra protocols support (sftp, fish and more)

    # Bluetooth support
    bluetuith

    # Text editors
    neovim
    vim

    # Terminal Emulator
    kitty

    # Terminal Utilities
    tmux
    btop
    cliphist

    # Fish plugins
    fishPlugins.tide

    # Information utilities
    hwinfo
    wev
    tree

    # Silly programs
    sl
    fastfetch
    cmatrix

    # Programming

    # C programming
    gcc
    cmake
    gdb

    # Miscellaneous (will disambiguate later)
    rustup

    (python3.withPackages (
      python-pkgs: with python-pkgs; [
        pandas
        requests
        numpy
        matplotlib
        sympy
      ]
    ))

    texliveFull
    clang

    # Version control
    git
    gh

    # Image / PDF viewers
    zathura
    inkscape

    # Package utilities
    pkg-config

    # Virtualization software
    qemu_full

    # Simulation software

    # Autonomy lab
    pico-sdk
    openocd
    picotool
    cmake
    gnumake

    # Libreoffice
    libreoffice-qt
    hunspell
    hunspellDicts.en_US
  ];

  environment.etc."xdg/menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #};

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.nginx.enable = true;
  services.udev.extraRules = ''
    # Raspberry Pi Debugprobe (CMSIS-DAP)
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="000c", MODE="0660", GROUP="dialout", TAG+="uaccess"
  '';
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
