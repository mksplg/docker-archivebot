FROM alpine:3.1
MAINTAINER mksplg@gmail.com

ENV ARCHIVEBOT_USER="archivebot" \
    SSH_HOST="archivebot.at.ninjawedding.org" \
    SSH_USER="archivebot" \
    SSH_PORT="22"

RUN echo http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
    apk add --update openssh-client shadow && rm -rf /var/cache/apk/*

RUN adduser -D ${ARCHIVEBOT_USER} && \
    passwd -d ${ARCHIVEBOT_USER}

RUN mkdir /home/archivebot/.ssh/
COPY known_hosts /home/archivebot/.ssh/
RUN chmod 644 /home/archivebot/.ssh/known_hosts
COPY ssh_config /home/archivebot/.ssh/config

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 16379

ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["app:start"]