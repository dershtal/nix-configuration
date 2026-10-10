{
  description = "My system configuration";

  inputs = {
    # Твой основной, стабильный канал
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    
    # ДОБАВЛЯЕМ unstable канал
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
            url = "github:nix-community/home-manager/release-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      system = "x86_64-linux";
      # Инициализируем unstable пакеты
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
	config.allowUnfree = true; # Если для unstable тоже нужны unfree пакеты
      };
    in {
      # Имя хоста nixos - не надо так делать
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
	# Передаем pkgs-unstable в configuration.nix (на всякий случай)
	specialArgs = { inherit pkgs-unstable; };
	modules = [
	  ./hosts/nixos/default.nix
        ];
      };

      homeConfigurations.dershtal = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
	# Передаем pkgs-unstable в home.nix
	extraSpecialArgs = { inherit pkgs-unstable; };
        modules = [
	  ./users/dershtal/home.nix
	];
      };
  };
}

