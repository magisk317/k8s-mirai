#!/bin/sh

if [-f /mirai-configurations/..data]; then
    cp -r /mirai-configurations/..data/* ./
fi

/bin/sh mcl --boot-only

