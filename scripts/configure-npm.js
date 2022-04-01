#!/usr/bin/env node

const { promisify } = require('util')
const shell = require('child_process').execSync
const readline = require('readline')
const fs = require('fs/promises')

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
})
const q = promisify(rl.question).bind(rl)

async function getGithubNpmToken() {
    await q("Go to https://github.com/settings/tokens/new")
    await q("Fill note field with: NPM_GITHUB_TOKEN")
    await q("Fill expiration field with: No expiration")
    await q("Fill scopes field with: read:packages")
    const npm_github_token = await q('Generate token and paste it: ')

    return npm_github_token
}

// function getNpmToken() {
//     read -p "Go to your dashlane"
//     read -p "Find NPM_TOKEN in your env var note"
//     read -sp 'Paste it: ' npm_token
//     echo $npm_token
// }

async function exportEnvVar({key, val}) {
    // local key = $1
    // local val = $2
    // echo - e "\n"

    console.log("Exporting $key env var")
    process.env[key] = val

    console.log("Adding export $key=*** to your bashrc; Fill free to move it wherever you like")
    await fs.appendFile('~/.bashrc', `export ${key}=${val}`, {encoding: 'utf-8'})
}

async function setConfigForGithubNpmRegistry({token}) {
    shell('npm config set @georgestech:registry https://npm.pkg.github.com/')
    shell(`npm config set //npm.pkg.github.com/:_authToken ${token}`)
}

// function setConfigForNpmRegistry({token}) {
//     npm config set @georges-tech:registry https://registry.npmjs.org
//     npm config set //registry.npmjs.org/:_authToken $token
// }

async function configureGithubNpmRegistry() {
    const npm_github_token = await getGithubNpmToken()
    await exportEnvVar({key: "NPM_GITHUB_TOKEN", val: npm_github_token})
    // await setConfigForGithubNpmRegistry({token: npm_github_token})
}

// function configureNpmRegistry() {
//     local npm_token=$(getNpmToken)
//     exportEnvVar "NPM_TOKEN" $npm_token
//     setConfigForNpmRegistry $npm_token
// }

async function installDenisCLI() {
    // echo ""
  shell('yarn global add github:georgestech/denis-cli 2>&1')
}

async function main() {
    await q("Press <enter> to move on...")
    await configureGithubNpmRegistry()
    // configureNpmRegistry
    await installDenisCLI()

    rl.close()
}

main()
    .catch((err) => {
        console.log(err)
        // process.exit(1)
    })
