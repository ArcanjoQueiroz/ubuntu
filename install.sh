#!/bin/bash

# Operating System Detection Functions

function is_valid_os() {
  export DISTRIB_ID=$(cat /etc/os-release | grep "^ID=" | cut -d '=' -f 2)
  export VERSION_ID=$(cat /etc/os-release | grep "^VERSION_ID=" | cut -d '=' -f 2)

  echo "Target Distribution: $DISTRIB_ID"
  echo "Target Version: $VERSION_ID"

  MINT="n"; UBUNTU="n"

  is_mint && MINT="y"
  is_ubuntu && UBUNTU="y"

  [ $UBUNTU == "y" ] || [ $MINT == "y" ]
  return $?
}

function is_mint() {
  [ $DISTRIB_ID == "linuxmint" ] &&
    ( [ $VERSION_ID == \""19\"" ] ||
      [ $VERSION_ID == \""19.1\"" ] ||
      [ $VERSION_ID == \""19.2\"" ] ||
      [ $VERSION_ID == \""19.3\"" ] )
  return $?
}

function is_ubuntu_19_10() {
  [ $DISTRIB_ID == "ubuntu" ] && [ $VERSION_ID == \""19.10\"" ]
  return $?
}

function is_ubuntu() {
  [ $DISTRIB_ID == "ubuntu" ] && \
      ( [ $VERSION_ID == \""18.04\"" ] || \
        [ $VERSION_ID == \""19.04\"" ] || \
        [ $VERSION_ID == \""19.10\"" ] )
  return $?
}

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

function install_gcc8() {
  echo "Installing GCC-8..."
  sudo apt-get install -y gcc-8
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
    curl -s "https://get.sdkman.io" | bash
  else
    echo "SKDMan is already installed"
  fi
  init_sdkman
  sdk update
}

function install_java13() {
  JAVA_VERSION=13.0.2-zulu
  echo "Installing Java $JAVA_VERSION..."
  sdk install java $JAVA_VERSION
}

function install_maven3() {
  MAVEN_VERSION=3.6.3
  echo "Installing Maven $MAVEN_VERSION..."
  sdk install maven $MAVEN_VERSION
}

function install_spring() {
  SPRING_BOOT_VERSION=2.2.2.RELEASE
  echo "Installing Spring Boot CLI $SPRING_BOOT_VERSION..."
  sdk install springboot $SPRING_BOOT_VERSION
}

function install_visualvm() {
  VISUALVM_VERSION=1.4.4
  echo "Installing visualvm $VISUALVM_VERSION..."
  sdk install visualvm $VISUALVM_VERSION
}

function install_gradle() {
  GRADLE_VERSION=5.6.1
  echo "Installing Gradle $GRADLE_VERSION..."
  sdk install gradle $GRADLE_VERSION
}

function install_kotlin() {
  KOTLIN_VERSION=1.3.61
  echo "Installing Kotlin $KOTLIN_VERSION..."
  sdk install kotlin $KOTLIN_VERSION
}

function install_leiningen() {
  LEININGEN_VERSION=2.9.0
  echo "Installing Leiningen $LEININGEN_VERSION..."
  sdk install leiningen $LEININGEN_VERSION
}

