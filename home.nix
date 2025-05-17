{ config, pkgs, ... }: {
        home = {
                username = "dershtal";
                homeDirectory = "/home/dershtal";
                stateVersion = "24.11";

                packages = with pkgs; [
		        git
                        neofetch
                        foot
                        sox
                        mc
                        hyprland
                        cascadia-code
                        dejavu_fonts
                        liberation_ttf
                        noto-fonts
                        noto-fonts-cjk-sans
                        noto-fonts-emoji
                        wofi
                        superfile
                        swaylock
                ];
        };

        imports = [
               ./bash.nix
	       ./git.nix
        ];

        fonts.fontconfig.enable = true;
        programs.neovim = {
                enable = true;
                defaultEditor = true;
                plugins = with pkgs.vimPlugins; [
                        gruvbox-material
                        nerdtree
                ];
        };
        programs.foot = {
                enable = true;
                settings = {
                  main = {
                    term = "xterm-256color";
                    workers = 32;
                    initial-window-size-chars = "115x24";
                    pad = "4x4 center";
                    font = "Cascadia Code PL:size=6";
                  };
                };
        };
        wayland.windowManager.hyprland = {
                enable = true;
                systemd.variables = [ "--all" ];
                extraConfig = builtins.readFile ./hyprland.conf;
        };

}
