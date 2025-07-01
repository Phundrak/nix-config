{config, ...}: let
  signature = ''
    Lucien “Phundrak” Cartier-Tilet
    https://phundrak.com (Français)
    https://phundrak.com/en (English)

    Sent from GNU/Emacs

    *** Sauvez un arbre, mangez un castor ***
    ***      Save a tree, eat a beaver    ***
  '';
in {
  home.file.".signature" = {
    target = ".signature";
    text = signature;
  };
  accounts.email = {
    maildirBasePath = "Mail";
    accounts."lucien@phundrak.com" = {
      realName = "Lucien Cartier-Tilet";
      address = "lucien@phundrak.com";
      aliases = [
        "lucien@cartier-tilet.com"
        "admin@phundrak.com"
        "webmaster@phundrak.com"
        "youdontknow@phundrak.com"
      ];
      passwordCommand = "cat ${config.sops.secrets.emailPassword.path}";
      signature = {
        text = signature;
        showSignature = "append";
      };
      userName = "lucien@phundrak.com";
      imap.host = "mail.phundrak.com";
      smtp.host = "mail.phundrak.com";
      mu.enable = true;
      primary = true;

      mbsync = {
        create = "maildir";
        enable = true;
        expunge = "both";
        remove = "both";
      };
    };
  };
}
