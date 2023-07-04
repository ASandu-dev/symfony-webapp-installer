#!/bin/bash

# Set the project name

cd "../"

read -p "Enter project name: " projectName

# Create the project directory
mkdir "$projectName"
cd "$projectName" || exit

# Initialize Git repository
git init

# Set user name and email for the repository
read -p "Enter git user name: " userName
read -p "Enter git user email: " userEmail

# Configure user name and email for the repository
git config user.name "$userName"
git config user.email "$userEmail"

echo "Git repository initialized with user details."

# Add php version
read -p "Enter php version to use: " phpVersion
echo "$phpVersion" > .phpversion

# Initialize Composer project
composer init --no-interaction --repository=https://packages.drupal.org/8 --name=drupal/project

# Install Drupal core
composer require drupal/core:~9.0 --no-update

# Create necessary directories
mkdir core modules profiles sites themes vendor

# Move files to respective directories
mv vendor .
mv web/* core/
mv web/sites/* sites/
mv web/modules/* modules/
mv web/profiles/* profiles/
mv web/themes/* themes/

# Remove unnecessary files and directories
rm -rf web

# Update Composer dependencies
composer update --no-interaction

echo "Drupal 9 project installation completed."
