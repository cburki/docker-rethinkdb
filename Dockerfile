FROM rethinkdb:latest
MAINTAINER Christophe Burki, christophe@burkionline.net

# Install system requirements
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    wget

# Install python rethinkdb
RUN pip3 install rethinkdb

# Install dumb-init
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.0.0/dumb-init_1.0.0_amd64
RUN chmod 755 /usr/local/bin/dumb-init

# Copy setup scripts
COPY scripts/run.sh /opt/run.sh
COPY scripts/setupauth.py /opt/setupauth.py
RUN chmod 755 /opt/run.sh

VOLUME ["/data"]
WORKDIR /data

EXPOSE 28015 29015 8080

ENTRYPOINT ["/opt/run.sh"]
CMD ["--bind", "all"]
