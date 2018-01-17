#!/bin/bash
# Setup nginx, dnsmasq, and a resolver file to serve up the
# ~/code directory with nginx, and each subdirectory at their own
# .test domain
# NOTE: This script needs to be run with sudo

echo -e "\n\nInstalling nginx"
echo "=============================="

######################################################
# nginx setup
######################################################

DOTFILES=~/code/dotfiles

# first, make sure apache is off
launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist

# run nginx when osx starts
cp /usr/local/opt/nginx/homebrew.mxcl.nginx.plist /Library/LaunchDaemons
launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist

mkdir -p /usr/local/etc/nginx/sites-enabled
cp -R nginx/sites-available /usr/local/etc/nginx/sites-available
mv /usr/local/etc/nginx/nginx.conf /usr/local/etc/nginx/nginx.conf.orig
ln -s $DOTFILES/nginx/nginx.conf /usr/local/etc/nginx/nginx.conf

sites=$( ls -1 -d $DOTFILES/nginx/sites-available)
for site in $sites ; do
    echo "linking $site"
    ln -s $DOTFILES/nginx/sites-available/$site /usr/local/etc/nginx/sites-enabled/$site
done


######################################################
# dnsmasq setup
######################################################

echo "installing dnsmasq"

# move dnsmasq config into place
ln -s $DOTFILES/nginx/dnsmasq.conf /usr/local/etc/

# setup dnsmasq
cp -fv /usr/local/opt/dnsmasq/homebrew.mxcl.dnsmasq.plist /Library/LaunchDaemons
launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq

######################################################
# resolver setup
######################################################

mkdir -p /etc/resolver
echo "nameserver 127.0.0.1" > /etc/reoslver/test
