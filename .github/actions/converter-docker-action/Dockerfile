# Container image that runs your code
FROM ubuntu:20.04
MAINTAINER warting
RUN apt update && apt upgrade -y && apt install -y fontforge make ttfautohint eot-utils

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh
COPY all2all.pe /all2all.pe
COPY samplefonts /samplefonts
COPY public /public

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
