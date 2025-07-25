#!/bin/bash
env="${env:-default prod}"
target="${target:-default both}"
entry="lib/main.dart"
pTag="\033[1;33m[PIAPIRI]\033[0m"
programname=$0
function usage {
    echo ""
    echo "Create AAB and IPA for the app"
    echo ""
    echo "usage: $programname --env string --target string"
    echo ""
    echo "  --env string            env to which to deploy"
    echo "                          default: prod"
    echo "                          options: dev | qa | prod"
    echo "  --target string         target operating system"
    echo "                          default: both"
    echo "                          options: ios | android"
    echo ""
}

function clear {
    echo -e "$pTag Clearing . . ."
    # # Clean the previous build
    flutter clean
}

function getpkg {
    # # Get all the dependencies
    echo -e "$pTag Getting packages . . ."
    flutter pub get
}

function buildrunner {
    echo -e "$pTag Creating routes . . ."
    flutter packages pub run build_runner build
}

function android {
    flutter build appbundle --flavor prod --release --target $entry --no-tree-shake-icons
    echo -e "$pTag Appbundle built successfully."
}

function ios {
    flutter build ipa --flavor prod --target $entry 
    echo -e "$pTag IPA built successfully."
    echo -e "$pTag Build completed successfully."
}

while [ $# -gt 0 ]; do
    if [[ $1 == "--help" ]]; then
        usage
        exit 0
    elif [[ $1 == "--"* ]]; then
        v="${1/--/}"
        if [[ "$v" != "env" && "$v" != "target" ]]; then
            echo -e "$pTag Please pass valid flag. Valid flags: env | target"
            exit 0
        fi
        eval "$v=\"$2\""  # Using eval for indirect assignment
        shift
    fi
    shift
done

echo -e "$pTag Building app with env: $env and target: $target"

if [[ $env == "dev" ]]; then
    entry="lib/main_dev.dart"
elif [[ $env == "qa" ]]; then
    entry="lib/main_qa.dart"
elif [[ $env == "prod" ]]; then
    entry="lib/main.dart"
fi

if [[ $target == "ios" ]]; then
    clear
    getpkg
    buildrunner
    ios
elif [[ $target == "android" ]]; then
    clear
    getpkg
    buildrunner
    android
else
    clear
    getpkg
    buildrunner
    android
    ios
fi