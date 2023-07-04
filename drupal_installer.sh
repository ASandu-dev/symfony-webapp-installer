#!/bin/bash

# Set the project name
cd "../"
#!/bin/bash

# Check if PHP GD extension is installed and enabled
if ! php -m | grep -i -q gd; then
    echo "PHP GD extension is missing. Installing and enabling..."
    
    # Install GD extension for PHP
    sudo apt-get update
    sudo apt-get install -y php-gd
    
    # Enable GD extension
    sudo phpenmod gd
    
    echo "PHP GD extension has been installed and enabled."
fi

# Run the Drupal installer
echo "Enter project name:"
read project_name

echo "Creating a \"drupal/recommended-project\" project at \"./\""
composer create-project drupal/recommended-project:^9 "$project_name"

cd "$project_name"

# Install Drupal dependencies
echo "Installing dependencies from lock file (including require-dev)"
composer install

# Verify lock file contents
composer diagnose

# Run the Drupal installer
vendor/bin/drupal site:install --db-type=mysql --db-host=localhost --db-name=your_db_name --db-user=your_db_user --db-pass=your_db_password --site-name=DrupalSite --account-name=admin --account-pass=admin_password


# Move files to respective directories
mv web/* .

# Move directories to correct locations
mv web/sites/* sites/
mv web/modules/* modules/
mv web/profiles/* profiles/
mv web/themes/* themes/

# Remove unnecessary files and directories
rm -rf web

# Update Composer dependencies
composer update --with-dependencies

# Add required PHP extensions to php.ini
extension_dir=$(php -i | grep extension_dir | awk '{print $3}')
echo "extension=gd.so" >> "$extension_dir/php.ini"
echo "extension=mbstring.so" >> "$extension_dir/php.ini"
echo "extension=mysqli.so" >> "$extension_dir/php.ini"
echo "extension=pdo_mysql.so" >> "$extension_dir/php.ini"

echo "Drupal 9 project installation completed."
