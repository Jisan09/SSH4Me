FROM ubuntu:latest

ARG AUTH_TOKEN=your_ngrok_token_here
ARG PASSWORD=rootuser
ENV PASSWORD=$PASSWORD
ENV AUTH_TOKEN=$AUTH_TOKEN

RUN apt-get update \
    && apt-get install -y debconf-utils ssh wget unzip \
    && echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && wget -O ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip \
    && unzip ngrok.zip \
    && echo "./ngrok config add-authtoken ${AUTH_TOKEN} &&" >>/docker.sh \
    && echo "./ngrok tcp 22 &>/dev/null &" >>/docker.sh \
    && mkdir /run/sshd \
    && echo '/usr/sbin/sshd -D' >>/docker.sh \
    && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config \
    && echo root:${PASSWORD}|chpasswd \
    && service ssh start \
    && chmod 755 /docker.sh

EXPOSE 80 8888 8080 443 5130-5135 3306 7860
CMD ["/bin/bash", "/docker.sh"]
