#!/bin/bash

read -p "Enter project name: " projectName

# Create Symfony project
symfony new --webapp $projectName

# Navigate to project directory
cd $projectName

#Add php version
read -p "Enter php version to use:" phpVersion
echo $phpVersion > .phpversion

# Install Doctrine bundle for entity management and annotations
composer require doctrine/annotations
composer require doctrine/doctrine-bundle
composer require annotations


# Install Twig bundle for template rendering
composer require twig

# Install Symfony form component
composer require symfony form

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

echo "Project setup completed successfully."
