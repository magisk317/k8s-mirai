#!/bin/sh

if [ -d "config"]; then
    echo Mirai misconfiguration, check your configuration and mount it to /mirai/config
    exit 1
fi


