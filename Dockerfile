FROM rethinkdb:latest
MAINTAINER Christophe Burki, christophe@burkionline.net

# Install system requirements
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip

# Install python rethinkdb
RUN pip3 install rethinkdb

# Copy setup scripts
COPY scripts/start.sh /opt/start.sh
COPY scripts/setupauth.py /opt/setupauth.py
RUN chmod 755 /opt/start.sh

VOLUME ["/data"]
WORKDIR /data

EXPOSE 28015 29015 8080

ENTRYPOINT ["/opt/start.sh"]
CMD ["--bind", "all"]
