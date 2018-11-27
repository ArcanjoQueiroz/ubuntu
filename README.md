## Ubuntu Installation Script

This project is a shell script to install utilities, programming languages and binaries in Ubuntu **18.04.1 LTS** in one command!!!

### Installing

The following example shows how to use the installation script:

```sh
curl -s 'https://raw.githubusercontent.com/ArcanjoQueiroz/ubuntu/master/install.sh' | bash
```

If you want to install Intellij IDEA Community Editon and Android Studio, set the INCLUDE_IDE variable in your command:

```sh
curl -s 'https://raw.githubusercontent.com/ArcanjoQueiroz/ubuntu/master/install.sh' | INCLUDE_IDE=y bash
```

### What does install.sh install?

This script installs the following:

* Snap
* Terminator
* Vim
* Git
* Meld
* Java 9.0.7-zulu
* Maven 3.6.0
* Kotlin 1.2.70
* Gradle 4.10.2
* Spring Boot CLI 2.1.0.RELEASE
* Node.js v11.2.0
* Docker CE
* Docker-Compose 1.23.1
* Python 3.7
* GCC 7

And the IDEs:

* IntelliJ IDEA Community Edition
* Android Studio

### License

Apache 2


### So...

Happy coding!!!!
