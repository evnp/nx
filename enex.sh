#!/usr/bin/env bash

# enex 0.0.1

function enex() {
  local cmd="$1"
  shift
  if [[ "$( npm --h | awk '/access, adduser/,/whoami/' )" == *"${cmd}"* ]]; then
    npm "${cmd}" -- "$@"
  else
    npm run "${cmd}" -- "$@"
  fi
}

# ~ default command alias ~
#   n : enex  (eg. n install : npm install, n build : npm run build, etc.)
# ~ to disable ~
#   ENEX_COMMAND=0 source "$HOME/enex/enex"

if [[ "${ENEX_COMMAND}" != "0" ]]; then
  if [[ -n "${ENEX_VERBOSE}" ]]; then
    echo "alias ${ENEX_COMMAND:-n}=\"enex\""
  fi
  # shellcheck disable=SC2139
  alias "${ENEX_COMMAND:-n}"="enex"
fi

# ~ default sub-command aliases ~
#   ni : npm install   nu : npm uninstall   ns : npm start
#   nt : npm test      nb : npm run build   nf : npm run format
# ~ to disable ~
#   ENEX_ALIASES=0 source "$HOME/enex/enex"

if [[ "${ENEX_ALIASES}" != "0" ]]; then
  for word in $( tr -cs '[:alnum:]._-' ' ' <<< "${ENEX_ALIASES:-install,uninstall,start,test,build,format}" ); do
    if [[ "${ENEX_COMMAND}" == "0" ]]; then
      if [[ -n "${ENEX_VERBOSE}" ]]; then
        echo "alias ${ENEX_COMMAND:-enex}${word:0:1}=\"enex ${word}\""
      fi
      # shellcheck disable=SC2139
      alias "${ENEX_COMMAND:-enex}${word:0:1}"="enex ${word}"
    else
      if [[ -n "${ENEX_VERBOSE}" ]]; then
        echo "alias ${ENEX_COMMAND:-n}${word:0:1}=\"enex ${word}\""
      fi
      # shellcheck disable=SC2139
      alias "${ENEX_COMMAND:-n}${word:0:1}"="enex ${word}"
    fi
  done
fi
