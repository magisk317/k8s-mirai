FROM maven:3.8.8-eclipse-temurin-21-alpine AS base
WORKDIR /mirai
COPY /*.json /mirai/
COPY /mcl* /mirai/
COPY /entrypoint.sh /mirai/

# install dependeicies
WORKDIR /mirai
RUN . ./mcl -z
RUN echo "stop" | /bin/bash ./mcl

FROM base AS run
WORKDIR /mirai
ENTRYPOINT [ "/bin/sh", "entrypoint.sh" ]
