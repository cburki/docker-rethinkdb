Summary
-------

RethinkDB server image. It extend the official [rethinkdb](https://hub.docker.com/_/rethinkdb/) 
image in the way that it allow to join a cluster when running the image. This
image also secure the driver port by using the authentication system. For
persistent storage, you could use the cburki/volume-data container to store
the database data.

The web interface is not secured. Anybody could access the web interface if
the port 8080 is exposed on a non protected network. The web interface could
be protected by a reverse proxy which enforce an authentication before allowing
an access to the web interface. The following two images could be used.an

    - [cburki/nginx-rproxy-auth](https://hub.docker.com/r/cburki/nginx-rproxy-auth/)
    - [cburki/haproxy-confd](https://hub.docker.com/r/cburki/haproxy-confd/)

The first one only support HTTP protocol so it can only be used for proxying
the HTP web interface. The second one support TCP and HTTP and it can therefore
be used for proxying all the ports.

You should not export the rethinkdb ports when you chose to proxy them.


Build the image
---------------

To create this image, execute the following command in the docker-rethinkdb
folder.

    docker build -t cburki/rethinkdb .


Configure the image
-------------------

You can secure the driver port by giving a password. This will set an
authentication key which is then required to connect to the cluster. Note that
this will not secure the web interface.

    - RETHINKDB_AUTH_KEY : The driver authentication key. Authentication is not enabled if none is given.


Run the image
-------------

When you run the imnage, you will bind the ports 8080, 28015 and 29015. By
default, RethinkDB will bind to all interfaces and it will not join any
cluster.

    docker run \
        --name rethinkdb \
        --volumes-from rethink-data \
        -d \
        -e RETHINKDB_AUTH_KEY=my_secret_key \
        -p 8080:8080 \
        -p 28015:28015 \
        -p 29015:29015 \
        cburki/rethinkdb:latest

Start the container using the following command when you want to join an
existing cluster. You need to known the *node_ip_address* of the master
node.

    docker run \
        --name rethinkdb \
        --volumes-from rethink-data \
        -d \
        -e RETHINKDB_AUTH_KEY=my_secret_key \
        -p 8080:8080 \
        -p 28015:28015 \
        -p 29015:29015 \
        cburki/rethinkdb:latest \
        --bind all \
        --join <node_ip_address>:29015

The volume data container could be started using the following command.

    docker run \
        --name rethinkdb-data \
        -d \
        cburki/volume-data:latest
