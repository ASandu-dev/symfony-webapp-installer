#!/bin/bash

# Install Zsh
sudo apt-get update
sudo apt-get install zsh -y

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
sudo apt-get install php -y

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
