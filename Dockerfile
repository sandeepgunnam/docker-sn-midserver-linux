FROM ubuntu:16.04

LABEL maintainer="ezra walgraf"

# To get rid of error messages like "debconf: unable to initialize frontend: Dialog":
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

ADD asset/* /opt/

RUN apt-get -q update && apt-get install -qy unzip \
    supervisor \
    xmlstarlet \
    vim \
    wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN wget --no-check-certificate \
      https://install.service-now.com/glide/distribution/builds/package/mid/2019/09/05/mid.newyork-06-26-2019__patch1-hotfix1-09-04-2019_09-05-2019_1536.linux.x86-64.zip \
      -O /tmp/mid.zip && \
    unzip -d /opt /tmp/mid.zip && \
    mv /opt/agent/config.xml /opt/ && \
    chmod 755 /opt/init && \
    chmod 755 /opt/fill-config-parameter && \
    rm -rf /tmp/*

EXPOSE 80 443

ENTRYPOINT ["/opt/init"]

CMD ["mid:start"]
