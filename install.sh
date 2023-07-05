#!/bin/bash

# Install Zsh
sudo apt-get update
sudo apt-get install zsh -y

# Install Git and GitHub CLI
sudo apt-get install git -y
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
sudo apt-add-repository https://cli.github.com/packages
sudo apt-get update
sudo apt-get install gh -y


# Set Zsh as the default shell
chsh -s $(which zsh)

# Install Oh My Zsh (Optional, but recommended)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Symfony CLI
wget https://get.symfony.com/cli/installer -O - | bash
export PATH="$HOME/.symfony/bin:$PATH"

# Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Install PHP
sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get update
sudo apt-get install php8.2 -y

# Install PHP Env
curl -L https://github.com/phpenv/phpenv-installer/raw/master/bin/phpenv-installer | bash
echo 'export PATH="$HOME/.phpenv/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(phpenv init -)"' >> ~/.zshrc

# Install Node Env
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.zshrc

# Source the .zshrc file to apply the changes immediately
source ~/.zshrc

echo "Installation completed."
```

This modified script installs PHP version 8.2.7 by adding the Ondřej Surý PPA repository and updating the package list. It then installs PHP 8.2 using the `php8.2` package.
