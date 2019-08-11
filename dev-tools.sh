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

function install_antlr() {
    mkdir -p ${HOME}/bin && \
        wget https://www.antlr.org/download/antlr-4.7.2-complete.jar && \
        mv antlr-4.7.2-complete.jar ${HOME}/bin/antlr.jar
    ALIAS=$(cat ~/.bashrc | grep 'alias antlr=')
    if [ -z "${ALIAS}" ]; then
        echo '
function runAntlr() {
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
alias antlr=runAntlr' >> ~/.bashrc
    fi
}

install_google_java_format
install_antlr
