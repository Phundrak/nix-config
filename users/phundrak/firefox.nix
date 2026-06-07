{pkgs, ...}: {
  config.home.desktop.firefox = {
    enable = true;
    useZen = true;
    tridactyl = {
      enable = true;
      preConfig = "sanitise tridactyllocal tridactylsync";
      config = {
        editorcmd = "emacsclient -c";
        keyboardlayoutbase = "bepo";
        keyboardlayoutforce = "true";
        hintchars = "auiectsr";
        smothscroll = "true";
      };
      extraConfig = ''
        command openTwitchInMpv js -d@\
          const url = new URL(document.location.href);\
          const cleanUrl = url.hostname + url.pathname;\
          const token = document.cookie.split("; ")\
                                .find(item => item.startsWith("auth-token="))?.split("=")[1];\
          const auth = "--twitch-api-header=Authorization=OAuth " + token;\
          const cmd = `${pkgs.streamlink}/bin/streamlink "''${auth}" "''${cleanUrl}" best`;\
          tri.native.run(cmd)\
        @

        unbind h
        unbind j
        unbind k
        unbind l
        unbind c
        unbind t
        unbind s
        unbind r
        unbind H
        unbind J
        unbind K
        unbind L
        unbind C
        unbind T
        unbind S
        unbind R

        " === Bépo layout — scrolling (ctsr = hjkl) ===
        bind c scrollpx -300 0
        bind t scrollline 5
        bind s scrollline -5
        bind r scrollpx 300 0

        " Half/full page scroll (replacing C-f/C-b/C-d/C-u)
        bind <C-t> scrollpage 0.5
        bind <C-s> scrollpage -0.5

        " === History navigation (C/R = H/L) ===
        bind C back
        bind R forward

        " === Tab navigation ===
        bind T tabnext
        bind S tabprev

        " === Displaced commands ===
        " reload was on r → move to h (bépo's 'replace' position)
        bind h reload
        bind H reloadhard

        " tabopen was on t → move to j (bépo's 'find char to' position)
        bind j fillcmdline tabopen

        unbind ^http(s?)://youtube\.com f
        unbind ^http(s?)://youtube\.com t
        unbind ^http(s?)://youtube\.com l
        unbind ^http(s?)://youtube\.com j
        unbind ^http(s?)://twitch\.tv f

        bind n findnext
        bind N findnext -f
        bind p findnext --reverse
        bind P findnext -f --reverse

        bind < urlincrement -1
        bind > urlincrement 1
        bind ypt openTwitchInMpv
        bind ypv js tri.native.run(`mpv --ytdl-format="[height >=? 480]" --ontop --fs "''${document.location.href}"`)
        bind ypm hint -JF e => tri.native.run(`mpv --ytdl-format="[height >=? 480]" --ontop --fs "''${e.href}"`)
      '';
    };
  };
}
