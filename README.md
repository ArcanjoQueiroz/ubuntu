## Ubuntu Installation Script

[![Build Status](https://travis-ci.org/ArcanjoQueiroz/ubuntu.svg?branch=master)](https://travis-ci.org/ArcanjoQueiroz/ubuntu)

This project is a shell script to install utilities, programming languages and binaries in Debian/Ubuntu-based operating systems in one command!!!

### Installing

The following example shows how to use the installation script:

```sh
curl -s 'https://raw.githubusercontent.com/ArcanjoQueiroz/ubuntu/master/install.sh' | bash
```

or

```sh
wget --no-cache 'https://raw.githubusercontent.com/ArcanjoQueiroz/ubuntu/master/install.sh' && chmod u+x install.sh && ./install.sh
```

or even:

```sh
INSTALL_GCC8="y" \
INSTALL_PYTHON3="y" \
INSTALL_SPRING="y" \
INSTALL_IDEA="y" \
INSTALL_ANDROID_STUDIO="y" \
INSTALL_GRADLE="y" \
INSTALL_KOTLIN="y" \
INSTALL_VISUALVM="y" \
INSTALL_GOOGLE_JAVA_FORMAT="y" \
INSTALL_ANTLR="y" \
INSTALL_LEININGEN="y" \
INSTALL_GOLANG="y" \
INSTALL_DART="y" && curl -s 'https://raw.githubusercontent.com/ArcanjoQueiroz/ubuntu/master/install.sh' | bash
```

### What does install.sh install?

This script installs the following tools/programs by default:

* Snap
* Terminator
* Git
* Meld
* Docker CE
* Docker-Compose 1.25.0
* Java 13.0.1
* Maven 3.6.3
* Node.js v13.5.0
* Eclipse Java EE
* Code
* Vim
* Meson

And by environment variables:

* Golang
* Dart
* Python 3.7
* GCC 8
* Spring Boot CLI 2.2.2.RELEASE
* Kotlin 1.3.61
* Gradle 5.6.1
* Leiningen 2.9.0
* Visualvm 1.4.4
* Google Java Formatter 1.7
* Antlr 4.7.2
* IntelliJ IDEA Community Edition
* Android Studio

### Compatibility

This script is compatible with:

* Ubuntu 18.04
* Ubuntu 19.04
* Ubuntu 19.10
* Linux Mint 19
* Linux Mint 19.1
* Linux Mint 19.2
* Linux Mint 19.3

### Licensing

[Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0.html)

### So...

Happy coding!!!!
