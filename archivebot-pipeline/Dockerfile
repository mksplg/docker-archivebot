FROM ubuntu:14.04
MAINTAINER mksplg@gmail.com

ENV ARCHIVEBOT_USER="archivebot" \
    RSYNC_URL="rsync://fos.textfiles.com/archivebot/" \
    REDIS_URL="redis://redis:16379/0" \
    FINISHED_WARCS_DIR="/home/archivebot/warcs4fos" \
    NO_SCREEN=1 \
    NO_SEGFAULT_340=1

RUN echo 'Acquire::HTTP::Proxy "http://172.17.42.1:3142";' >> /etc/apt/apt.conf.d/01proxy && \
    echo 'Acquire::HTTPS::Proxy "false";' >> /etc/apt/apt.conf.d/01proxy

COPY setup.sh .
RUN bash ./setup.sh

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

VOLUME [/home/archivebot/warcs4fos]

ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["app:start"]