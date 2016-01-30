import os
import rethinkdb as r

def main() :

    auth_key = os.environ['RETHINKDB_AUTH_KEY']
    print("Setting up rethinkdb authentication with key : {}".format(auth_key))

    conn = r.connect('localhost', 28015)
    r.db('rethinkdb').table('cluster_config').get('auth').update({'auth_key' : auth_key}).run(conn)
    conn.close()


if __name__ == "__main__" :
    main()
