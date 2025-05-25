{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.zsh;
in {
  options.modules.zsh = {
    enable = lib.mkEnableOption "Enables zsh";
    abbrs = lib.mkOption {
      type = types.attrsOf types.str;
      default = {};
      example = {
        cp = "cp -i";
        lns = "ln -si";
      };
    };
    zshrcExtra = lib.mkOption {
      type = types.lines;
      default = "";
    };
  };

  config.programs.zsh = lib.mkIf cfg.enable {
    enable = true;
    autocd = true;
    autosuggestion = {
      enable = true;
      strategy = ["match_prev_cmd" "completion"];
    };
    enableCompletion = true;
    history = {
      findNoDups = true;
      ignoreAllDups = true;
      ignoreDups = true;
      ignoreSpace = true;
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      saveNoDups = true;
    };
    historySubstringSearch.enable = true;
    initContent = with lib;
      concatLines [
        ''
          bindkey -e
          bindkey '^p' history-search-backward
          bindkey '^n' history-search-forward

          # Completion styling
          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
          zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
          zstyle ':completion:*' menu no
          zstyle ':fzf-tab:complete:cd:*' fzf-preview '${pkgs.eza}/bin/eza $realpath'
        ''
        cfg.zshrcExtra
      ];
    oh-my-zsh = {
      enable = true;
      plugins = [
        "dirhistory"
        "sudo"
      ];
    };
    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "v1.2.0";
          sha256 = "sha256-q26XVS/LcyZPRqDNwKKA9exgBByE0muyuNb0Bbar2lY=";
        };
      }
      {
        name = "zsh-autopair";
        src = pkgs.fetchFromGitHub {
          owner = "hlissner";
          repo = "zsh-autopair";
          rev = "449a7c3d095bc8f3d78cf37b9549f8bb4c383f3d";
          sha256 = "sha256-3zvOgIi+q7+sTXrT+r/4v98qjeiEL4Wh64rxBYnwJvQ=";
        };
      }
    ];
    syntaxHighlighting.enable = true;
    zsh-abbr = {
      enable = true;
      abbreviations = cfg.abbrs;
    };
  };
}
