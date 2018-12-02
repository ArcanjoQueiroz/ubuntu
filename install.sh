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
    sudo apt-get install -y xclip \
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
alias pbpaste="xclip -selection clipboard -o"' > ~/.bash_aliases
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

function install_sdkman() {
    if ! [ -x "$SDKMAN_DIR" ]; then
        echo "Installing SDKMan..."
        curl -s "https://get.sdkman.io" | bash && source "$HOME/.sdkman/bin/sdkman-init.sh"
    else
        echo "SKDMan is already installed"
        [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
    fi
    sdk install java 9.0.7-zulu
    sdk install maven 3.6.0
    sdk install gradle 4.10.2
    sdk install kotlin 1.2.70
    sdk install springboot 2.1.0.RELEASE
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

"Define spaces size according to the file type
autocmd FileType html,css,ruby,javascript setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType java,python,bash,sh setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType make setlocal noexpandtab
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

"Automatically removing all trailing whitespace
autocmd FileType ruby,javascript,java,python,bash,sh autocmd BufWritePre * %s/\s\+$//e' > ~/.vimrc
}

function install_docker() {
    if ! [ -x "$(command -v docker)" ]; then
        echo "Installing Docker..."
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
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

function install_idea() {
    echo "Installing Idea..."
    sudo snap install intellij-idea-community --classic
}

function install_android_studio() {
    echo "Installing Android Studio..."
    sudo snap install android-studio --classic
}

function install_vim_gtk() {
    echo "Installing Vim GTK..."
    sudo apt-get install vim-gtk
}

function main() {
    echo "Starting installation..."

    if [ -z "$INCLUDE_INSTALLATION" ]; then
        INCLUDE_INSTALLATION="y"
    fi

    if [ -z "$INCLUDE_CONFIGURATION" ]; then
        INCLUDE_CONFIGURATION="y"
    fi

    if [ -z "$INCLUDE_IDE" ]; then
        INCLUDE_IDE="n"
    fi

    preparing_installation

    [ $INCLUDE_INSTALLATION == "y" ] && \
        install_libraries && \
        install_utilities && \
        install_git && \
        install_sdkman && \
        install_nvm && \
        install_python3 && \
        install_docker && \
        install_docker_compose

    [ $INCLUDE_CONFIGURATION == "y" ] && \
        configure_git && \
        configure_aliases && \
        configure_vim

    [ $INCLUDE_IDE == "y" ] && \
        install_idea && \
        install_android_studio && \
        install_vim_gtk

    echo "Installation was finished. Happy coding...!!!"
}

main
