#!/bin/bash

echo -e "Please enter the username for the socks5 proxy:"
read username
echo -e "Please enter the password for the socks5 proxy:"
read -s password

# Update repositories
sudo apt update -y

# Install dante-server
sudo apt install ufw iptables dante-server -y

# Create the configuration file
sudo bash -c 'cat <<EOF > /etc/danted.conf
logoutput: /var/log/danted.log
internal: 0.0.0.0 port = 9098
internal: :: port = 9098
external: eth0
socksmethod: username none
user.privileged: root
user.notprivileged: nobody
client pass {
    from: 0/0 to: 0/0
    log: connect disconnect error
}
socks pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
}
socks pass {
    from: ::/0 to: ::/0
    log: connect disconnect error
}
EOF'

# Add user with password
sudo useradd --shell /usr/sbin/nologin $username
echo "$username:$password" | sudo chpasswd

# Check if UFW is active and open port 9098 if needed
if sudo ufw status | grep -q "Status: active"; then
    sudo ufw allow 9098/tcp
fi

# Check if iptables is active and open port 9098 if needed
if sudo iptables -L | grep -q "ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:9098"; then
    echo "Port 9098 is already open in iptables."
else
    sudo iptables -A INPUT -p tcp --dport 9098 -j ACCEPT
fi

# Restart dante-server
sudo systemctl restart danted

# Enable dante-server to start at boot
sudo systemctl enable danted
