{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ryubing
    pcsx2
  ];
}
