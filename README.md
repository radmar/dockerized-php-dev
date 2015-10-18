Dockerized - PHP Base development stack
===

This module is intended to use as a skeleton starting point and is based on the ideas of
[andreaskoch/dockerized-magento](https://github.com/andreaskoch/dockerized-magento)


Requirements
---
You need
* `docker`
* `docker-compose`
* `composer`

Create the Skeleton
---

* `composer.phar create-project -s dev stefanorg/dockerized-php-dev my-project`

Editing the docker env config file
---

- Copy `docker-compose.local.yml.dist` to `docker-compose.local.yml`
- Edit:
  - `docker-compose.local.yml` with your host specific directories
  - `docker-compose.yml` with your app specific settings

Script
---

A utility script is provided, run `./container.sh` to see the options
