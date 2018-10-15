#!/bin/bash
# wget https://github.com/senti-platform/senti-client-setup/blob/master/setup.sh && bash setup.sh

# Check if needed software exist
# Create paths
# Download assets (wget + unpack)
# Copy to destinations
# git pull
# npm install (npm --prefix ../senti-mqtt-client ../senti-mqtt-client)
# Add systemd entries
# Start systemd services

clear

# Login
sudo -i

echo Setting up Senti-MQTT-Client

# Create temporary tools work directory
sudo mkdir -p /usr/local/tools
cd /usr/local/tools
pwd

# Install all needed helper software
# Check if needed software exist
echo
echo Checking if needed software is installed ... 

GIT=/usr/bin/git
if [ ! -e "$GIT" ]; then
    echo "GIT is not installed."
	echo "Installing GIT"
	sudo apt install git-all
	git --version
else 
    echo "GIT is already installed"
fi 

NODE=/usr/local/bin/node
if [ ! -e "$NODE" ]; then
    echo "NODEJS is not installed."
	echo "Installing NODEJS"
	sudo curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash && sudo apt-get install -y nodejs && sudo apt-get install build-essential
	node -v
	npm -v
else 
    echo "NODE is already installed"
fi

echo Installing MQTT
sudo npm install mqtt -g

# Create paths
sudo mkdir -p /srv/nodejs/senti

echo 
echo Fetching latest versions of Senti software from GitHub
cd /srv/nodejs/senti
sudo git -C senti-mqtt-client pull || git clone https://github.com/senti-platform/senti-mqtt-client.git
sudo git -C senti-watchman pull || git clone https://github.com/senti-platform/senti-watchman.git
echo 

echo Installing modules and/or upgrades
echo
cd senti-mqtt-client
sudo npm install
sudo mkdir -p /srv/nodejs/senti/senti-mqtt-client/logs
cd ../senti-watchman
sudo npm install

echo
echo Starting senti-mqtt-client service ...
echo
bash run.sh
