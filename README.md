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

and run this for both files.

```
echo 'pcm.!default = null;' >> /root/.asoundrc
echo 'pcm.!default = null;' >> /etc/asound.conf
```

3- Install required sound utilities.

```
apt install pulseaudio alsa-utils -y
```

4- Edit modules file.

and run the following to add to the file.

```
echo 'snd_aloop index=1' >> /etc/modules
echo 'snd-aloop index=2' >> /etc/modules
echo 'snd-aloop index 3' >> /etc/modules
```

And type:

```
reboot now
```

5- After reboot, create the following file:

```
touch /etc/systemd/system/pulseaudio.service
```

and add the following:

```
echo '[Unit]' >> /etc/systemd/system/pulseaudio.service
echo 'Description=PulseAudio system server' >> /etc/systemd/system/pulseaudio.service
echo '# DO NOT ADD ConditionUser=!root' >> /etc/systemd/system/pulseaudio.service
echo '' >> /etc/systemd/system/pulseaudio.service
echo '[Service]' >> /etc/systemd/system/pulseaudio.service
echo 'Type=notify' >> /etc/systemd/system/pulseaudio.service
echo 'ExecStart=pulseaudio --daemonize=no --system --realtime --log-target=journal' >> /etc/systemd/system/pulseaudio.service
echo 'Restart=on-failure' >> /etc/systemd/system/pulseaudio.service
echo '' >> /etc/systemd/system/pulseaudio.service
echo '[Install]' >> /etc/systemd/system/pulseaudio.service
echo 'WantedBy=multi-user.target' >> /etc/systemd/system/pulseaudio.service
```

6- Enable the services

```
systemctl --system enable --now pulseaudio.service
systemctl --system status pulseaudio.service
```

7- Edit pulse audio config

```
echo 'default-server = /var/run/pulse/native' >> /etc/pulse/client.conf
echo 'autospawn = no' >> /etc/pulse/client.conf
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
docker run -d --name spotify1 --restart always --privileged -p 5900:5900 --device /dev/snd -e ALSADEV=hw:1,0  docker-spotify:latest
docker run -d --name spotify2 --restart always --privileged -p 5901:5900 --device /dev/snd -e ALSADEV=hw:2,0  docker-spotify:latest
docker run -d --name spotify3 --restart always --privileged -p 5902:5900 --device /dev/snd -e ALSADEV=hw:3,0  docker-spotify:latest
```

12- Reboot system

```
reboot now
```

Done!

Note: Connect over VNC or via webport.
There is no password set.
Only one client is possible per VPS using this setup.

Optional: Create extra null devices.

```
mknod -m 0666 /dev/null1 c 1 3
mknod -m 0666 /dev/null2 c 1 3

```
