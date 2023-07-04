#!/bin/bash

# Set the project name
project_name="mydrupalproject"

# Create the project directory
mkdir "$project_name"
cd "$project_name"

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
