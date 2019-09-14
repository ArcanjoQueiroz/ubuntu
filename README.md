## Ubuntu Installation Script

This project is a shell script to install utilities, programming languages and binaries in Debian/Ubuntu-based operating systems in one command!!!

### Installing

The following example shows how to use the installation script:

```sh
curl -s 'https://raw.githubusercontent.com/ArcanjoQueiroz/ubuntu/master/install.sh' | bash
```

If you want to install Intellij IDEA Community Editon and Android Studio, set the INCLUDE_IDE = 'y' in your command:

```sh
curl -s 'https://raw.githubusercontent.com/ArcanjoQueiroz/ubuntu/master/install.sh' | INCLUDE_IDE=y bash
```

In order to install the advanced tools, include ADVANCED_TOOLS environment variable as in the following example:


```sh
curl -s 'https://raw.githubusercontent.com/ArcanjoQueiroz/ubuntu/master/install.sh' | ADVANCED_TOOLS=y bash
```

### What does install.sh install?

This script installs the following tools/programs:

* Snap
* Terminator
* Vim
* Git
* Meld
* Java 11.0.2-zulufx
* Maven 3.6.0
* Spring Boot CLI 2.1.7.RELEASE
* Node.js v11.2.0
* Docker CE
* Docker-Compose 1.23.1
* GCC 8
* Eclipse Java EE

The advanced tools:

* Kotlin 1.3.50
* Gradle 5.6.1
* Visualvm 1.4.3
* Python 3.7
* Google Java Formatter
* Antlr

And the IDEs:

* IntelliJ IDEA Community Edition
* Android Studio

### Compatibility

This script is compatible with **Ubuntu 18.04**, **Ubuntu 19.04** and **Linux Mint 19**.

### Licensing

[Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0.html)

### So...

Happy coding!!!!
