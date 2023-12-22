FROM maven:3.8.8-eclipse-temurin-21-alpine AS base
# basic files and install basic dependeicies
WORKDIR /mirai
COPY /*.json /mirai/
COPY /mcl* /mirai/
WORKDIR /mirai
RUN /bin/bash ./mcl -z > /dev/null

# install plugin dependencies
FROM base AS plugin
COPY /plugins /mirai/plugins
RUN . ./mcl -z > /dev/null
RUN echo "stop" | /bin/bash ./mcl -k > /dev/null

FROM base AS run
# copy libraries for plugins
COPY --from=plugin /mirai/plugins /mirai/plugins
COPY --from=plugin /mirai/plugin-libraries /mirai/plugin-libraries
COPY --from=plugin /mirai/plugin-shared-libraries /mirai/plugin-shared-libraries
COPY --from=plugin /mirai/libs /mirai/libs

# entrypoint
COPY /entrypoint.sh /mirai/

WORKDIR /mirai
ENTRYPOINT [ "/bin/sh", "entrypoint.sh" ]
