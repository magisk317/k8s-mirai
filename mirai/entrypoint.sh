#!/bin/sh

if [ -d /mirai-configurations/..data ]; then
    cp -r /mirai-configurations/..data/* ./
fi

/bin/sh mcl

