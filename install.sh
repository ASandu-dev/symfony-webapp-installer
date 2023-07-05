#!/bin/bash

# Install Composer
if ! command -v composer &> /dev/null; then
    sudo apt update
    sudo apt install composer
fi

# Install Node.js
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
    sudo apt update
    sudo apt install -y nodejs
fi

# Install Symfony CLI
if ! command -v symfony &> /dev/null; then
    wget https://get.symfony.com/cli/installer -O - | bash
    mv /home/$USER/.symfony5/bin/symfony /usr/local/bin/symfony
fi

# Install PHP
if ! command -v php &> /dev/null; then
    sudo apt update
    sudo apt install -y php
fi

# Install phpenv
if [ ! -d "$HOME/.phpenv" ]; then
    git clone https://github.com/phpenv/phpenv.git ~/.phpenv
    echo 'export PATH="$HOME/.phpenv/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(phpenv init -)"' >> ~/.zshrc
    source ~/.zshrc
fi

# Install PHP versions with phpenv
php_versions=("7.4.1" "8.1.0" "8.2.7")
for version in "${php_versions[@]}"; do
    if [ ! -d "$HOME/.phpenv/versions/$version" ]; then
        phpenv install $version
    fi
done

# Set the latest PHP version as the global version
latest_php_version=$(phpenv versions --bare | grep -v '-' | tail -1)
phpenv global $latest_php_version

# Install Visual Studio Code (code command)
if ! command -v code &> /dev/null; then
    curl -fsSL https://code.visualstudio.com/docs/?dv=linux64_deb | sudo -E bash -
    sudo apt install -y ./code*.deb
    rm ./code*.deb
fi

# Install Zsh
if ! command -v zsh &> /dev/null; then
    sudo apt install -y zsh
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi


# Add paths to the system
echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"' >> ~/.zshrc
echo 'export PATH="$PATH:/usr/local/bin/symfony"' >> ~/.zshrc
echo 'export PATH="$PATH:$HOME/.phpenv/bin"' >> ~/.zshrc
echo 'eval "$(phpenv init -)"' >> ~/.zshrc
echo 'export PATH="$PATH:/usr/local/bin"' >> ~/.zshrc

# Set Zsh as the default shell
chsh -s $(which zsh)

# Install Agnoster theme
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/agnoster" ]; then
    git clone https://github.com/fcamblor/oh-my-zsh-agnoster-fcamblor.git ~/.oh-my-zsh/custom/themes/agnoster
fi
# Reload the Zsh configuration
source ~/.zshrc

echo "Setup completed
