#!/bin/bash

# Function to install a package if not installed
install_if_missing() {
    PACKAGE=$1
    if ! command -v "$PACKAGE" &> /dev/null; then
        echo "$PACKAGE is not installed. Installing..."
        apt install -y "$PACKAGE"
    else
        echo "$PACKAGE is already installed."
    fi
}

# Update package lists
apt update -y

# Check and install required packages
install_if_missing git
install_if_missing screen
install_if_missing curl

# Install NVM and Node.js (LTS)
if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
fi

# Load NVM into the script environment
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads bash_completion

# Verify NVM is loaded, then install Node.js LTS
if ! command -v nvm &> /dev/null; then
    echo "Error: NVM failed to load. Please check your installation."
    exit 1
fi
if ! command -v node &> /dev/null; then
    echo "Installing Node.js LTS..."
    nvm install --lts
fi

# Install required NPM packages globally
npm install -g random-useragent axios

# Clone the repository and set up the bot
if [ ! -d "depinedBot" ]; then
    echo "Cloning repository..."
    git clone https://github.com/Zlkcyber/depinedBot.git
fi
cd depinedBot || exit
npm install

# Add token file
echo "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFsdmFyZXpraW5nNjVAZ21haWwuY29tIiwiaWQiOiJmM2IxMDM0OC1iMjdiLTQ4NjgtYWNhNy02YTVjNjBkM2IxZjAifQ.OhmXWVlZgOc6W3Wgmu_jWy7lTbHpdMPhWq9lxgBt4ig" > depinedBot/token.txt

# Create or attach to a screen session named "depined" and run the bot
echo "Starting the bot in a new 'depined' screen session..."
screen -dmS depined bash -c "npm run start"

echo "Bot is now running in a detached screen session named 'depined'."
echo "To attach to the screen session, use: screen -r depined"
