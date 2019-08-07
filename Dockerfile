FROM mcr.microsoft.com/dotnet/core/sdk:2.2.401

# reviewing this choice
ENV SONAR_SCANNER_MSBUILD_VERSION 4.6.2.2108

ENV DOCKER_VERSION 5:19.03.1~3-0~debian-stretch
ENV CONTAINERD_VERSION 1.2.6-3

# Install Java 8
RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y openjdk-8-jre

# Install docker binaries
RUN apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && apt-key fingerprint 0EBFCD88 \
    && add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/debian \
        $(lsb_release -cs) \
        stable" \
    && apt-get update \
    && apt-get install -y docker-ce=$DOCKER_VERSION docker-ce-cli=${DOCKER_VERSION} containerd.io=${CONTAINERD_VERSION}

# install nodejs
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash - && apt-get install -y nodejs autoconf libtool nasm

# Install Sonar Scanner
RUN apt-get install -y unzip \
    && wget https://github.com/SonarSource/sonar-scanner-msbuild/releases/download/$SONAR_SCANNER_MSBUILD_VERSION/sonar-scanner-msbuild-$SONAR_SCANNER_MSBUILD_VERSION-netcoreapp2.0.zip \
    && unzip sonar-scanner-msbuild-$SONAR_SCANNER_MSBUILD_VERSION-netcoreapp2.0.zip -d /sonar-scanner \
    && rm sonar-scanner-msbuild-$SONAR_SCANNER_MSBUILD_VERSION-netcoreapp2.0.zip \
    && chmod +x -R /sonar-scanner

# Cleanup
RUN apt-get -q autoremove \
    && apt-get -q clean -y \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*.bin
