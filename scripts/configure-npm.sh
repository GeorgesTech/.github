#!/bin/bash
set -e

function getPackageToken {
    local need_write=$1
    [[ "$need_write" = true ]] && token_name="WRITE_PACKAGE_TOKEN" || token_name="READ_PACKAGE_TOKEN"
    [[ "$need_write" = true ]] && scopes="write:packages, read:packages" || scopes="read:packages"

    read -p "Go to https://github.com/settings/tokens/new and press <enter>"
    read -p "Fill note field with: $token_name and press <enter>"
    read -p "Fill expiration field with: No expiration and press <enter>"
    read -p "Fill scopes field with: $scopes and press <enter>"
    read -sp 'Generate token and paste it: ' package_token

    echo $package_token
}

function setConfigForGithubNpmRegistry {
    local token=$1

    npm config set @georgestech:registry https://npm.pkg.github.com/
    npm config set //npm.pkg.github.com/:_authToken $token
}

function installDenisCLI {
    echo "npm install -g @georgestech/denis-cli"
    npm install -g @georgestech/denis-cli 2>&1
}

function main {
    read -p "Follow the instructions and press <enter>"
    
    read -p "Do you need to publish packages to github registry (y/n)? " need_write
    [[ "$need_write" = "y" ]] && local need_write=true || local need_write=false

    local package_token=$(getPackageToken $need_write)
    setConfigForGithubNpmRegistry $package_token
    installDenisCLI
}

main