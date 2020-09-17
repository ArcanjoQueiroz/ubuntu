FROM ubuntu:19.10

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Sao_Paulo

WORKDIR /root

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    echo keyboard-configuration keyboard-configuration/layout select 'English (US)' | debconf-set-selections && \
    echo keyboard-configuration keyboard-configuration/layoutcode select 'us' | debconf-set-selections && \
    echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections


COPY install.sh /root/install.sh
RUN chmod u+x /root/install.sh

ENV INSTALL_LIBRARIES=y
ENV INSTALL_SNAPD=y
ENV INSTALL_GNOME_TWEAK_TOOL=y
ENV INSTALL_GIT=y
ENV INSTALL_MELD=n
ENV INSTALL_VIM=n
ENV INSTALL_TERMINATOR=n
ENV INSTALL_DOCKER=y
ENV INSTALL_MESON=y
ENV INSTALL_GCC8=y
ENV INSTALL_PYTHON3=y
ENV INSTALL_SDKMAN=y
ENV INSTALL_JAVA=n
ENV INSTALL_MAVEN=n
ENV INSTALL_SPRING=n
ENV INSTALL_NVM=y
ENV INSTALL_NPM=y
ENV INSTALL_GRADLE=n
ENV INSTALL_KOTLIN=n
ENV INSTALL_GOLANG=y
ENV INSTALL_IDEA=n
ENV INSTALL_ANDROID_STUDIO=n
ENV INSTALL_CODE=n
ENV INSTALL_ECLIPSE=y
ENV INSTALL_VISUALVM=n
ENV INSTALL_GOOGLE_JAVA_FORMAT=y
ENV INSTALL_ANTLR=y

RUN ./install.sh

CMD ["/bin/bash"]
