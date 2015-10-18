FROM php:5.6-apache

# Fix Permission problem workaroud
# http://chapeau.freevariable.com/2014/08/docker-uid.html
RUN ["useradd", "-u", "1000", "-m", "-s", "/bin/bash", "dockerdev"]
RUN chown -R 1000:50 $(cat /etc/passwd | grep dockerdev | cut -f6 -d:)

# Install Tools
RUN apt-get update -qy && \
    apt-get install -y \
    vim \
    telnet \
    netcat \
    git-core \
    zip \
    mysql-client \
    zsh \
    && apt-get purge -y --auto-remove

# Add utility scripts
COPY bin/entrypoint.sh /bin/entrypoint.sh
COPY conf/zshrc /home/dockerdev/.zshrc

RUN chmod +x /bin/entrypoint.sh

WORKDIR /home/dockerdev

CMD ["/bin/entrypoint.sh"]
