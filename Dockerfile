FROM kalilinux/kali-rolling
WORKDIR /root
# Update packages and install locales
RUN apt update -y > /dev/null 2>&1 && apt upgrade -y > /dev/null 2>&1 && apt install locales -y \
&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Set locale to en_US.utf8
ENV LANG en_US.utf8
RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils \
    && apt-get install -y --no-install-recommends amass awscli curl dnsutils \
    dotdotpwn file tor  finger proxychains proxychains-ng ffuf gobuster sudo git hydra impacket-scripts john less locate \
    lsof man-db netcat-traditional nikto make wget ssh unzip nmap proxychains4 python3 python3-pip python3-setuptools \
    python3-wheel smbclient golang smbmap socat ssh-client sslscan sqlmap telnet tmux unzip whatweb vim zip \
    # Slim down layer size
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    # Remove apt-get cache from the layer to reduce container size
    && rm -rf /var/lib/apt/lists/*

# Second set of installs to slim the layers a bit
# exploitdb and metasploit are huge packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    exploitdb metasploit-framework \
    # Slim down layer size
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists*

WORKDIR /tmp
# AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install

WORKDIR /root
# enum4linux-ng
RUN apt-get update \
    && apt-get install -y --no-install-recommends python3-impacket python3-ldap3 python3-yaml \
    && mkdir /tools \
    # Slim down layer size
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists*
# nmapAutomator

# Install Seclists

# Proxychains config
RUN echo "dynamic_chain" > /etc/proxychains.conf && \
  echo "proxy_dns" >> /etc/proxychains.conf && \
  echo "tcp_read_time_out 15000" >> /etc/proxychains.conf && \
  echo "tcp_connect_time_out 8000" >> /etc/proxychains.conf && \
  echo "[ProxyList]" >> /etc/proxychains.conf && \
  echo "socks5 127.0.0.1 9050" >> /etc/proxychains.conf
# Set locale to en_US.utf8

ARG AUTH_TOKEN
ARG PASSWORD=rootuser

# Install packages and set locale
RUN apt-get update \
    && apt-get install -y locales nano ssh sudo python3 curl wget \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash -G sudo reconx
# Configure SSH tunnel using ngrok
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.utf8
RUN wget -O ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip \
    && unzip ngrok.zip \
    && rm /ngrok.zip \
    && mkdir /run/sshd \
    && echo "/ngrok tcp --authtoken ${AUTH_TOKEN} 22 &" >>/docker.sh \
    && echo "sleep 5" >> /docker.sh \
    && echo "curl -s http://localhost:4040/api/tunnels | python3 -c \"import sys, json; print(\\\"SSH Info:\\\n\\\",\\\"ssh\\\",\\\"root@\\\"+json.load(sys.stdin)['tunnels'][0]['public_url'][6:].replace(':', ' -p '),\\\"\\\nROOT Password:${PASSWORD}\\\")\" || echo \"\nError：AUTH_TOKEN，Reset ngrok token & try\n\"" >> /docker.sh \
    && echo '/usr/sbin/sshd -D' >>/docker.sh \
    && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config \
    && echo root:${PASSWORD}|chpasswd \
    && chmod 755 /docker.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 80 22 53 9050 3389 9050 8888 8080 443 5130-5135 3306 7860
CMD ["/bin/bash", "/docker.sh"]
