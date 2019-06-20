#!/bin/bash

function install_paper_icon_theme() {
    sudo add-apt-repository -y ppa:snwh/ppa && \
    sudo apt-get install -y paper-icon-theme
}

function main() {
    echo "Starting installation..."
    install_paper_icon_theme
}

main
