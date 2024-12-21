# 420cry-dev-server
This repository can be used to set up and maintain a complete 420Cry Cloud development environment. It provides
simple CLI commands for installing and managing all repositories.

## Prerequisites
1. SSH access to the GitHub repositories has been set up.
2. You have a Linux or Unix like operating system like Ubuntu or macOS.
3. You got Docker running.
   - You can easily test this by running this command:`docker run hello-world`. If you don't get any output, Docker is
     not yet installed.
4. This development server will need some ports to be available. So please stop all services running on these ports.
   To see which application uses a port please check the paragraph [How can I see which application uses a port?](#how-can-i-see-which-application-uses-a-port) below.
      - 80 (HTTP)
      - 443 (HTTPS)
      - 3306 (MySQL / MariaDB)

## Installation
You have to run all commands
 - In your Linux / macOS terminal
 - As your regular user, using root is not advised

Just follow these easy steps to set up the development environment.
1. `git clone https://github.com/HTLM420/420cry-dev-server.git ~/projects/420/420cry-dev-server`
   1. You may wish to change the destination location to your own needs.
2. `cd ~/projects/420/420cry-dev-server`
3. Copy configuration file and adjust it to your own likings.  
   1. `cp config.ini.example config.ini`
   2. `vim config.ini`
4. Install the `420cry` script to make it available globally. This can be done by using the command below or by hand if 
   you want to. Please note that this is only tested using Bash.
   1. `./bin/420cry install:script`
6. Re-open your terminal to make the `420cry` alias active.
7. Clone repositories
   1. `420cry install:clone`
      - This can take a while!
8. Build Docker images
   1. `420cry install:docker`
      - Coffee time!
9. Bring the development environment up 
   1. `420cry up`
10. Install the development root certificate to access the application without certificate errors.
    1. Add the `certs/420Cloud_DevelopmentRootCA.crt` to your certificate trust store.

## Frequently asked questions
### How can I see which application uses a port?
You can easily check this with the command below.
```shell
sudo netstat -tulpn | grep -E "(80|443|3306)"
```

This is very useful if you get an error like
```
ERROR: for dev-server_mysql_1  Cannot start service mysql: Ports are not available: listen tcp 0.0.0.0:3306: bind: address already in use
```
or
```
WARNING: Host is already in use by another container
ERROR: for dev-server_proxy_1  Cannot start service proxy: driver failed program
```