#!/bin/bash
# Define color variables
RED="\e[0;31m"
GREEN="\e[0;32m"
YELLOW="\e[0;33m"
BLUE="\e[0;34m"
MAGENTA="\e[0;35m"
CYAN="\e[0;36m"
WHITE="\e[1;37m"
NC="\e[0m" # No Color

# Updating and upgrading the server
if sudo apt-get update && sudo apt-get -y upgrade; then
    echo -e "${GREEN}[+] Update and upgrade were successful.${NC}"
else
    echo -e "${RED}[-] An error occurred during the update and upgrade process.${NC}"
fi

# install pipx
sudo apt-get install -y python3-pip
python3 -m pip install --user pipx
python3 -m pipx ensurepath

# Check if pipx was installed successfully
if command -v pipx &> /dev/null; then
    echo -e "${GREEN}[+] pipx was installed on the server.${NC}"
else
    echo -e "${RED}[-] An error occurred during the installation of pipx.${NC}"
fi

# install curl
sudo apt-get install -y curl

# Check if curl was installed successfully
if command -v curl &> /dev/null; then
    echo -e "${GREEN}[+] curl was installed on the server.${NC}"
else
    echo -e "${RED}[-] An error occurred during the installation of curl.${NC}"
fi

# Install packages to allow apt to use a repository over HTTPS
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the stable repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the apt package index again
sudo apt-get update

# Install the latest version of Docker Engine and containerd
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Check if Docker was installed successfully
if [ -x "$(command -v docker)" ]; then
    echo -e "${GREEN}[+] Docker was installed on the server.${NC}"
else
    echo -e "${RED}[-] An error occurred during the installation of Docker.${NC}"
fi

# Install xfreerdp
sudo apt-get install -y freerdp2-x11

# Check if xfreerdp was installed successfully
if command -v xfreerdp &> /dev/null; then
    echo -e "${GREEN}[+] xfreerdp was installed on the server.${NC}"
else
    echo -e "${RED}[-] An error occurred during the installation of xfreerdp.${NC}"
fi

# Install smbclient
sudo apt-get install -y smbclient

# Check if smbclient was installed successfully
if command -v smbclient &> /dev/null; then
    echo -e "${GREEN}[+] smbclient was installed on the server.${NC}"
else
    echo -e "${RED}[-] An error occurred during the installation of smbclient.${NC}"
fi

# Install nmap
sudo apt-get install -y nmap

# Check if nmap was installed successfully
if command -v nmap &> /dev/null; then
    echo -e "${GREEN}[+] nmap was installed on the server.${NC}"
else
    echo -e "${RED}[-] An error occurred during the installation of nmap.${NC}"
fi

# Install krb5-user and related packages
sudo apt-get install -y krb5-user libpam-krb5 libpam-ccreds auth-client-config

# Check if krb5 is installed successfully
if command -v kinit &> /dev/null; then
    echo -e "${GREEN}[+] Kerberos 5 (krb5) was installed on the server.${NC}"
else
    echo -e "${RED}[-] An error occurred during the installation of krb5.${NC}"
fi

# Install crackmapexec using pipx
command_exists() {
    command -v "$@" >/dev/null 2>&1
}

# Install pipx if it is not already installed
if ! command_exists pipx; then
    echo -e "${YELLOW}[!] pipx not found, installing pipx...${NC}"
    sudo apt-get update
    sudo apt-get install -y python3-pip
    python3 -m pip install --user pipx
    python3 -m pipx ensurepath
else
    echo -e "${GREEN}[+] pipx is already installed.${NC}"
fi

if ! command_exists crackmapexec; then
    pipx install crackmapexec
    if command_exists crackmapexec; then
        echo -e "${GREEN}[+] crackmapexec was successfully installed.${NC}"
    else
        echo -e "${RED}[-] An error occurred during the installation of crackmapexec.${NC}"
    fi
else
    echo -e "${YELLOW}[!] crackmapexec is already installed.${NC}"
fi
# Install ldap-utils
sudo apt-get install -y ldap-utils

# Check if ldap-utils was installed successfully
if command -v ldapsearch &> /dev/null; then
    echo -e "${GREEN}[+] ldap-utils was installed on the server.${NC}"
