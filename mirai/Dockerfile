FROM maven:3.8.8-eclipse-temurin-21-alpine AS base
WORKDIR /mirai
COPY /*.json /mirai/
COPY /mcl* /mirai/
COPY /entrypoint.sh /mirai/

# install basic dependeicies
WORKDIR /mirai
RUN . ./mcl -z

# install plugin dependencies

FROM base AS plugin
COPY /plugins /mirai/
RUN . ./mcl -z
RUN echo "stop" | /bin/bash ./mcl

FROM plugin AS run
WORKDIR /mirai
ENTRYPOINT [ "/bin/sh", "entrypoint.sh" ]
