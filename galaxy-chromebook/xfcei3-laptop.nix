{ config, pkgs, ... }:

{
  # Allow non-free applications to be installed
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim 
    git
    gnupg 
    firefox 
    kitty 
    guake 
    nodejs 
    yarn 
    rofi 
    jq 
    keyutils 
    pass 
    (pass.withExtensions (ext: with ext; 
    [ 
      pass-otp 
    ])) 
    xclip
    syncthing
    bitwarden 
    wireguard-tools 
    busybox 
    unzip 
    go 
    mosh 
    bind 
    gcc 
    gnumake 
    ansible 
    file 
    patchelf
    nix-index
    autoPatchelfHook
    maim
    sxhkd
    desktop-file-utils
    libnotify
    neofetch
    qemu-utils
    keynav
    xdotool
    home-manager
    peru
    pinentry-curses
    coreutils
    nodePackages.typescript
    lefthook
    kitty
    i3lock-fancy
    sof-firmware
    olm
    polybar
    gptfdisk
    glib.dev
  ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Display server applications
  services.xserver = {
    enable = true;
    displayManager = {
      gdm.enable = true;
      defaultSession = "xfce+i3";
    };
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };
    windowManager.i3 = {
       enable = true;
       package = pkgs.i3-gaps;
    };
  };

  virtualisation = {
    docker = {
      enable = true;
    };
  };
  
  services = {
    unclutter = {
      enable = true;
      timeout = 10;
    };
    blueman = {
      enable = true;
    };
    picom = {
      enable = true;
      backend = "glx";
      refreshRate = 60;
      vSync = "opengl-swc";
    };
    logind = {
      lidSwitch = "hibernate";
      lidSwitchDocked = "ignore";
    };
  };

  programs.adb.enable = true;  

  programs.firejail = {
    enable = true;
  };

  users.users.heywoodlh = {
      isNormalUser = true;
      uid = 1000;
      home = "/home/heywoodlh";
      description = "Spencer Heywood";
      extraGroups = [ "wheel" "networkmanager" "adbusers" "docker" ];
      shell = pkgs.zsh;
  };

  nix.allowedUsers = [ "heywoodlh" ];

  services = {
    syncthing = {
      enable = true;
      user = "heywoodlh";
      dataDir = "/home/heywoodlh/Sync";
      configDir = "/home/heywoodlh/.config/syncthing";
    };
  };

  networking.firewall.enable = true;
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;
  programs.light.enable = true;

  security.sudo.extraRules = [
    { groups = [ "wheel" ]; commands = [ { command = "/run/current-system/sw/bin/light"; options = [ "NOPASSWD" ]; } ]; }
  ];

  hardware.bluetooth.enable = true;

  nix.extraOptions = '' 
    extra-experimental-features = nix-command flakes
  '';
}
