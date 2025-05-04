{
  programs.direnv = {
    enable = true;
    config.global.load_dotenv = true;
    nix-direnv.enable = true;
  };
}
