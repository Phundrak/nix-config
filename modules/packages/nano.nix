{
  flake.modules.nixos.nano = {
    programs.nano = {
      enable = true;
      syntaxHighlight = true;
      nanorc = ''
        set tabsize 2
        set autoindent
        set atblanks
        set linenumbers
        set smarthome
        set softwrap
      '';
    };
  };
}
