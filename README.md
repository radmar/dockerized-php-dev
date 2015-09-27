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

Editing the application
---
Once created the project modify the `docker-compose.yml` file as you like and then run
*  `./application.sh start`
