#!/bin/bash

function install_google_java_format() {
    mkdir -p ${HOME}/bin && \
        wget https://github.com/google/google-java-format/releases/download/google-java-format-1.7/google-java-format-1.7-all-deps.jar && \
        mv google-java-format-1.7-all-deps.jar ${HOME}/bin/google-java-format.jar
    ALIAS=$(cat ~/.bashrc | grep 'alias google-format=')
    if [ -z "${ALIAS}" ]; then
        echo '
function googleFormat() {
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

install_google_java_format