function init_nvm() {
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

function install_nvm() {
  if ! [ -x "$NVM_DIR" ]; then
    NVM_VERSION="v0.33.11"
    echo "Installing NVM $NVM_VERSION..."
    curl -o- "https://raw.githubusercontent.com/creationix/nvm/$NVM_VERSION/install.sh" | bash && source ~/.bashrc
    init_nvm
  else
    echo "NVM is already installed"
  fi
}

function install_npm() {
  NODE_VERSION=v13.5.0
  if [ -x "$(command -v node)" ] && [ "$(node -v)" == $NODE_VERSION ]; then
    echo "Node $NODE_VERSION is already installed"
  else
    echo "Installing node $NODE_VERSION..."
    init_nvm
    nvm install node $NODE_VERSION
  fi
}

function install_docker_using_snap() {
  echo "Installing Docker using Snap..."

  egrep -i "^docker" /etc/group;
  if [ $? -eq 0 ]; then
    echo "Group docker already exists"
  else
    sudo addgroup --system docker && \
    sudo adduser $CURRENT_USER docker && \
    newgrp docker
  fi

  sudo snap install docker && \
  sudo snap connect docker:home
  sudo snap disable docker
  sudo snap enable docker
}

function install_docker_using_apt() {
  if ! [ -x "$(command -v docker)" ]; then
    echo "Installing Docker using Package Manager..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    sudo apt-get update && sudo apt-get install -y docker-ce && sudo usermod -aG docker $CURRENT_USER
  else
    echo "Docker is already installed"
  fi
}

function install_docker() {
  echo "Installing Docker..."
  if is_mint; then
    install_docker_using_snap
  else
    if is_ubuntu_19_10; then
      install_docker_using_snap
    else
      install_docker_using_apt
    fi
  fi
}

function install_docker_compose() {
  if ! [ -x "$(command -v docker-compose)" ]; then
    DOCKER_COMPOSE_VERSION="1.25.0"
    echo "Installing Docker-Compose $DOCKER_COMPOSE_VERSION..."
    sudo curl -L https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose
  else
    echo "Docker-Compose is already installed"
  fi
}

function install_python3() {
  echo "Installing Python 3.7..."
  sudo apt-get install -y virtualenv \
  python3.7 \
  python3.7-dev \
  python3.7-venv \
  python3.7-dbg \
  python3-pip \
  python3-virtualenv \
  python3-setuptools \
  python3-wheel && \
  python3.7 -m pip install -U pip setuptools wheel --user && \
  python3.7 -m pip install -U "pylint<2.0.0" --user
}

function install_idea() {
  echo "Installing Idea..."
  sudo snap install intellij-idea-community --classic
}

function install_android_studio() {
  echo "Installing Android Studio..."
  sudo snap install android-studio --classic
}

function install_golang() {
  if ! [ -x "$(command -v go)" ]; then
    echo "Installing Golang..."
    sudo apt-get install golang-go go-dep -y && \
    mkdir -p ${HOME}/golang/src && \
    echo 'export GOPATH=${HOME}/golang' >> ${HOME}/.profile
  else
    echo "GoLang is already installed"
  fi
}

function install_google_java_format() {
  GOOGLE_JAVA_FORMAT_VERSION=1.7
  mkdir -p ${HOME}/bin
  if [ ! -f "${HOME}/bin/google-java-format.jar" ]; then
    echo "Installing Google Java Formatter $GOOGLE_JAVA_FORMAT_VERSION..."
    wget https://github.com/google/google-java-format/releases/download/google-java-format-${GOOGLE_JAVA_FORMAT_VERSION}/google-java-format-${GOOGLE_JAVA_FORMAT_VERSION}-all-deps.jar && \
      mv google-java-format-${GOOGLE_JAVA_FORMAT_VERSION}-all-deps.jar ${HOME}/bin/google-java-format.jar
  else
    echo "Google Java Formatter is already installed"      
  fi
  ALIAS=$(cat ~/.bashrc | grep 'alias google-format=')
  if [ -z "${ALIAS}" ]; then
    echo 'function googleFormat() {
if [ "$#" -eq 1 ]; then
  FILTER=$1
else
  FILTER=*.java
fi
  find . -type f -name ${FILTER} -exec java -jar ${HOME}/bin/google-java-format.jar --replace {} \;
}
alias google-format=googleFormat' >> ~/.bashrc
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
        wget -O eclipse-jee.tar.gz 'https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/2019-12/R/eclipse-jee-2019-12-R-linux-gtk-x86_64.tar.gz&r=1'
      fi

      if [ -d "${TARGET_DIRECTORY}/eclipse" ]; then
        echo "Eclipse was already installed"
      else
        echo "Extracting Eclipse Java EE ..."
        tar -xvzf ${TARGET_DIRECTORY}/eclipse-jee.tar.gz && \
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

function install_antlr() {
  ANTLR_VERSION=4.7.2
  mkdir -p ${HOME}/bin
  if [ ! -f "${HOME}/bin/antlr.jar" ]; then
    echo "Installing Antlr $ANTLR_VERSION..."  
    wget https://www.antlr.org/download/antlr-${ANTLR_VERSION}-complete.jar && \
        mv antlr-${ANTLR_VERSION}-complete.jar ${HOME}/bin/antlr.jar
  else
    echo "Antlr is already installed"
  fi
  ALIAS=$(cat ~/.bashrc | grep 'alias antlr=')
  if [ -z "${ALIAS}" ]; then
    echo 'function runAntlr() {
LANGUAGE=Java
if [ "$#" -eq 1 ]; then
  FILTER=$1
elif [ "$#" -eq 2 ]; then
  FILTER=$1
  LANGUAGE=$2
else
  FILTER=*.g4
fi
find . -type f -name ${FILTER} -exec java -jar ${HOME}/bin/antlr.jar -Dlanguage=${LANGUAGE} {} \;
if [ "${LANGUAGE}" == "Java" ]; then
  javac -cp ${HOME}/bin/antlr.jar *.java
fi
}
alias antlr=runAntlr
alias grun="java -cp .:${HOME}/bin/antlr.jar org.antlr.v4.gui.TestRig"' >> ~/.bashrc
  fi
}

