#!/usr/bin/env sh
# requires openssl to be installed
# requires certificate.conf file
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout server.key -out server.crt -config certificate.conf
