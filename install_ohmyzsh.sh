#!/bin/bash

function install_ohmyzsh_plugins() {
  if [ ! -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-nvm" ]; then
    cd ${HOME}/.oh-my-zsh/custom/plugins && \
    git clone https://github.com/lukechilds/zsh-nvm
  else
    echo "zsh-nvm is already installed"
  fi

  if [ ! -d "${HOME}/.oh-my-zsh/plugins/zsh-sdkman" ]; then
    cd ${HOME}/.oh-my-zsh/plugins && \
    git clone 'https://github.com/matthieusb/zsh-sdkman.git'
  else
    echo "zsh-sdkman is already installed"
  fi
}

function install_ohmyzsh() {
  if [ ! -d "${HOME}/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
}

function main() {
  install_ohmyzsh && \
  install_ohmyzsh_plugins && \
  echo "Installation completed: add zsh-nvm and zsh-sdkman into plugin in ~/.zshrc. Example: " && \
  echo "plugins=(git zsh-sdkman zsh-nvm)"
}

main