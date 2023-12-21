FROM maven:3.8.8-eclipse-temurin-21-alpine AS base
WORKDIR /mirai
COPY /plugins /mirai/
COPY /*.json /mirai/
COPY /mcl* /mirai/
COPY /entrypoint.sh /mirai/

# install dependeicies
WORKDIR /mirai/app
RUN [ "/bin/sh", "./mcl", "-z" ]


FROM base AS run
WORKDIR /mirai
RUN [ "/bin/sh", "entrypoint.sh" ]