function install_snapd() {
  if is_mint; then
    echo "Installing Snap..."
    sudo apt-get install -y snapd
  fi
}

function install_tweak_tool() {
  if is_ubuntu; then
    echo "Installing Gnome Tweak Tool..."
    sudo apt-get install -y gnome-tweak-tool
  fi
}

function install_code() {
  echo "Installing Code..."
  sudo snap install code --classic
}

function install_meson() {
  echo "Installing Meson..."
  sudo apt-get install -y ninja-build meson
}

function install_dart() {
  if ! [ -x "$(command -v dart)" ]; then
    echo "Installing dart..."
    sudo sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
    sudo sh -c 'wget -qO- https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
    sudo apt-get update
    sudo apt-get install -y dart && \
      sudo ln -sf /usr/lib/dart/bin/dart2js /usr/local/bin/dart2js && \
      sudo ln -sf /usr/lib/dart/bin/dart2native /usr/local/bin/dart2native && \
      sudo ln -sf /usr/lib/dart/bin/pub /usr/local/bin/pub
  else
    echo "Dart is already installed"
  fi
}

function install_brave_browser() {
  if ! [ -x "$(command -v dart)" ]; then
    echo "Installing brave-browser..."
    curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
    echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install -y brave-browser
  else
    echo "Brave is already installed"
  fi
}

function install_kubectl() {
  if ! [ -x "$(command -v kubectl)" ]; then
    curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && chmod u+x ./kubectl && sudo mv ./kubectl /usr/local/bin/kubectl
  else
    echo "Kubectl is already installed"
  fi
}

function install_virtualbox() {
  if ! [ -x "$(command -v virtualbox)" ]; then
    VIRTUALBOX_VERSION=6.1.2
    VIRTUALBOX_RELEASE_NUMBER=135662
    curl -Lo virtualbox "https://download.virtualbox.org/virtualbox/${VIRTUALBOX_VERSION}/VirtualBox-${VIRTUALBOX_VERSION}-${VIRTUALBOX_RELEASE_NUMBER}-Linux_amd64.run" && chmod u+x virtualbox
    sudo ./virtualbox && rm virtualbox
  else
    echo "Virtualbox is already installed"
  fi
}

function install_minikube() {
  if ! [ -x "$(command -v minikube)" ]; then
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod u+x minikube
    sudo mkdir -p /usr/local/bin/
    sudo install minikube /usr/local/bin/
    rm minikube
  else
    echo "Minikube is already installed"
  fi
}

function install_gimp() {
  if ! [ -x "$(command -v gimp)" ]; then
    sudo apt-get install gimp -y
  else
    echo "Gimp is already installed"
  fi
}

function install_dropbox() {
  if ! [ -x "$(command -v dropbox)" ]; then
    RELEASE_DATE="2019.02.14"
    sudo apt-get install libpango1.0-0 python3-gpg -y
    wget -O dropbox.deb "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_${RELEASE_DATE}_amd64.deb" && \
        sudo dpkg -i ./dropbox.deb && \
        rm ./dropbox.deb
  else
    echo "Dropbox is already installed"
  fi
}

