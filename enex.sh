#!/usr/bin/env bash

# :: enex 0.0.4 ::

# shellcheck disable=SC2139

function enex() {
  if [[ "$1" =~ ^(t(est)?|s(tart)?)$ || "$( npm --h | awk '/access, adduser/,/whoami/' )," != *" $1,"* ]]; then
    npm run "$1" -- "${@:2}"
  else
    npm "$@"
  fi
}

# :: default command alias ::
#    n -> enex
#    eg. n install -> npm install, n build -> npm run build, etc.
# :: to disable ::
#    ENEX_COMMAND=0 source "$HOME/enex/enex"
if [[ "${ENEX_COMMAND}" != "0" ]]; then
  [[ -n "${ENEX_VERBOSE}" ]] && echo "alias ${ENEX_COMMAND:-n}=\"enex\""
  # shellcheck disable=SC2139
  alias "${ENEX_COMMAND:-n}"="enex"
fi

# :: default sub-command aliases ::
#    nb -> npm run build  nt -> npm test        nf -> npm run format
#    ni -> npm install    nu -> npm uninstall   ns -> npm start
#    nis, nid, nus, nud -> npm [un]install --save[-dev]
#    ntw -> npm run test -- --watch
# :: to disable ::
#    ENEX_ALIASES=0 source "$HOME/enex/enex"
if [[ "${ENEX_ALIASES}" != '0' ]]; then
  for word in $( tr -cs '[:alnum:]._-' ' ' <<< "${ENEX_ALIASES:-install,uninstall,start,test,build,format}" ); do
    if [[ "${ENEX_COMMAND}" == '0' ]]; then
      ENEX_COMMAND='enex'
    fi
    [[ -n "${ENEX_VERBOSE}" ]] && echo "alias ${ENEX_COMMAND:-n}${word:0:1}=\"enex ${word}\""
    alias "${ENEX_COMMAND:-n}${word:0:1}"="enex ${word}"
    if [[ "${word}" =~ ^(un)?install$ ]]; then
      [[ -n "${ENEX_VERBOSE}" ]] && echo "alias ${ENEX_COMMAND:-n}${word:0:1}s=\"enex ${word} --save\""
      [[ -n "${ENEX_VERBOSE}" ]] && echo "alias ${ENEX_COMMAND:-n}${word:0:1}d=\"enex ${word} --save-dev\""
      alias "${ENEX_COMMAND:-n}${word:0:1}s"="enex ${word} --save"
      alias "${ENEX_COMMAND:-n}${word:0:1}d"="enex ${word} --save-dev"
    elif [[ "${word}" == 'test' ]]; then
      [[ -n "${ENEX_VERBOSE}" ]] && echo "alias ${ENEX_COMMAND:-n}${word:0:1}w=\"enex ${word} --watch\""
      alias "${ENEX_COMMAND:-n}${word:0:1}w"="enex ${word} --watch"
    fi
  done
fi
