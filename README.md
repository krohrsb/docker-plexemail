# Docker for Plex Email

This is the Dockerfile setup for [plexEmail](https://github.com/jakewaldron/PlexEmail).

## Building (optional)
To build the image locally:

```bash
git clone https://github.com/blackbarn/docker-plexemail.git;
cd docker-plexemail;
docker build -t plex-email .
```

## Running

```bash
docker run -d -v /your_config_location:/config -v /your_plex_folder:/plex -p 80:80 --name plexEmail plex-email
```

Or you can replace `plex-email` with `blackbarn/plex-email` in your `run` command to use the pre-built image from docker hub.

```bash
docker run -d -v /your_config_location:/config -v /your_plex_folder:/plex -p 80:80 --name plexEmail blackbarn/plex-email
```

Change the port mapping to suit your needs, for example to have the web listen on `8080` simply use `-p 8080:80` instead.

## Configuration

On first start up, it will create a default `config.conf` for `plexEmail` within `your_config_location`. 
After this, set the following properties to configure plex and nginx:

```bash
plex_data_folder = '/plex'
web_folder = '/PlexEmail/web'
```

Be sure to modify the rest of this file to suit your needs.

## Cron
Plex Email's script is triggered by a cron job. There is a default one that this will use and it will trigger every Sunday at 11PM.

If you wish to define your own, simply place a file called `crontab` in your config directory. Be sure to ensure you have a blank line at the end otherwise it is not a true cron file :)

For example:

```bash
* * * * * root /PlexEmail/scripts/plexEmail.py --config /config/config.conf
```

This will run the script every minute (not recommended). Ensure you specify the custom config directory as shown above.See PlexEmail for additional command line options, such as `-t` to run a test.

## Compose

An example of a `docker-compose.yml` file:

```yml
web:
  build: .
  container_name: plex_email
  ports:
    - "8383:80"
  expose:
    - "8383"
    - "80"
  restart: always
  volumes:
    - /opt/data/plexemail:/config
    - /opt/data/plex/config:/plex
```

Obviously your volume mapping will vary.
