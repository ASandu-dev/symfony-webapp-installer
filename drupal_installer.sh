#!/bin/bash

# Function to check if a PHP extension is installed
check_extension() {
  php -m | grep -i "$1" >/dev/null 2>&1
}

# Check if required PHP extensions are installed and enabled
required_extensions=("curl" "gd" "mbstring" "mysqli" "pdo_mysql" "ctype" "iconv" "json" "pcre" "session" "simplexml" "tokenizer")
missing_extensions=()

for extension in "${required_extensions[@]}"; do
  if ! check_extension "$extension"; then
    missing_extensions+=("$extension")
  fi
done

if [[ ${#missing_extensions[@]} -gt 0 ]]; then
  echo "Installing missing PHP extensions: ${missing_extensions[*]}"

  # Install required PHP extensions
  sudo apt-get update
  sudo apt-get install -y php-curl php-gd php-mbstring php-mysqli php-mysql php-ctype php-iconv php-json php-pcre php-session php-simplexml php-tokenizer

  # Add required PHP extensions to php.ini
  extension_dir=$(php -i | grep extension_dir | awk '{print $3}')
  # shellcheck disable=SC2129
  echo "extension=gd.so" >>"$extension_dir/php.ini"
  echo "extension=mbstring.so" >>"$extension_dir/php.ini"
  echo "extension=mysqli.so" >>"$extension_dir/php.ini"
  echo "extension=pdo_mysql.so" >>"$extension_dir/php.ini"
  echo "extension=ctype.so" >>"$extension_dir/php.ini"
  echo "extension=iconv.so" >>"$extension_dir/php.ini"
  echo "extension=json.so" >>"$extension_dir/php.ini"
  echo "extension=pcre.so" >>"$extension_dir/php.ini"
  echo "extension=session.so" >>"$extension_dir/php.ini"
  echo "extension=simplexml.so" >>"$extension_dir/php.ini"
  echo "extension=tokenizer.so" >>"$extension_dir/php.ini"
  # Restart web server (e.g., Apache or Nginx)
  sudo systemctl restart apache2 # Replace with your web server's restart command

  echo "PHP extensions installed and enabled."
fi

# Set the project name
echo "Enter project name:"
read project_name

# Create a new Drupal project
echo "Creating a \"drupal/recommended-project\" project at \"./$project_name\""
composer create-project drupal/recommended-project:^9 "$project_name"

cd "$project_name"

# Install Drupal dependencies
echo "Installing dependencies from lock file (including require-dev)"
composer install

# Verify lock file contents
composer diagnose

# Run the Drupal installer
echo "Running Drupal site installation..."
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

