apt update && apt upgrade -y
apt install linux-image-generic
touch /root/.asoundrc
touch /etc/asound.conf
echo 'pcm.!default = null;' >> /root/.asoundrc
echo 'pcm.!default = null;' >> /etc/asound.conf
apt install pulseaudio alsa-utils -y
echo 'snd_aloop' >> /etc/modules
touch /etc/systemd/system/pulseaudio.service
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
systemctl --system enable --now pulseaudio.service
systemctl --system status pulseaudio.service
echo 'default-server = /var/run/pulse/native' >> /etc/pulse/client.conf
echo 'autospawn = no' >> /etc/pulse/client.conf
usermod -aG pulse-access root
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
apt install docker-compose
cd /root
git clone https://github.com/EvanTrow/docker-spotify.git
cd docker-spotify
docker build -t docker-spotify .
docker run -d --name spotify --restart always --privileged -p 5800:5800 -p 5900:5900 -p 8080:8080 --device /dev/snd  docker-spotify:latest
reboot now
