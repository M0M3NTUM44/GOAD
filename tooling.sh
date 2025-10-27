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


# Install net-tools
sudo apt install net-tools -y

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
sudo apt-get install -y krb5-user libpam-krb5 libpam-ccreds

# Define the Kerberos realm and server
realm="ESSOS.LOCAL"
server="meereen.essos.local"

# Update /etc/krb5.conf
sudo tee /etc/krb5.conf > /dev/null <<EOF
[libdefaults]
	default_realm = essos.local
	kdc_timesync = 1
  	ccache_type = 4
  	forwardable = true
  	proxiable = true
  	fcc-mit-ticketflags = true

[realms]
  north.sevenkingdoms.local = {
      kdc = winterfell.north.sevenkingdoms.local
      admin_server = winterfell.north.sevenkingdoms.local
  }
  sevenkingdoms.local = {
      kdc = kingslanding.sevenkingdoms.local
      admin_server = kingslanding.sevenkingdoms.local
  }
  essos.local = {
      kdc = meereen.essos.local
      admin_server = meereen.essos.local
  }

[domain_realm]
    .$realm = $realm
    $realm = $realm
EOF

echo -e "${GREEN}[+] Kerberos configuration updated with realm $realm and server $server.${NC}"


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

if ! command_exists crackmapexec; then
    sudo snap install crackmapexec
    if command_exists crackmapexec; then
        echo -e "${GREEN}[+] crackmapexec was successfully installed.${NC}"
    else
        echo -e "${RED}[-] An error occurred during the installation of crackmapexec.${NC}"
    fi
else
    echo -e "${YELLOW}[!] crackmapexec is already installed.${NC}"
fi
# Adding cme as alias to crackmapexec
alias_command="alias cme='crackmapexec'"
config_file="${HOME}/.bashrc"
if grep -q "alias cme='crackmapexec'" "$config_file"; then
    echo -e "${GREEN}[+] Alias for crackmapexec already exists in $config_file${NC}"
else
    # Append the alias to the configuration file
    echo "$alias_command" >> "$config_file"
    echo -e "${GREEN}[+] Added alias for crackmapexec to $config_file${NC}"
fi

# Inform the user to restart the terminal or source the configuration file
echo -e "${YELLOW}[!] Please restart your terminal or run 'source $config_file' to use the alias.${NC}"

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

# Fix ntlmrelayx.py jinja error
sudo pip3 install Flask Jinja2 --upgrade

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
    sudo snap install enum4linux
    if command_exists enum4linux; then
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
pipx install bloodhound-ce

# Check if bloodhound.py was installed successfully
if command_exists bloodhound-ce-python; then
    echo -e "${GREEN}[+] bloodhound.py was successfully installed.${NC}"
fi

# Define bloodhound.py as alias for bloodhound-python
alias_command="alias bloodhound.py='bloodhound-ce-python'"
config_file="${HOME}/.bashrc"
if grep -q "alias bloodhound.py='bloodhound-ce-python'" "$config_file"; then
    echo -e "${GREEN}[+] Alias for bloodhound-ce-python already exists in $config_file${NC}"
else
    # Append the alias to the configuration file
    echo "$alias_command" >> "$config_file"
    echo -e "${GREEN}[+] Added alias for bloodhound-ce-python to $config_file${NC}"
    echo -e "${YELLOW}[!] Please restart your terminal or run 'source $config_file' to use the alias.${NC}"
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

# Install Responder.py
responder_dir="/opt/Responder"

# Check if git is installed, if not, install it
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}[!] Git is not installed. Installing Git...${NC}"
    sudo apt-get install -y git
fi

# Clone Responder
if [ ! -d "$responder_dir" ]; then
    echo -e "${YELLOW}[!] Cloning Responder into $responder_dir...${NC}"
    sudo git clone https://github.com/lgandx/Responder.git "$responder_dir"
    echo -e "${GREEN}[+] Responder has been successfully cloned.${NC}"
else
    echo -e "${GREEN}[+] Responder directory already exists.${NC}"
fi

# Adding /opt/Responder to PATH
config_file="${HOME}/.bashrc"
if ! grep -q "$responder_dir" "$config_file"; then
    echo "export PATH=\"\$PATH:$responder_dir\"" >> "$config_file"
    echo -e "${GREEN}[+] Responder directory added to PATH in $config_file${NC}"
else
    echo -e "${GREEN}[+] Responder directory already in PATH${NC}"
fi

# Inform the user to source the updated configuration file or restart the terminal
echo -e "${YELLOW}[!] Please restart your terminal or run 'source $config_file' to apply the changes.${NC}"

# Define the entries to add to /etc/hosts
entries_to_add=("# GOAD"
	"192.168.56.10   sevenkingdoms.local kingslanding.sevenkingdoms.local kingslanding"
	"192.168.56.11   winterfell.north.sevenkingdoms.local north.sevenkingdoms.local winterfell"
	"192.168.56.12   essos.local meereen.essos.local meereen"
	"192.168.56.22   castelblack.north.sevenkingdoms.local castelblack"
	"192.168.56.23   braavos.essos.local braavos"
)

# Function to check if an entry exists in /etc/hosts
entry_exists() {
    local entry="$1"
    grep -qF -- "$entry" /etc/hosts
}

