# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, pkgs-unstable, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./noctalia-greeter.nix
    ];

  # Отключаем systemd-boot
  boot.loader.systemd-boot.enable = false;   # Выключаем systemd-boot

  # Старый конфиг сет
  #boot.loader.grub.enable = true;
  #boot.loader.grub.efiSupport = true;
  #boot.loader.grub.efiInstallAsRemovable = true;
  #boot.loader.efi.canTouchEfiVariables = false;
  #boot.loader.efi.efiSysMountPoint = "/boot/efi";
  #boot.loader.grub.devices = ["nodev"];

  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      devices = ["nodev"];
      gfxmodeEfi = "2560x1440";
    };
    efi = {
      canTouchEfiVariables = false;
      efiSysMountPoint = "/boot/efi";
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;

  # Параметры ядра, если нужны:
  boot.kernelParams = [
    "video=2560x1440"
    "nvidia.NVreg_EnableGpuFirmware=0"
    "quiet"
    "splash"
    "pti=off"
    "spectre_v1=off"
    "spectre_v2=off"
    "l1tf=off"
    "nospec_store_bypass_disable"
    "ibrs=off"
    "stibp=off"
    "ssbd=off"
    "l1d_flush=off"
    "mds=off"
    "tsx_async_abort=off"
    "mitigations=off"
    "noibpb"
    "no_stf_barrier"
    "tsx=on"
    "retbleed=off"
    "no_rsb_filling"
    "smt=off"
  ];

  boot.plymouth.enable = true;
  #boot.plymouth.theme = "rings";

  nix.settings.experimental-features =["nix-command" "flakes"];

  services.displayManager.noctalia-greeter = {
    enable = true;
    
    # Берем саму программу из unstable-канала
    package = pkgs-unstable.noctalia-greeter; 
    
    settings = {
      keyboard = {
        layout = "us,ru";
      };
      
      # Современный синтаксис курсора (как просили в доках модуля)
      cursor = {
        theme = "Bibata-Modern-Classic";
        size = 24;
        path = pkgs.bibata-cursors; # Указываем прямо на пакет!
      };
    };
  };

  programs.hyprland = {
    enable = true;
    # Если используете nvidia, можно включить утилитный пакет или оставить на усмотрение home-manager, 
    # но включение самого модуля обязательно для создания .desktop файлов в /run/current-system/sw/share/wayland-sessions/
  };

  # === ФИКС ДЛЯ ВИРТУАЛКИ (VMware) ===
  # Заставляем экран входа использовать программный рендеринг
  #systemd.services.greetd.environment = {
  #  LIBGL_ALWAYS_SOFTWARE = "1";
  #  WLR_NO_HARDWARE_CURSORS = "1";
  #};


  # Эти параметры необхъодимы для работы системы как VM.
  virtualisation.vmware.guest.enable = true; # vm_setting


      #nvidia = {
      #    modesetting.enable = true;
      #    powerManagement.enable = true;
      #    nvidiaSettings = true;
      #    open = false;
      #};
  #};
  

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Включаем Xserver (X11)
  # services.xserver.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    # package = config.boot.kernelPackages.nvidiaPackages.stable; 580 driver bug on 2k resolution!
    # package = config.boot.kernelPackages.nvidiaPackages.legacy_570;

    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  #nixpkgs.config.allowUnfree = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dershtal = {
     isNormalUser = true;
     extraGroups = [ "wheel" "input" "networkmanager" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     tree
  #   ];
  };


  # programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     htop
     home-manager
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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
  system.stateVersion = "25.05"; # Did you read the comment?

}
