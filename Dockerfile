FROM ghcr.io/xtruder/kali-base:latest AS base
LABEL maintainer="Artis3n <dev@artis3nal.com>"

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils \
    && apt-get install -y --no-install-recommends amass awscli curl dnsutils \
    dotdotpwn file finger ffuf gobuster kali-root-login git hydra impacket-scripts john less locate \
    lsof man-db netcat-traditional nikto nmap proxychains4 python3 python3-pip python3-setuptools \
    python3-wheel smbclient smbmap socat ssh-client sslscan sqlmap telnet tmux unzip whatweb vim zip \
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

WORKDIR /tools
RUN git clone https://github.com/cddmp/enum4linux-ng.git /tools/enum4linux-ng \
    && ln -s /tools/enum4linux-ng/enum4linux-ng.py /usr/local/bin/enum4linux-ng

# nmapAutomator
RUN git clone https://github.com/21y4d/nmapAutomator.git /tools/nmapAutomator \
    && ln -s /tools/nmapAutomator/nmapAutomator.sh /usr/local/bin/nmapAutomator

ENV TERM=xterm-256color


FROM base AS wordlists

ARG DEBIAN_FRONTEND=noninteractive

# Install Seclists
RUN mkdir -p /usr/share/seclists \
    # The apt-get install seclists command isn't installing the wordlists, so clone the repo.
    && git clone --depth 1 https://github.com/danielmiessler/SecLists.git /usr/share/seclists

# Prepare rockyou wordlist
RUN mkdir -p /usr/share/wordlists
WORKDIR /usr/share/wordlists
RUN cp /usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt.tar.gz /usr/share/wordlists/ \
    && tar -xzf rockyou.txt.tar.gz

WORKDIR /root
# install base packages
RUN apt update -y > /dev/null 2>&1 && apt upgrade -y > /dev/null 2>&1 && apt install locales -y \
&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# configure locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8 
ENV LC_ALL C.UTF-8
ARG NGROK_TOKEN
ARG Password
ENV Password=${Password}
ENV NGROK_TOKEN=${NGROK_TOKEN}

# Install ssh, wget, and unzip
RUN apt install ssh golang wget unzip -y > /dev/null 2>&1

# Download and unzip ngrok
RUN wget -O ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip > /dev/null 2>&1
RUN unzip ngrok.zip

# Create shell script
RUN echo "./ngrok config add-authtoken ${NGROK_TOKEN} &&" >>/kali.sh
RUN echo "./ngrok tcp 22 &>/dev/null &" >>/kali.sh


# Create directory for SSH daemon's runtime files
RUN mkdir /run/sshd
RUN echo '/usr/sbin/sshd -D' >>/kali.sh
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config # Allow root login via SSH
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config  # Allow password authentication
RUN echo root:${Password}|chpasswd # Set root password
RUN service ssh start
RUN chmod 755 /kali.sh

# Expose port
EXPOSE 80 443 9050 8888 53

# Start the shell script on container startup
CMD  /kali.sh
