#!/bin/bash
cp ../install.sh .
docker build -t ubuntu-script:1.0.1-ubuntu-19.04 .
rm install.sh
