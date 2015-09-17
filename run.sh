#! /bin/bash

gitresult=$( { git status | grep "fatal: Not a git repository" > /dev/null; } 2>&1 )
if [[ ! -d "./animation-demo" && "${gitresult}" != "" ]]; then
# Cloning to default dir
    echo "=> Downloading animation-demo from git"
    printf "\r=> "
    command git clone "git@github.com:NativeScript/animation-demo.git"
    cd animation-demo
fi

set -e
npmresult=$(npm list -g | grep 'nativescript@');
if [[ "$npmresult" == "" ]]; then
    npm install -g nativescript
fi

npm install
node_modules/typescript/bin/tsc -p ./app

unamestr=`uname`
if [[ "$unamestr" == "Darwin" ]]; then
    iosresult=$(tns platform list | grep 'Installed platforms.*ios');
    if [[ "$iosresult" == "" ]]; then
        echo "=> Adding platform ios"
        tns platform add ios
    fi
    tns run ios --emulator
else
    androidresult=$(tns platform list | grep 'Installed platforms.*android');
    if [[ "$androidresult" == "" ]]; then
        echo "=> Adding platform android"
        tns platform add android
    fi
    tns run android --emulator
fi