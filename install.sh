#!/bin/bash

function preparing_installation() {
    echo "Preparing installation..."

    if [ -z "$USER" ]; then
        CURRENT_USER=$(id -un)
    else   
        CURRENT_USER="$USER"
    fi 
    export CURRENT_USER
    echo "Current user $CURRENT_USER"

    if ! [ -x "$(command -v sudo)" ]; then
        apt-get update && apt-get install sudo
    else 
        echo "Updating definitions..."
        sudo apt-get update
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
                            zip
}

function install_utilities() {
    echo "Installing Utilities..."
    sudo apt-get install -y curl \
                            xclip \
                            wget \
                            htop \
                            terminator \
                            vim \
                            snapd
}

function install_git() {
    if ! [ -x "$(command -v git)" ]; then
        echo "Installing Git and Meld..."
        sudo apt-get install -y git meld
    else
        echo "Git is already installed"
    fi
}

function configure_aliases() {
    echo "Configuring Aliases..."
    echo "alias docker-stop='docker stop $(docker ps -a -q)'
alias docker-remove=docker rm -f $(docker ps -a -q) && docker rmi -f $(docker images -q) && docker volume rm $(docker volume ls -f \"dangling=true\")'
alias pbcopy=\"xclip -selection clipboard\"
alias pbpaste=\"xclip -selection clipboard -o\"" > ~/.bash_aliases
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
package.lock
" > ~/.gitignore && \
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

function install_skdman() {
    echo "Installing SDKMan..."
    curl -s "https://get.sdkman.io" | bash && source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk install java 9.0.7-zulu
    sdk install maven 3.6.0
    sdk install gradle 4.10.2
    sdk install kotlin 1.2.70
    sdk install springboot
}

function install_nvm() {
    if ! [ -x "$(command -v nvm)" ]; then
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
        echo "Installing node through nvm"
        nvm install node
    else
        echo "Node is already installed"
    fi
}

function install_docker() {
    if ! [ -x "$(command -v docker)" ]; then
        echo "Installing Docker..."
        curl -fsSL "https://download.docker.com/linux/ubuntu/gpg" | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
        sudo apt-get update && sudo apt-get install -y docker-ce && sudo usermod -aG docker $CURRENT_USER
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
    sudo apt-get install -y python3.7 \
                            python3.7-dev \
                            python3.7-venv \
                            python3.7-dbg \
                            python3-pip \
                            python3-virtualenv \
                            python3-setuptools && \
    python3.7 -m pip install -U pip setuptools wheel --user && \
	python3.7 -m pip install -U "pylint<2.0.0" --user
}

function main() {
    echo "Starting installation..."
    preparing_installation && \
              install_libraries && \
              install_utilities && \
              install_git && \
              install_skdman && \
              install_nvm && \
              install_python3 && \
              install_docker && \
              install_docker_compose &&
              configure_git && \
              configure_aliases
    echo "Installation was finished. Happy coding...!!!"
}

main
