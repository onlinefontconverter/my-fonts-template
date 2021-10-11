# Container image that runs your code
FROM ubuntu:20.04
LABEL maintainer="Stefan Wärting stefan@warting.se"
RUN apt update && \
    apt install -y fontforge make ttfautohint eot-utils && \
    apt install -y --no-install-recommends software-properties-common gnupg && \
    add-apt-repository ppa:git-core/ppa && \
        apt update && \
        apt install -y --no-install-recommends \
        git \
        wget \
        ssh \
        vim && \
        apt autoclean && \
        apt clean && \
        apt autoremove -y && \
        rm -rf /var/lib/apt/lists/*

RUN git --version && \
    git config --global init.defaultBranch main && \
    git config --global init.defaultBranch \

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh
COPY all2all.pe /all2all.pe
COPY samplefonts /samplefonts
COPY public /public

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
