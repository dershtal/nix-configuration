{ config, pkgs, pkgs-unstable, ... }: {
        nixpkgs.config.allowUnfree = true;
        home = {
                username = "dershtal";
                homeDirectory = "/home/dershtal";
                stateVersion = "26.05";

                packages = with pkgs; [
		        git
			fastfetch
                        #neofetch
                        #ghostty
                        foot
			tmux
                        sox
                        mc
                        hyprland
                        cascadia-code
                        dejavu_fonts
                        liberation_ttf
                        noto-fonts
                        noto-fonts-cjk-sans
                        noto-fonts-color-emoji
                        wofi
                        superfile
                        swaylock
			vscode
			firefox
			chromium
			pciutils
                        read-edid
			radare2

			pkgs-unstable.noctalia-shell
                ];
        };

        imports = [
               ./bash.nix
	       ./git.nix
        ];

        fonts.fontconfig.enable = true;

        xdg.configFile."noctalia/config.toml".text = ''
          [shell]
          time_format = "{:%H:%M}"
          date_format = "%A, %x"
          corner_radius_scale = 1.0

          [theme]
          mode = "dark"

          [bar.main]
          position = "top"
          thickness = 34
          background_opacity = 1.0
          radius = 12
          margin_ends = 10
          margin_edge = 10
          padding = 14
          widget_spacing = 6
          shadow = true

          # Разметка виджетов на панели: слева, по центру и справа
          start = ["launcher", "workspaces"]
          center = ["clock"]
          end = ["media", "tray", "volume", "brightness", "battery", "control-center"]
          
          # Если хочешь, чтобы Noctalia не перехватывала обои (пусть это делает hyprpaper/swaybg)
          [wallpaper]
          enabled = false
        '';

        programs.neovim = {
                enable = true;
                defaultEditor = true;

                extraPackages = with pkgs; [
                        nil
                        alejandra
                ];

                plugins = with pkgs.vimPlugins; [
                        nerdtree
                        
                        # Добавляем Tokyo Night и сразу настраиваем
                        {
                                plugin = tokyonight-nvim;
                                type = "lua";
                                config = ''
                                  require("tokyonight").setup({
                                    style = "night", -- Варианты: 'storm', 'moon', 'night', 'day'
                                    transparent = false, -- Сделай true, если хочешь прозрачный фон
                                    terminal_colors = true,
                                    styles = {
                                      comments = { italic = true },
                                      keywords = { italic = true },
                                      functions = {},
                                      variables = {},
                                    },
                                  })
                                  -- Включаем тему
                                  vim.cmd("colorscheme tokyonight")
                                '';
                        }
                        
                        # LSP
                        {
                                plugin = nvim-lspconfig;
                                type = "lua";
                                config = ''
                                  vim.lsp.config('nil_ls', {
                                    cmd = { "nil" },
                                    filetypes = { "nix" },
                                    root_markers = { "flake.nix", ".git", "default.nix" },
                                    settings = {
                                      ['nil'] = {
                                        formatting = { command = { "alejandra" } }
                                      }
                                    }
                                  })
                                  vim.lsp.enable('nil_ls')
                                '';
                        }
                        
                        # Treesitter
                        {
                                plugin = nvim-treesitter.withAllGrammars;
                                type = "lua";
                                config = ''
                                  vim.api.nvim_create_autocmd("FileType", {
                                    pattern = "*",
                                    callback = function(args)
                                      pcall(vim.treesitter.start, args.buf)
                                    end,
                                  })
                                '';
                        }
                ];

                # Внешний вид (остальные настройки) и хоткеи
                initLua = ''
                  vim.opt.shortmess:append("I")

                  -- Хоткеи
                  vim.keymap.set('n', '<F12>', vim.lsp.buf.definition, { desc = "Go to Definition" })
                  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Hover Info" })
                  vim.keymap.set('n', 'gd', vim.lsp.buf.code_action, { desc = "Code Action" })
                  
                  -- Форматирование
                  vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, { desc = "Format Document" })
                '';
        };

        programs.foot = {
                enable = true;
                settings = {
                  main = {
                    term = "xterm-256color";
                    workers = 32;
                    initial-window-size-chars = "115x24";
                    pad = "4x4 center";
                    font = "Cascadia Code PL:size=13";
                  };
                };
        };
	programs.tmux = {
	        enable = true;
		clock24 = true;
	};
        wayland.windowManager.hyprland = {
                enable = true;
                systemd.variables = [ "--all" ];
                extraConfig = builtins.readFile ./hyprland.lua;
        };

}
