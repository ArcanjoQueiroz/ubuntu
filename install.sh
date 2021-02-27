#!/bin/bash

# Configuration functions

function configure_aliases() {
  echo "Configuring Aliases..."
  echo 'function docker-remove() {
CONTAINER_IDS=$(docker ps -a -q)
IMAGE_IDS=$(docker images -q)
VOLUMES=$(docker volume ls -f "dangling=true" | head -n -1)
NETWORKS=$(docker network ls | grep -v "NETWORK" -q | awk "//{ print $1 }")

! [ -z $CONTAINER_IDS ] && docker stop $CONTAINER_IDS && docker rm -f $CONTAINER_IDS
! [ -z $IMAGE_IDS ] && docker rmi -f $IMAGE_IDS
! [ -z $VOLUMES ] && docker volume rm $VOLUMES
! [ -z $NETWORKS ] && docker network rm $NETWORKS
}

alias me="curl ifconfig.me"
alias pbcopy="xclip -selection clipboard"
alias pbpaste="xclip -selection clipboard -o"
alias clipboard="xsel -i --clipboard"' > ~/.bash_aliases
}

function configure_git() {
  echo "Configuring Git..."
  echo ".classpath
.project
.settings
target
bin
.idea
*.log
*.*~
*.out
.class
*.pyc
*.pyo
*.swp
*.swo
node_modules
package.lock" > ~/.gitignore && \
        git config --global core.excludesfile ~/.gitignore && \
        git config --global diff.tool meld && \
        git config --global difftool.prompt false && \
        git config --global merge.tool meld && \
        git config --global mergetool.keepbackup false && \
        git config --global core.editor "vim" && \
        git config --global core.commentchar "@" && \
        git config --global http.postBuffer 524288000 && \
        git config --global http.sslVerify false && \
        git config --global grep.lineNumber true && \
        git config --global pull.rebase true && \
        git config --global remote.origin.prune true && \
        git config --global alias.s 'stash --all' && \
        git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
}

function configure_vim() {
  echo "Configuring vim..."
  echo 'syntax enable

set autoindent
set smartindent

set number
set encoding=utf-8

set ignorecase
set hlsearch
set incsearch

nnoremap <esc><esc> :noh<return>

set clipboard=unnamedplus

autocmd FileType html,css,ruby,javascript,java,dart,kotlin setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType python,bash,sh setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType make setlocal noexpandtab
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

autocmd FileType ruby,javascript,java,python,bash,sh,html,css,yaml,make autocmd BufWritePre * %s/\s\+$//e' > ~/.vimrc
}

# Installation functions

function install_libraries() {
    echo "Installing Libraries..."
        sudo apt-get install -y build-essential \
        checkinstall \
        libreadline-gplv2-dev \
        libncursesw5-dev \
        libssl-dev \
        libsqlite3-dev \
        tk-dev \
        libgdbm-dev \
        libc6-dev \
        libbz2-dev \
        apt-transport-https \
        ca-certificates \
        software-properties-common \
        openvpn \
        openssh-client \
        openssh-server \
        zip \
        unzip \
        sed \
        curl \
        wget \
        jq \
        xclip \
        xsel \
        htop
}

function install_terminator() {
  echo "Installing Terminator..."
  sudo apt-get install -y terminator
}

function install_vim() {
  echo "Installing Vim..."
  sudo apt-get install -y vim && configure_vim
}

function install_git() {
  if ! [ -x "$(command -v git)" ]; then
    echo "Installing Git..."
    sudo apt-get install -y git && configure_git
  else
    echo "Git is already installed"
  fi
}

function install_meld() {
  if ! [ -x "$(command -v meld)" ]; then
    echo "Installing Meld..."
    sudo apt-get install -y meld
  else
    echo "Meld is already installed"
  fi
}