else
    echo -e "${RED}[-] An error occurred during the installation of ldap-utils.${NC}"
fi

# Install pipx if it is not already installed
if ! command_exists pipx; then
    echo -e "${YELLOW}[!] pipx not found, installing pipx...${NC}"
    sudo apt-get update
    sudo apt-get install -y python3-pip
    python3 -m pip install --user pipx
    python3 -m pipx ensurepath
else
    echo -e "${GREEN}[+] pipx is already installed.${NC}"
fi

# Install Impacket using pipx
if ! command_exists impacket-smbserver; then
    pipx install impacket
    if command_exists impacket-smbserver; then
        echo -e "${GREEN}[+] Impacket was successfully installed.${NC}"
    else
        echo -e "${RED}[-] An error occurred during the installation of Impacket.${NC}"
    fi
else
    echo "Impacket is already installed."
fi

# Ensure Snap is installed
if ! command_exists snap; then
    echo -e "${YELLOW}[!] Snap is not installed. Installing Snap...${NC}"
    sudo apt update
    sudo apt install -y snapd
else
    echo -e "${GREEN}[+] Snap is already installed.${NC}"
fi

# Install enum4linux using Snap
if ! command_exists enum4linux; then
    sudo snap install enum4linux-ng
    if command_exists enum4linux-ng; then
        echo -e "${GREEN}[+] enum4linux was successfully installed.${NC}"
    else
        echo -e "${RED}[-] An error occurred during the installation of enum4linux.${NC}"
    fi
else
    echo -e "${GREEN}[+] enum4linux is already installed.${NC}"
fi

# Install hashcat
sudo apt-get install -y hashcat

# Check if hashcat was installed successfully
if command -v hashcat &> /dev/null; then
    echo -e "${GREEN}[+] hashcat was installed on the server.${NC}"
else
    echo -e "${RED}[-] An error occurred during the installation of hashcat.${NC}"
fi

# Installing rockyou.txt to /usr/share/wordlists/rockyou.txt
folder_path="/usr/share/wordlists"
file_url="https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt"
file_name=$(basename "$file_url")

# Check if the folder exists
if [ -d "$folder_path" ]; then
    echo -e "${GREEN}[+] The folder $folder_path exists.${NC}"
else
    echo -e "${YELLOW}[!] The folder $folder_path does not exist. Creating it now...${NC}"
    sudo mkdir -p "$folder_path"
    # Download rockyou.txt to the folder
	echo -e "${YELLOW}[!] Downloading file to $folder_path...${NC}"
	sudo wget -O "$folder_path/$file_name" "$file_url"
	echo -e "${GREEN}[+] Download complete.${NC}"
fi

# Install Python development libraries and LDAP development libraries
sudo apt-get install -y python3-dev libldap2-dev libsasl2-dev

# Install sprayhound
pip3 install sprayhound

# Check if sprayhound was installed successfully
if command_exists sprayhound; then
    echo -e "${GREEN}[+] sprayhound was successfully installed.${NC}"
else
    echo -e "${RED}[-] An error occurred during the installation of sprayhound.${NC}"
fi

# Install bloodhound.py
pip3 install bloodhound

# Check if bloodhound.py was installed successfully
if command_exists bloodhound; then
    echo -e "${GREEN}[+] bloodhound.py was successfully installed.${NC}"
fi

# Install Java (required by Neo4j)
sudo apt-get install -y default-jdk

# Install Neo4j
wget -O - https://debian.neo4j.com/neotechnology.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/neo4j.gpg
echo "deb [signed-by=/usr/share/keyrings/neo4j.gpg] https://debian.neo4j.com stable 4.4" | sudo tee /etc/apt/sources.list.d/neo4j.list > /dev/null
sudo apt-get update
sudo apt-get install -y neo4j

# Start Neo4j service
sudo systemctl start neo4j.service

# Download and extract BloodHound
wget https://github.com/BloodHoundAD/BloodHound/releases/download/4.0.3/BloodHound-linux-x64.zip
unzip BloodHound-linux-x64.zip -d BloodHound

# Cleanup downloaded zip file
rm BloodHound-linux-x64.zip

echo -e "${GREEN}[+] BloodHound installation complete. Start Neo4j and open BloodHound.${NC}"
