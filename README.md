# spotify-client-install-docker-ubuntu
Install spotify client inside docker container on Ubuntu 22.04 LTS

1- Update system and install linux-image-generic.

```
apt update && apt upgrade -y
apt install linux-image-generic
```

2- Create 2 files:

```
touch /root/.asoundrc
touch /etc/asound.conf
```

and add this using nano in both files.

```
pcm.!default = null;
```

3- Install required sound utilities.

```
apt install pulseaudio alsa-utils -y
```

4- Edit modules file.

```
nano /etc/modules
```

and add the following to the file.

```
snd_aloop
```

Save and exit the file, and type:

```
reboot now
```

5- After reboot, create the following file:

```
touch /etc/systemd/system/pulseaudio.service
```

and edit the file

```
nano /etc/systemd/system/pulseaudio.service
```

and add the following:

```
[Unit]
Description=PulseAudio system server
# DO NOT ADD ConditionUser=!root

[Service]
Type=notify
ExecStart=pulseaudio --daemonize=no --system --realtime --log-target=journal
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

6- Enable the services

```
systemctl --system enable --now pulseaudio.service
systemctl --system status pulseaudio.service
```

7- Edit pulse audio config

```
nano /etc/pulse/client.conf
```

and append the following

```
default-server = /var/run/pulse/native
autospawn = no
```

8- Edit pulseaudio access (append for any user you run docker containers)

```
usermod -aG pulse-access root
```

and reboot

```
reboot now
```

9- Install docker

```
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
apt install docker-compose
```

10- Clone repo

```
cd /root
git clone https://github.com/EvanTrow/docker-spotify.git
```

and build

```
cd docker-spotify
docker build -t docker-spotify .
```

11- Setup container

```
docker run -d --name spotify --restart always --privileged -p 5800:5800 -p 5900:5900 -p 8080:8080 --device /dev/snd  docker-spotify:latest
```

12- Reboot system

```
reboot now
```

Done!

Note: Connect over VNC or via webport.
There is no password set.
Only one client is possible per VPS using this setup.
