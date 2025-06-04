{pkgs, ...}: {
  systemd = {
    timers."nextcloud-cron" = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "20m";
        OnUnitActiveSec = "20m";
        Unit = "nextcloud-cron.service";
      };
    };
    services."nextcloud-cron" = {
      script = ''
        CONTAINER_NAME="nextcloud-nextcloud-1"

        is_container_running() {
          ${pkgs.docker}/bin/docker inspect -f '{{.State.Running}}' "$CONTAINER_NAME" 2>/dev/null | grep -q "true"
        }

        while ! is_container_running; do
            echo "Waiting for $CONTAINER_NAME to start..."
            sleep 10
        done

        echo "$CONTAINER_NAME is running. Executing CRON job..."
        ${pkgs.docker}/bin/docker exec -u www-data -it nextcloud-nextcloud-1 php /var/www/html/cron.php
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };
  };
}
