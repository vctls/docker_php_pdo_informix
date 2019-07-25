# Docker PHP, Apache and PDO_Informix
Inspired by https://github.com/joanrivera/docker-informixpdo

Base configuration files to generate a Docker container with PHP, Apache and PDO_Informix support. 

This is a proof of concept on how to compile and install PDO_Informix with the IBM Informix SDK.

It provides a very crude web API to which you can send SQL queries and retrieve the results in JSON format.

⚠ **WARNING: Queries are executed literally. This provides no security whatsoever.**

### Setup

You can either pull the image from the [Docker hub](https://cloud.docker.com/repository/docker/vctls/php_apache_pdo_informix) or build it yourself as follows.

1. Clone the project.

1. CSDK and the PDO souce code are versioned through Git LFS, but if for some reason you need to donwload them manually, backup links are below. Put both into the `informix` directory:
    * The Informix Client SDK, from the IBM website (as of 2019-01-15):  
    Tested with version 4.10.FC9DE.LINUX for x86-64 architecture.  
      https://www-01.ibm.com/marketing/iwm/iwm/web/pickUrxNew.do?source=ifxdl  
      (requires login. See below.)
    * The PDO sources from `pecl.php.net`:  
    Tested with version 1.3.3.  
      https://pecl.php.net/package/PDO_INFORMIX

2. (Optional) In the `informix/slqhosts` file, change the string `demo_server` to match your Informix server name.

3. (Optional) Review the files in the `scripts` directory and edit according to your needs. Be sure to check the file names if you're not using the ones provided.

4. Copy `/src/cfg/env.php.dist` into `/src/cfg/env.php` and set your connection settings in that file.

>Since the IBM site is a real PITA, has changed multiple times, requires an account, and we have no guarantee that these files won't disappear overnight, here's a direct link to a working version:  
https://mega.nz/#!RZ4SEa5I!TUxX4ZP75g3jqyX0vlCVIjD_L_W7Kj3tpilpKn4tcMc  
And here's a link to the PDO_informix source, just in case:  
https://mega.nz/#!ZQ5DGYjA!J7ppK75hFd9PxsJ5Fsoc8n9s3IDRvhKxKzGQ-z8ZmA8

### Build...

4. Build the image:  
`docker build -t ifxpdo .`

5. When containers are to be created, note that you must set the Infomix server IP:  
`docker run -d -p 80:80 -v /var/www/html:/var/www/html --add-host ifxserver:192.168.0.2  ifxpdo`.

### Or,
Run the project with docker-compose:\
`docker-compose up`

Open `localhost` in your browser to see if it's working.

You should see something like this:  
```json
[{"":"2019-07-12 14:28:29.160","0":"2019-07-12 14:28:29.160"}]
```

Declare the `informix.local` domain for clarity.

You can pass URL encoded SQL queries as get parameter like this:
```
http://informix.local/?query=SELECT%20*%20FROM%20systables%20WHERE%20tabid=1;
```

You can also pass the PDO fetch style through the **fetch_style** parameter.  
Default is 2 (`FETCH_ASSOC`).
```
http://informix.local/?query=SELECT%20*%20FROM%20systables%20WHERE%20tabid=1&fetch_style=3;
```