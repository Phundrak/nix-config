{passwordFiles}: {
  enable = true;
  user = "creug";
  group = "users";
  accounts = {
    creug.passwordFile = passwordFiles.creug;
    phundrak.passwordFile = passwordFiles.phundrak;
  };
  volumes = {
    "/plex" = {
      path = "/plex";
      access.rwmd = ["creug" "phundrak"];
      flags = {
        e2dsa = true;
        e2ts = true;
        xdev = true;
        xvol = true;
        dedup = true;
        nohash = "\\.iso$";
      };
    };
  };
}
