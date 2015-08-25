#!/bin/bash
# Startup script for plexEmail docker

# Check to see if we have a saved index.html file (generated from a previous run of plexEmail.py)
# If not, use nginx's default
if [ ! -f /config/index.html ]; then
  cp /usr/share/nginx/html/index.html /config/index.html
  echo "INFO: generating default html page as one was not found in /config"
else
  echo "INFO: using /config/index.html from previous generation"
fi

# Symlink volume's index.html into our web directory
ln -sf /config/index.html /PlexEmail/web/index.html

# If a config.conf file does not exist in the volume, copy over the default
if [ ! -f /config/config.conf ]; then
  echo "INFO: no config found in /config directory. copying default config, be sure to modify it"
  cp /PlexEmail/scripts/config.conf /config/config.conf
fi

# If a crontab exists in the volume, use that instead of the default
if [ -f /config/crontab ]; then
  echo "INFO: crontab found in /config directory. using it instead of the default"
  cp /config/crontab /etc/cron.d/plexemail
  chmod 0644 /etc/cron.d/plexemail
fi

echo "INFO: starting cron and nginx"
# Start cron and run nginx (in non-daemon mode)
cron && nginx -g 'daemon off;'
