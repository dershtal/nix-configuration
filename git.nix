{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Sergey Shtal";
    userEmail = "dershtal@gmail.com";

    # Пример алиасов:
    extraConfig = {
      alias = {
        ck = "checkout";
      };
    };
  };
}
