FROM catthehacker/ubuntu:act-latest
LABEL maintainer="Pat Brisbin <pbrisbin@gmail.com>"
ENV DEBIAN_FRONTEND=noninteractive

# jo
RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    jo && \
  rm -rf /var/lib/apt/lists/*

# GH
RUN \
  cd /tmp && \
  curl -L -sSf https://github.com/cli/cli/releases/download/v2.53.0/gh_2.53.0_linux_amd64.tar.gz | tar xzvf - && \
  cp -v gh_*/bin/gh /usr/local/bin && \
  rm -r gh_*

# Support scripts
COPY bin /usr/local/bin/