# Add each entry to /etc/hosts if it doesn't already exist
for entry in "${entries_to_add[@]}"; do
    if ! entry_exists "$entry"; then
        echo -e "${YELLOW}[!] Adding $entry to /etc/hosts${NC}"
        echo "$entry" | sudo tee -a /etc/hosts > /dev/null
    else
        echo -e "${GREEN}[+] Entry $entry already exists in /etc/hosts${NC}"
    fi
done

echo -e "${GREEN}[+] Update to /etc/hosts complete.${NC}"

# Install proxychains
sudo apt install proxychians -y

# Check if proxychains was installed successfully
if command -v proxychains &> /dev/null; then
    echo -e "${GREEN}[+] proxychains was installed on the server.${NC}"
else
    echo -e "${RED}[-] An error occurred during the installation of proxychains.${NC}"
fi
# Install lsassy
sudo pip install lsassy

# Check if lsassy was installed successfully
if command -v lsassy &> /dev/null; then
    echo -e "${GREEN}[+] lsassy was installed on the server.${NC}"
else
    echo -e "${RED}[-] An error occurred during the installation of lsassy.${NC}"
fi

# Install DonPapi
sudo pipx install donpapi

# Check if donpapi was installed successfully
if command -v DonPAPI &> /dev/null; then
    echo -e "${GREEN}[+] DonPapi was installed on the server.${NC}"
else
    echo -e "${RED}[-] An error occurred during the installation of DonPapi.${NC}"
fi

# Installing Coercer using pip3
cd /opt && git clone https://github.com/p0dalirius/Coercer.git
sudo python3 -m pip install coercer

# Adding /opt/Coercer to PATH
config_file="${HOME}/.bashrc"
coercer_dir="/opt/Coercer"

if ! grep -q "$coercer_dir" "$config_file"; then
    echo "export PATH=\"\$PATH:$coercer_dir\"" >> "$config_file"
    echo -e "${GREEN}[+] Coercer directory added to PATH in $config_file${NC}"
else
    echo -e "${GREEN}[+] Coercer directory already in PATH${NC}"
fi

# Installing impacket module "myimpacket" 
cd /opt
git clone https://github.com/SecureAuthCorp/impacket myimpacket
cd myimpacket
pip3 install virtualenv
python3 -m virtualenv myimpacket
source myimpacket/bin/activate
python3 -m pip install .

# Pulling spacific PR
git fetch origin pull/1224/head:1224
git fetch origin pull/1202/head:1202
cd /usr/local/bin && wget https://gist.githubusercontent.com/snovvcrash/3bf1a771ea6b376d374facffa9e43383/raw/d4191e295c96bc1cfb0a54b18cfbb8b21d25b483/renameMachine.py && chmod +x && cd /home/goad

#Adding krbrelayx
cd /opt && git clone https://github.com/dirkjanm/krbrelayx.git
chmod u+x *

config_file="${HOME}/.bashrc"
if ! grep -q "/opt/krbrelayx" "$config_file"; then
    echo "export PATH=\"\$PATH:/opt/krbrelayx\"" >> "$config_file"
    echo -e "${GREEN}[+] krbrelayx directory added to PATH in $config_file${NC}"
else
    echo -e "${GREEN}[+] krbrelayx directory is already in PATH${NC}"
fi

# Change shabeng to python3 if needed
cd /opt/krbrelayx
sed -i '1s/env python$/env python3/' addspn.py
sed -i '1s/env python$/env python3/' dnstool.py
sed -i '1s/env python$/env python3/' krbrelayx.py
sed -i '1s/env python$/env python3/' printerbug.py
cd /home/goad

# Checking if installed
if command -v addspn.py &> /dev/null; then
    echo -e "${GREEN}[+] krbrelayx was installed on the server.${NC}"
else
    echo -e "${RED}[-] An error occurred during the installation of krbrelayx.${NC}"
fi

# Add describeTicket.py to bin
cd /usr/local/bin
wget https://github.com/fortra/impacket/raw/refs/heads/master/examples/describeTicket.py
chmod +x describeTicket.py

# Checking if installed
if command -v describeTicket.py &> /dev/null; then
    echo -e "${GREEN}[+] describeTicket was installed on the server.${NC}"
 else
    echo -e "${RED}[-] An error occurred during the installation of describeTicket.${NC}"
fi

# Replace getST.py in bin folder
rm /usr/local/bin/getST.py
cd /usr/local/bin
wget https://github.com/fortra/impacket/raw/refs/heads/master/examples/getST.py
chmod +x getST.py

# Checking if replaced
if command -v getST.py &> /dev/null; then
    echo -e "${GREEN}[+] getST.py  was replaced in /usr/local/bin folder.${NC}"
else
    echo -e "${RED}[-] An error occurred during the installation of describeTicket.${NC}"
fi

# Install MinGW-w64 (GCC cross-compiler for Windows)
echo -e "${YELLOW}[!] Installing MinGW-w64 (gcc-mingw-w64-x86-64)...${NC}"
sudo apt-get update
if sudo apt-get install -y gcc-mingw-w64-x86-64; then
  # the binary provided by the package is usually x86_64-w64-mingw32-gcc
  if command -v x86_64-w64-mingw32-gcc &> /dev/null; then
    echo -e "${GREEN}[+] gcc-mingw-w64-x86-64 (x86_64-w64-mingw32-gcc) was installed on the server.${NC}"
  else
    echo -e "${YELLOW}[!] gcc-mingw-w64-x86-64 installed but expected binary not found in PATH.${NC}"
  fi
else
  echo -e "${RED}[-] An error occurred during the installation of gcc-mingw-w64-x86-64.${NC}"
fi