function install_adapta() {
  PPA_NAME=tista/adapta
  cat /etc/apt/sources.list /etc/apt/sources.list.d/* | grep ${PPA_NAME} | grep -v '^#' > /dev/null
  if [ $? -eq 1 ]; then
    sudo apt-add-repository "ppa:${PPA_NAME}" -y && sudo apt-get update
  else
    echo "ppa:${PPA_NAME} is already added"
  fi
  sudo apt-get install adapta-gtk-theme -y
}

function install_papericon() {
  PPA_NAME=snwh/ppa
  cat /etc/apt/sources.list /etc/apt/sources.list.d/* | grep ${PPA_NAME} | grep -v '^#' > /dev/null
  if [ $? -eq 1 ]; then
    sudo apt-add-repository "ppa:${PPA_NAME}" -y && sudo apt-get update
  else
    echo "ppa:${PPA_NAME} is already added"
  fi
  sudo apt-get install paper-icon-theme -y
}

function install_chrome() {
  if ! [ -x "$(command -v google-chrome)" ]; then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
      sudo dpkg -i google-chrome-stable_current_amd64.deb && \
      rm google-chrome-stable_current_amd64.deb
  else
    echo "Google Chrome is already installed"
  fi
}

function install_vlc() {
  if ! [ -x "$(command -v vlc)" ]; then
    sudo apt-get install vlc -y
  else
    echo "VLC is already installed"
  fi
}

# Main

function main() {
  echo "Checking operating system..."
  if ! is_valid_os; then
    echo "Invalid operating system. This script is valid for: "
    echo "- Ubuntu 18.04"
    echo "- Ubuntu 19.04"
    echo "- Ubuntu 19.10"
    echo "- Linux Mint 19"
    echo "- Linux Mint 19.1"
    echo "- Linux Mint 19.2"
    echo "- Linux Mint 19.3"
    echo "Sorry"
    exit 1
  fi

  [ -z "$INSTALL_LIBRARIES" ] && INSTALL_LIBRARIES="y"
  [ -z "$INSTALL_SNAPD" ] && INSTALL_SNAPD="y"
  [ -z "$INSTALL_GNOME_TWEAK_TOOL" ] && INSTALL_GNOME_TWEAK_TOOL="y"
  [ -z "$INSTALL_GIT" ] && INSTALL_GIT="y"
  [ -z "$INSTALL_MELD" ] && INSTALL_MELD="y"
  [ -z "$INSTALL_VIM" ] && INSTALL_VIM="y"
  [ -z "$INSTALL_TERMINATOR" ] && INSTALL_TERMINATOR="y"
  [ -z "$INSTALL_SDKMAN" ] && INSTALL_SDKMAN="y"
  [ -z "$INSTALL_JAVA" ] && INSTALL_JAVA="y"
  [ -z "$INSTALL_MAVEN" ] && INSTALL_MAVEN="y"
  [ -z "$INSTALL_NVM" ] && INSTALL_NVM="y"
  [ -z "$INSTALL_NPM" ] && INSTALL_NPM="y"
  [ -z "$INSTALL_DOCKER" ] && INSTALL_DOCKER="y"
  [ -z "$INSTALL_MESON" ] && INSTALL_MESON="y"
  [ -z "$CONFIGURE_ALIASES" ] && CONFIGURE_ALIASES="y"
  [ -z "$INSTALL_CODE" ] && INSTALL_CODE="y"
  [ -z "$INSTALL_ECLIPSE" ] && INSTALL_ECLIPSE="y"
  [ -z "$INSTALL_BRAVE" ] && INSTALL_BRAVE="y"

  [ -z "$INSTALL_GCC8" ] && INSTALL_GCC8="n"
  [ -z "$INSTALL_PYTHON3" ] && INSTALL_PYTHON3="n"
  [ -z "$INSTALL_SPRING" ] && INSTALL_SPRING="n"
  [ -z "$INSTALL_IDEA" ] && INSTALL_IDEA="n"
  [ -z "$INSTALL_ANDROID_STUDIO" ] && INSTALL_ANDROID_STUDIO="n"
  [ -z "$INSTALL_GRADLE" ] && INSTALL_GRADLE="n"
  [ -z "$INSTALL_KOTLIN" ] && INSTALL_KOTLIN="n"
  [ -z "$INSTALL_VISUALVM" ] && INSTALL_VISUALVM="n"
  [ -z "$INSTALL_GOOGLE_JAVA_FORMAT" ] && INSTALL_GOOGLE_JAVA_FORMAT="n"
  [ -z "$INSTALL_ANTLR" ] && INSTALL_ANTLR="n"
  [ -z "$INSTALL_LEININGEN" ] && INSTALL_LEININGEN="n"
  [ -z "$INSTALL_GOLANG" ] && INSTALL_GOLANG="n"
  [ -z "$INSTALL_DART" ] && INSTALL_DART="n"

  [ -z "$INSTALL_KUBECTL" ] && INSTALL_KUBECTL="n"
  [ -z "$INSTALL_VIRTUALBOX" ] && INSTALL_VIRTUALBOX="n"
  [ -z "$INSTALL_MINIKUBE" ] && INSTALL_MINIKUBE="n"
  [ -z "$INSTALL_GIMP" ] && INSTALL_GIMP="n"
  [ -z "$INSTALL_DROPBOX" ] && INSTALL_DROPBOX="n"
  [ -z "$INSTALL_ADAPTA" ] && INSTALL_ADAPTA="n"
  [ -z "$INSTALL_PAPERICON" ] && INSTALL_PAPERICON="n"
  [ -z "$INSTALL_CHROME" ] && INSTALL_CHROME="n"
  [ -z "$INSTALL_VLC" ] && INSTALL_VLC="n"

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

  [ $INSTALL_LIBRARIES == "y" ] && install_libraries
  [ $INSTALL_GNOME_TWEAK_TOOL == "y" ] && install_tweak_tool

  [ $INSTALL_GIT == "y" ] && install_git
  [ $INSTALL_MELD == "y" ] && install_meld
  [ $INSTALL_VIM == "y" ] && install_vim
  [ $INSTALL_TERMINATOR == "y" ] && install_terminator
  [ $INSTALL_MESON == "y" ] && install_meson

  [ $INSTALL_GCC8 == "y" ] && install_gcc8
  [ $INSTALL_PYTHON3 == "y" ] && install_python3

  [ $INSTALL_NVM == "y" ] && install_nvm
  [ $INSTALL_NPM == "y" ] && install_npm

  [ $INSTALL_SDKMAN == "y" ] && install_sdkman
  [ $INSTALL_JAVA == "y" ] && install_java13
  [ $INSTALL_MAVEN == "y" ] && install_maven3
  [ $INSTALL_SPRING == "y" ] && install_spring
  [ $INSTALL_GRADLE == "y" ] && install_gradle
  [ $INSTALL_KOTLIN == "y" ] && install_kotlin
  [ $INSTALL_VISUALVM == "y" ] && install_visualvm
  [ $INSTALL_LEININGEN == "y" ] && install_leiningen

  [ $INSTALL_GOLANG == "y" ] && install_golang
  [ $INSTALL_DART == "y" ] && install_dart

  [ $INSTALL_CODE == "y" ] && install_code
  [ $INSTALL_ECLIPSE == "y" ] && install_eclipse

  [ $INSTALL_GOOGLE_JAVA_FORMAT == "y" ] && install_google_java_format
  [ $INSTALL_ANTLR == "y" ] && install_antlr

  [ $CONFIGURE_ALIASES == "y" ] && configure_aliases

  [ $INSTALL_BRAVE == "y" ] && install_brave_browser

  [ $INSTALL_SNAPD == "y" ] && install_snapd
  [ $INSTALL_IDEA == "y" ] && install_idea
  [ $INSTALL_ANDROID_STUDIO == "y" ] && install_android_studio
  [ $INSTALL_CODE == "y" ] && install_code
  [ $INSTALL_DOCKER == "y" ] && install_docker && install_docker_compose

  [ $INSTALL_KUBECTL == "y" ] && install_kubectl
  [ $INSTALL_VIRTUALBOX == "y" ] && install_virtualbox
  [ $INSTALL_MINIKUBE == "y" ] && install_minikube
  [ $INSTALL_GIMP == "y" ] && install_gimp
  [ $INSTALL_DROPBOX == "y" ] && install_dropbox
  [ $INSTALL_ADAPTA == "y" ] && install_adapta
  [ $INSTALL_PAPERICON == "y" ] && install_papericon
  [ $INSTALL_CHROME == "y" ] && install_chrome
  [ $INSTALL_VLC == "y" ] && install_vlc

  echo "Installation was finished. Reboot your system and happy coding...!!!"
}

main
