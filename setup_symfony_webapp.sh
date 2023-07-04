#!/bin/bash

read -p "Enter project name: " projectName

# Create Symfony project
symfony new --webapp $projectName

# Navigate to project directory
cd $projectName

# Add php version
read -p "Enter PHP version to use: " phpVersion
echo $phpVersion > .phpversion

# Install Doctrine bundle for entity management and annotations
composer require doctrine/annotations
composer require doctrine/doctrine-bundle
composer require annotations

# Install Twig bundle for template rendering
composer require twig

# Install Symfony form component
composer require symfony/form

# Install Symfony make package
composer require symfony/maker-bundle --dev

# Install Tailwind CSS and PostCSS and create the config file
npm install -D tailwindcss postcss postcss-loader autoprefixer
npx tailwindcss init -p

# Add Tailwind CSS and PostCSS configuration to package.json
jq '.scripts += {"watch-css": "npx tailwindcss build -i assets/styles/app.css -o assets/styles/app.built.css --watch"}' package.json > tmp.json && mv tmp.json package.json
jq '.postcss += {"plugins": {"autoprefixer": {}, "tailwindcss": {}}}' package.json > tmp.json && mv tmp.json package.json

echo "module.exports = {
        plugins: {
          tailwindcss: { config: './tailwind.config.js'},
          autoprefixer: {},
        },
      }" > postcss.config.js

# Create a default Tailwind CSS stylesheet
echo "@import 'tailwindcss/base'; @import 'tailwindcss/components'; @import 'tailwindcss/utilities';" > assets/styles/app.css

# Build Tailwind CSS
npm run build-css

# Update .gitignore to ignore build assets
echo "public/build" >> .gitignore

# Compile Symfony cache
php bin/console cache:clear

# Create .env.example file
echo "###> symfony/dotenv ###" >> .env.example
echo "# Defines the environment variables required for the project." >> .env.example
echo "" >> .env.example
echo "# Database configuration" >> .env.example
echo "DATABASE_URL=sqlite:///%kernel.project_dir%/var/data.db" >> .env.example
echo "" >> .env.example
echo "# App secret" >> .env.example
echo "APP_SECRET=your_app_secret_value_here" >> .env.example
echo "" >> .env.example
echo "# Other configuration variables" >> .env.example
echo "# ..." >> .env.example
echo "" >> .env.example
echo "###< symfony/dotenv ###" >> .env.example

# Create setup.sh script
echo "#!/bin/bash" >> setup.sh
echo "" >> setup.sh
echo "# Install Composer dependencies" >> setup.sh
echo "composer install" >> setup.sh
echo "" >> setup.sh
echo "# Install npm dependencies" >> setup.sh
echo "npm install" >> setup.sh
echo "" >> setup.sh
echo "# Create the SQLite database (if using SQLite)" >> setup.sh
echo "symfony console doctrine:database:create" >> setup.sh
echo "" >> setup.sh
echo "# Run database migrations (if using Doctrine)" >> setup.sh
echo "symfony console doctrine:migrations:migrate" >> setup.sh
echo "" >> setup.sh
echo "# Load fixtures (if using Doctrine Fixtures Bundle)" >> setup.sh
echo "# symfony console doctrine:fixtures:load" >> setup.sh
echo "" >> setup.sh
echo "# Generate SSL keys (if using LexikJWTAuthenticationBundle for JWT authentication)" >> setup.sh
echo "# symfony console lexik:jwt:generate-keypair" >> setup.sh
echo "" >> setup.sh
echo "# Build Tailwind CSS" >> setup.sh
echo "npm run build-css" >> setup.sh
echo "" >> setup.sh
echo "# Compile Symfony cache" >> setup.sh
echo "php bin/console cache:clear" >> setup.sh
echo "" >> setup.sh
echo "echo \"Project setup completed successfully.\"" >> setup.sh

# Make setup.sh executable
chmod +x setup.sh

echo "Project installation completed successfully."
