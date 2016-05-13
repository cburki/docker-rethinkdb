import os
import rethinkdb as r

def main() :

    password = os.environ['RETHINKDB_ADMIN_PASSWORD']
    print("Setting up rethinkdb admin with password : {}".format(password))

    conn = r.connect('localhost', 28015)
    r.db('rethinkdb').table('users').get('admin').update({'password' : password}).run(conn)
    conn.close()


if __name__ == "__main__" :
    main()