function init_sdkman() {
  SDKMAN_DIR=$HOME/.sdkman
  [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
}

function install_sdkman() {
  if ! [ -x "$SDKMAN_DIR" ]; then
    echo "Installing SDKMan..."
    cd ~ && curl -s "https://get.sdkman.io" | bash
  else
    echo "SKDMan is already installed"
  fi
  init_sdkman
  sdk update
}

function install_java() {
  echo "Installing Java..."
  sdk install java 11.0.10-zulu
}

function install_maven3() {
  echo "Installing Maven..."
  sdk install maven 3.6.3
  echo 'alias mci="mvn clean install"
alias mcio="mvn clean install -o"' >> ${HOME}/.bash_aliases
}

function install_visualvm() {
  echo "Installing visualvm..."
  sdk install visualvm 1.4.4
}

function init_nvm() {
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

function install_nvm() {
  if ! [ -x "$NVM_DIR" ]; then
    echo "Installing NVM..."
    cd ~ && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash && source ~/.bashrc
    init_nvm
  else
    echo "NVM is already installed"
  fi
}

function install_npm() {
  if [ -x "$(command -v node)" ]; then
    echo "Node is already installed"
  else
    init_nvm
    nvm install node v14.8.0
  fi
}

function install_docker() {
  echo "Installing Docker..."
  sudo apt-get update && sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common && \
  cd ~ && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(. /etc/os-release; echo "$UBUNTU_CODENAME") stable" && \
  sudo apt-get update && \
  sudo apt-get -y install docker-ce docker-compose
  sudo usermod -aG docker $CURRENT_USER
}

function install_docker_compose() {
  if ! [ -x "$(command -v docker-compose)" ]; then
    echo "Installing Docker-Compose ..."
    cd ~ && sudo curl -L https://github.com/docker/compose/releases/download/1.28.5/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose
  else
    echo "Docker-Compose is already installed"
  fi
}

function install_eclipse() {
    TARGET_DIRECTORY=${HOME}/bin
    ECLIPSE_HOME=${TARGET_DIRECTORY}/eclipse

    if [ ! -d "$ECLIPSE_HOME" ]; then
      echo "Installing Eclipse IDE..."

      mkdir -p ${TARGET_DIRECTORY} && cd ${TARGET_DIRECTORY}
      if [ -e "${TARGET_DIRECTORY}/eclipse-jee.tar.gz" ]; then
        echo "Eclipse File already downloaded";
      else
        echo "Downloading Eclipse Java EE ...";
        cd ~ && wget -O eclipse-jee.tar.gz 'https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/2020-12/R/eclipse-jee-2020-12-R-linux-gtk-x86_64.tar.gz'
      fi

      if [ -d "${TARGET_DIRECTORY}/eclipse" ]; then
        echo "Eclipse was already installed"
      else
        echo "Extracting Eclipse Java EE ..."
        cd ~ && tar -xvzf ${TARGET_DIRECTORY}/eclipse-jee.tar.gz && \
          rm ${TARGET_DIRECTORY}/eclipse-jee.tar.gz

        echo "Configuring eclipse.ini..."
        ECLIPSE_INI=${ECLIPSE_HOME}/eclipse.ini
        sed 's/-Xms.*/-Xms1024m/g' -i ${ECLIPSE_INI}
        sed 's/-Xmx.*/-Xmx4096m/g' -i ${ECLIPSE_INI}

        JAVA_BIN_PATH=${HOME}/.sdkman/candidates/java/current/bin
        echo "Configuring Eclipse VM ..."
        sed "s#-vmargs#-vm\n${JAVA_BIN_PATH}\n-vmargs#" -i ${ECLIPSE_INI}
      fi
    else
      echo "Eclipse is already installed"
    fi

    ECLIPSE_DESKTOP_FILE_DIRECTORY=${HOME}/.local/share/applications
    echo "Configuring eclipse.desktop file..."
    mkdir -p $ECLIPSE_DESKTOP_FILE_DIRECTORY && echo "[Desktop Entry]
Name=Eclipse
Type=Application
Exec=${ECLIPSE_HOME}/eclipse
Terminal=false
Icon=${ECLIPSE_HOME}/icon.xpm
Comment=Integrated Development Environment
NoDisplay=false
Categories=Development;IDE;
Name[en]=Eclipse" > $ECLIPSE_DESKTOP_FILE_DIRECTORY/eclipse.desktop
}

function install_brave_browser() {
  if ! [ -x "$(command -v brave-browser)" ]; then
    echo "Installing brave-browser..."
    cd ~ && curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add - && \
    echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list && \
    sudo apt update && sudo apt install -y brave-browser
  else
    echo "Brave is already installed"
  fi
}

function install_kubectl() {
  if ! [ -x "$(command -v kubectl)" ]; then
    cd ~ && curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && chmod u+x ./kubectl && sudo mv ./kubectl /usr/local/bin/kubectl
  else
    echo "Kubectl is already installed"
  fi
}

function install_helm3() {
  if ! [ -x "$(command -v helm)" ]; then
    cd ~ && curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
  else
    echo "Helm 3 is already installed"
  fi    
}

function install_virtualbox() {
  if ! [ -x "$(command -v virtualbox)" ]; then
    cd ~ && curl -Lo virtualbox "https://download.virtualbox.org/virtualbox/6.1.18/VirtualBox-6.1.18-142142-Linux_amd64.run" && chmod u+x virtualbox && \
    sudo ./virtualbox && rm virtualbox
  else
    echo "Virtualbox is already installed"
  fi
}

function install_micro() {
  if ! [ -x "$(command -v micro)" ]; then
    cd ~ && curl https://getmic.ro | bash && mv micro /usr/local/bin
  else
    echo "Micro is already installed"
  fi    
}

function install_code() {
  if ! [ -x "$(command -v code)" ]; then
    cd ~ && wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/ && \
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' && \
    sudo apt-get update && sudo apt-get install code -y && rm packages.microsoft.gpg
  else
    echo "Code is already installed"
  fi    
}

function install_zsh() {
  sudo apt-get install zsh -y     
}

function install_golang() {
  if ! [ -x "$(which go)" ]; then
    echo "Installing Golang..."
    GO_VERSION=go1.16
    cd ~
    if [ ! -f "${GO_VERSION}.linux-amd64.tar.gz" ]; then
      wget https://dl.google.com/go/${GO_VERSION}.linux-amd64.tar.gz -O ${GO_VERSION}.linux-amd64.tar.gz
    fi
    tar -xzf ${GO_VERSION}.linux-amd64.tar.gz && \
      mv go ${GO_VERSION} && \
      sudo mv ${GO_VERSION} /usr/local/${GO_VERSION} && \
      sudo ln -sf /usr/local/${GO_VERSION} /usr/local/go && \
      rm ${GO_VERSION}.linux-amd64.tar.gz && \
      mkdir -p ${HOME}/golang && \
      echo 'export GOPATH=${HOME}/golang' >> ${HOME}/.profile && \
      echo 'export PATH=${PATH}:/usr/local/go/bin' >> ${HOME}/.profile && \
      echo 'export GOBIN=/usr/local/go/bin' >> ${HOME}/.profile && \
      source ${HOME}/.profile && \
      echo "Installing godep..." && \
      curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh && \
      echo 'alias dep="${GOPATH}/bin/dep"' >> ${HOME}/.bash_aliases
  else
    echo "GoLang is already installed"
  fi
}

# Main

function main() {
  echo "Preparing installation..."

  if [ -z "$USER" ]; then
    CURRENT_USER=$(id -un)
  else
    CURRENT_USER="$USER"
  fi

  export CURRENT_USER
  echo "Current user is $CURRENT_USER"

  if ! [ -x "$(command -v sudo)" ]; then
    apt-get update && apt-get install sudo
  else
    echo "Updating definitions..."
    sudo apt-get update
  fi

  [ -z "$INSTALL_VIRTUALBOX" ] && INSTALL_VIRTUALBOX="y"

  install_libraries && \
  install_terminator && \
  install_vim && \
  install_git && \
  install_meld && \
  install_sdkman && \
  install_java && \
  install_maven3 && \
  install_nvm && \
  install_npm && \
  install_docker && \
  install_docker_compose && \
  install_eclipse && \
  install_brave_browser && \
  install_kubectl && \
  install_helm3 && \
  install_micro && \
  install_code && \
  install_zsh && \
  install_golang
  SUCCESS=$?

  [ $INSTALL_VIRTUALBOX == "y" ] && [ $SUCCESS == 0 ] && install_virtualbox

  SUCCESS=$?

  [ $SUCCESS == 0 ] && echo "Installation was finished. Reboot your system and happy coding...!!!" && \
  echo "Tip: Go to https://ohmyz.sh/ and install Oh My Zsh!! :D"
}

main
