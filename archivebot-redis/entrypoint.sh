#!/bin/sh

USERMAP_ORIG_UID=$(id -u ${ARCHIVEBOT_USER})
USERMAP_ORIG_GID=$(id -g ${ARCHIVEBOT_USER})

USERMAP_GID=${USERMAP_GID:-${USERMAP_UID:-$USERMAP_ORIG_GID}}
USERMAP_UID=${USERMAP_UID:-$USERMAP_ORIG_UID}

if [[ ${USERMAP_UID} != ${USERMAP_ORIG_UID} ]] || [[ ${USERMAP_GID} != ${USERMAP_ORIG_GID} ]]; then
  groupmod -g ${USERMAP_GID} ${ARCHIVEBOT_USER}
  usermod -u ${USERMAP_UID} ${ARCHIVEBOT_USER}
  chown -h ${ARCHIVEBOT_USER}:${ARCHIVEBOT_USER} /home/${ARCHIVEBOT_USER}
fi


appStart () {
  su -c "ssh -C -L *:16379:127.0.0.1:10022 -p ${SSH_PORT} ${SSH_USER}@${SSH_HOST} -N" ${ARCHIVEBOT_USER}
}

appHelp () {
  echo "Available options:"
  echo " app:start          - Starts the uploader (default)"
  echo " app:help           - Displays the help"
  echo " [command]          - Execute the specified linux command eg. sh."
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