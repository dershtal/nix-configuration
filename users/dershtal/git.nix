{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Sergey Shtal";
        email = "dershtal@gmail.com";
      };


      alias = {
        ck = "checkout";
      };
    };
  };
}
