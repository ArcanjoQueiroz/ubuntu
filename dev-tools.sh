#!/bin/bash

function install_google_java_format() {
    GOOGLE_JAVA_FORMAT_VERSION=1.7
    mkdir -p ${HOME}/bin
    if [ ! -f "${HOME}/bin/google-java-format.jar" ]; then
        wget https://github.com/google/google-java-format/releases/download/google-java-format-${GOOGLE_JAVA_FORMAT_VERSION}/google-java-format-${GOOGLE_JAVA_FORMAT_VERSION}-all-deps.jar && \
        mv google-java-format-${GOOGLE_JAVA_FORMAT_VERSION}-all-deps.jar ${HOME}/bin/google-java-format.jar
    fi
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
    ANTLR_VERSION=4.7.2
    mkdir -p ${HOME}/bin
    if [ ! -f "${HOME}/bin/antlr.jar" ]; then
        wget https://www.antlr.org/download/antlr-${ANTLR_VERSION}-complete.jar && \
        mv antlr-${ANTLR_VERSION}-complete.jar ${HOME}/bin/antlr.jar
    fi
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
alias antlr=runAntlr
alias grun="java -cp ${HOME}/bin/antlr.jar org.antlr.v4.gui.TestRig"' >> ~/.bashrc
    fi
}

install_google_java_format
install_antlr
