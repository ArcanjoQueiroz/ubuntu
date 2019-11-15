#!/bin/bash

function preparing_installation() {
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

  if is_mint; then
    install_snapd
  fi

  if is_ubuntu; then
    install_tweak_tool
  fi
}

function install_libraries() {
    echo "Installing Libraries..."
        sudo apt-get install -y build-essential \
        checkinstall \
        gcc-7 \
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
        wget
}

function install_utilities() {
  echo "Installing Utilities..."
  sudo apt-get install -y xclip xsel htop terminator
  sudo apt-get install -y vim && configure_vim
}

function install_git() {
  if ! [ -x "$(command -v git)" ]; then
    echo "Installing Git and Meld..."
    sudo apt-get install -y git meld && configure_git
  else
    echo "Git is already installed"
  fi
}

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

function install_sdkman() {
  if ! [ -x "$SDKMAN_DIR" ]; then
    echo "Installing SDKMan..."
    curl -s "https://get.sdkman.io" | bash && source "$HOME/.sdkman/bin/sdkman-init.sh"
  else
    echo "SKDMan is already installed"
    [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
  fi
  sdk update && \
    sdk install java 13.0.1-zulu && \
    sdk install maven 3.6.0 && \
    sdk install springboot 2.1.7.RELEASE
}

function install_visualvm() {
  echo "Installing visualvm ..."
  sdk install visualvm 1.4.3
}

function install_kotlin() {
  echo "Installing Kotlin ..."
  sdk install gradle 5.6.1
  sdk install kotlin 1.3.50
}

function install_nvm() {
  if ! [ -x "$NVM_DIR" ]; then
    NVM_VERSION="v0.33.11"
    echo "Installing NVM $NVM_VERSION"
    curl -o- "https://raw.githubusercontent.com/creationix/nvm/$NVM_VERSION/install.sh" | bash && source ~/.bashrc
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  else
    echo "NVM is already installed"
  fi

  if ! [ -x "$(command -v node)" ]; then
    NODE_VERSION="v11.2.0"
    echo "Installing node $NODE_VERSION through nvm"
    nvm install node $NODE_VERSION
  else
    echo "Node is already installed"
  fi
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

autocmd FileType html,css,ruby,javascript,java setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType python,bash,sh setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType make setlocal noexpandtab
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

autocmd FileType ruby,javascript,java,python,bash,sh,html,css,yaml,make autocmd BufWritePre * %s/\s\+$//e' > ~/.vimrc
}

function install_docker() {
  if ! [ -x "$(command -v docker)" ]; then
    echo "Installing Docker..."
    if ! is_ubuntu_19_10; then
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
      sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
      sudo apt-get update && sudo apt-get install -y docker-ce && sudo usermod -aG docker $CURRENT_USER
    else
      sudo snap install docker --classic
    fi
  else
    echo "Docker is already installed"
  fi
}

function install_docker_compose() {
  if ! [ -x "$(command -v docker-compose)" ]; then
    DOCKER_COMPOSE_VERSION="1.23.1"
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
  python3-setuptools && \
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


function install_google_java_format() {
  echo "Installing Google Java Formatter..."
  GOOGLE_JAVA_FORMAT_VERSION=1.7
  mkdir -p ${HOME}/bin
  if [ ! -f "${HOME}/bin/google-java-format.jar" ]; then
    wget https://github.com/google/google-java-format/releases/download/google-java-format-${GOOGLE_JAVA_FORMAT_VERSION}/google-java-format-${GOOGLE_JAVA_FORMAT_VERSION}-all-deps.jar && \
      mv google-java-format-${GOOGLE_JAVA_FORMAT_VERSION}-all-deps.jar ${HOME}/bin/google-java-format.jar
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
    mkdir -p ${TARGET_DIRECTORY} && cd ${TARGET_DIRECTORY}
    if [ -e "${TARGET_DIRECTORY}/eclipse-jee.tar.gz" ]; then
      echo "Eclipse File already downloaded";
    else
      echo "Downloading Eclipse Java EE ...";
      wget -O eclipse-jee.tar.gz 'https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/2019-06/R/eclipse-jee-2019-06-R-linux-gtk-x86_64.tar.gz&r=1'
    fi

    if [ -d "${TARGET_DIRECTORY}/eclipse" ]; then
      echo "Eclipse was already installed"
    else
      echo "Extracting Eclipse Java EE ..."
      tar -xvzf ${TARGET_DIRECTORY}/eclipse-jee.tar.gz && \
        rm ${TARGET_DIRECTORY}/eclipse-jee.tar.gz

      echo "Configuring eclipse.ini..."
      ECLIPSE_HOME=${TARGET_DIRECTORY}/eclipse

      ECLIPSE_INI=${ECLIPSE_HOME}/eclipse.ini
      sed 's/-Xms.*/-Xms1024m/g' -i ${ECLIPSE_INI}
      sed 's/-Xmx.*/-Xmx4096m/g' -i ${ECLIPSE_INI}

      JAVA_BIN_PATH=${HOME}/.sdkman/candidates/java/current/bin
      echo "Configuring Eclipse VM ..."
      sed "s#-vmargs#-vm\n${JAVA_BIN_PATH}\n-vmargs#" -i ${ECLIPSE_INI}

      echo "[Desktop Entry]
Name=Eclipse
Type=Application
Exec=${ECLIPSE_HOME}/eclipse
Terminal=false
Icon=${ECLIPSE_HOME}/icon.xpm
Comment=Integrated Development Environment
NoDisplay=false
Categories=Development;IDE;
Name[en]=Eclipse" > ${HOME}/.local/share/applications/eclipse.desktop

    fi
}

function install_antlr() {
  echo "Installing Antlr..."
  ANTLR_VERSION=4.7.2
  mkdir -p ${HOME}/bin
  if [ ! -f "${HOME}/bin/antlr.jar" ]; then
    wget https://www.antlr.org/download/antlr-${ANTLR_VERSION}-complete.jar && \
        mv antlr-${ANTLR_VERSION}-complete.jar ${HOME}/bin/antlr.jar
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

function is_valid_os() {
  export DISTRIB_ID=$(cat /etc/os-release | grep "^ID=" | cut -d '=' -f 2)
  export VERSION_ID=$(cat /etc/os-release | grep "^VERSION_ID=" | cut -d '=' -f 2)

  echo "Target Distribution: $DISTRIB_ID"
  echo "Target Version: $VERSION_ID"

  MINT="n"; UBUNTU="n"
  [ $DISTRIB_ID == "linuxmint" ] && [ $VERSION_ID == \""19\"" ] && MINT="y"
  [ $DISTRIB_ID == "ubuntu" ] && \
      ( [ $VERSION_ID == \""18.04\"" ] || \
        [ $VERSION_ID == \""19.04\"" ] || \
        [ $VERSION_ID == \""19.10\"" ] ) && UBUNTU="y"
          [ $UBUNTU == "y" ] || [ $MINT == "y" ]
  return $?
}

function is_mint() {
  [ $DISTRIB_ID == "linuxmint" ] && [ $VERSION_ID == \""19\"" ]
  return $?
}

function install_snapd() {
  echo "Installing Snap"
  sudo apt-get install -y snapd
}

function install_tweak_tool() {
  echo "Installing Gnome Tweak Tool..."
  sudo apt-get install -y gnome-tweak-tool
}

function install_code() {
  echo "Installing Code..."
  sudo snap install code --classic
}

function is_ubuntu_19_10() {
  [ $DISTRIB_ID == "ubuntu" ] && [ $VERSION_ID == \""19.10\"" ]
  return $?
}

function is_ubuntu() {
  [ $DISTRIB_ID == "ubuntu" ]
  return $?
}

function main() {
  echo "Checking operating system..."
  if ! is_valid_os; then
    echo "Invalid operating system. This script is valid only for Ubuntu 18.04 and Linux Mint 19. Sorry"
    exit 1
  fi

  echo "Starting installation..."

  [ -z "$INCLUDE_INSTALLATION" ] && INCLUDE_INSTALLATION="y"
  [ -z "$INCLUDE_CONFIGURATION" ] && INCLUDE_CONFIGURATION="y"
  [ -z "$INCLUDE_IDE" ] && INCLUDE_IDE="n"
  [ -z "$ADVANCED_TOOLS" ] && ADVANCED_TOOLS="n"

  preparing_installation

  [ $INCLUDE_INSTALLATION == "y" ] && \
    install_libraries && \
    install_utilities && \
    install_git && \
    install_sdkman && \
    install_nvm && \
    install_docker && \
    install_docker_compose && \
    install_eclipse && \
    install_code

    [ $INCLUDE_CONFIGURATION == "y" ] && configure_aliases

    [ $INCLUDE_IDE == "y" ] && install_idea && install_android_studio

    [ $ADVANCED_TOOLS == "y" ] && \
      install_kotlin && \
      install_visualvm && \
      install_python3 && \
      install_google_java_format && \
      install_antlr

  echo "Installation was finished. Happy coding...!!!"
}

main
