#!/bin/bash

USERMAP_ORIG_UID=$(id -u ${ARCHIVEBOT_USER})
USERMAP_ORIG_GID=$(id -g ${ARCHIVEBOT_USER})

USERMAP_GID=${USERMAP_GID:-${USERMAP_UID:-$USERMAP_ORIG_GID}}
USERMAP_UID=${USERMAP_UID:-$USERMAP_ORIG_UID}

if [[ ${USERMAP_UID} != ${USERMAP_ORIG_UID} ]] || [[ ${USERMAP_GID} != ${USERMAP_ORIG_GID} ]]; then
  groupmod -g ${USERMAP_GID} ${ARCHIVEBOT_USER}
  usermod -u ${USERMAP_UID} ${ARCHIVEBOT_USER}
  chown -h ${ARCHIVEBOT_USER}:${ARCHIVEBOT_USER} /home/${ARCHIVEBOT_USER}
fi

cd /home/archivebot/


appStart () {
  sudo -HEu ${ARCHIVEBOT_USER} /home/archivebot/.local/bin/run-pipeline3 ArchiveBot/pipeline/pipeline.py --disable-web-server \
                               --concurrent 2 NAME 2>&1 | \
                               tee "/home/archivebot/logs/pipeline-$(date -u +"%Y-%m-%dT%H_%M_%SZ").log"
}

appHelp () {
  echo "Available options:"
  echo " app:start          - Starts the uploader (default)"
  echo " app:help           - Displays the help"
  echo " [command]          - Execute the specified linux command eg. bash."
}

case ${1} in
  app:start)
    appStart
    ;;
  app:help)
    appHelp
    ;;
  *)
    if [[ -x $1 ]]; then
      $1
    else
      prog=$(which $1)
      if [[ -n ${prog} ]] ; then
        shift 1
        $prog $@
      else
        appHelp
      fi
    fi
    ;;
esac