#!/bin/bash
set -e

function getGithubNpmToken {
    read -p "Go to https://github.com/settings/tokens/new"
    read -p "Fill note field with: NPM_GITHUB_TOKEN"
    read -p "Fill expiration field with: No expiration"
    read -p "Fill scopes field with: read:packages"
    read -sp 'Generate token and paste it: ' npm_github_token

    echo $npm_github_token
}

function getNpmToken {
    read -p "Go to your dashlane"
    read -p "Find NPM_TOKEN in your env var note"
    read -sp 'Paste it: ' npm_token
    echo $npm_token
}

function exportEnvVar {
    local key=$1
    local val=$2
    
    echo -e "\n"
    echo "Exporting $key env var"
    export $key=$val

    echo "Adding export $key=*** to your bashrc; Fill free to move it wherever you like"
    echo "export $key=$val" >> ~/.bashrc
}

function setConfigForGithubNpmRegistry {
    local token=$1

    npm config set @georgestech:registry https://npm.pkg.github.com/
    npm config set //npm.pkg.github.com/:_authToken $token
}

function setConfigForNpmRegistry {
    local token=$1

    npm config set @georges-tech:registry https://registry.npmjs.org
    npm config set //registry.npmjs.org/:_authToken $token
}

function configureGithubNpmRegistry {
    local npm_github_token=$(getGithubNpmToken)
    exportEnvVar "NPM_GITHUB_TOKEN" $npm_github_token
    setConfigForGithubNpmRegistry $npm_github_token
}

function configureNpmRegistry {
    local npm_token=$(getNpmToken)
    exportEnvVar "NPM_TOKEN" $npm_token
    setConfigForNpmRegistry $npm_token
}

function installDenisCLI {
    echo ""
    npm install -g @georgestech/denis-cli 2>&1
}

function main {
    read -p "Press <enter> to move on..."
    configureGithubNpmRegistry
    configureNpmRegistry
    installDenisCLI
}

main