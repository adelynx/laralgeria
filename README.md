# Laralgeria: Local Development Environment

**Laralgeria** is a Local Development Environment Using Docker with the following configuration:
### Web Server (laralgeria-web)  
- Ubuntu 18.04.1 LTS (Bionic Beaver)
- PHP v7.3 (FastCGI Process Manager)
- Ngnix v1.14.0
- Laravel 6

### Database Server (laralgeria-db)  
- Debian 9 (Stretch)
- MySQL v8.0.17

## Installation Requirements

The Laralgeria local development environment has a few system requirements. You will need to make sure your OS (Windows, Linux or macOS) meets the following requirements:

- Must have **Docker** installed in your machine (https://www.docker.com)
- Must have **Docker-Compose** installed in your machine (https://docs.docker.com/compose/install)
- Must have **Git** install in your machine (https://git-scm.com)
- Must have **PHP** install in your machine (https://www.php.net)
- Must have **Composer** installed in your machine (https://getcomposer.org)

## Installing Laralgeria

To install Laralgeria you need to clone the repository first and then run the install command:

```bash
git clone https://github.com/adelynx/laralgeria.git
cd laralgeria
./conductor install
```

_**IMPORTANT:**_

 - The installation might take longer it depends on your connection speed
 - For Windows users it's the `./conductor` file work only under `Windows Subsystem for Linux (WSL)`

### Setting up

Make sure that you don't have anything running on port 80 if you want to use the `port 80` (That includes Skype)

Add this line `127.0.0.1 laralgeria.local` to your local hosts file.

- **Windows:** `C:\Windows\System32\Drivers\etc\hosts`
- **Linux & macOS:** `/etc/hosts`

🎉 🎉 🎉 Well done! Your environment is ready to run! 🎉 🎉 🎉

### Usage

#### Database

You can connect to the DB from the host machine by using `localhost` and the port `MYSQL_PORT` set in `laralgeria.env` for the credentials.

#### SSH

Use `./conductor ssh` to SSH into the container bash and run artisan commands manually.  

### Reinstalling the environment

- Clean the containers `docker rm $(docker ps -a -q) --force`
- Clean the images `docker rmi $(docker images -q) --force`
- Rebuild the environment `./conductor install`
- Start the environment `./conductor start`

### Updating the docker image

In case you need to install a PHP extension or change the image.

Changes to the docker image should be done on `docker-containers/laralgeria-web/Dockerfile`. Then rebuild the env by running this command `./conductor rebuild`

### Troubleshooting

**The issue with `conductor start` failing**

The container is locked by name (needed in order to make all the checks in conductor), if a running container is called 'laralgeria_db_v1', it won't recreate it.
You can check with a `docker ps`, if something is running you can kill it with `docker-compose kill/stop`.
If you don't see it, you can delete the container with `docker rm laralgeria`, and rerun the install command.

Another silly thing that sometimes cause this is a container being officially stopped but for some reason not being unallocated. That last case can be solved with a clean restart of docker (you can do it from the menu you can find by clicking the icon).
