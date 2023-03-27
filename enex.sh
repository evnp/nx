#!/usr/bin/env bash
# :: enex 0.0.7 ::
# shellcheck disable=SC2139 # shellcheck.net/wiki/SC2139 # allow parameter expansion within alias strings #
function enex() (
  local pkg=""
  local run=""
  [[ "$1" =~ ^(t(est)?|s(tart)?|h(elp)?)$ || "$( npm -h | awk '/access, adduser/,/whoami/' )," != *" $1,"* ]] && run=" run"
  # :: find closest package.json (file path containing fewest "/" characters) :: export ENEX_FIND=0; source "$HOME/enex/enex.sh" (to disable) ::
  while [[ ! "${ENEX_FIND}" =~ ^(0|false|FALSE)$ && ! -f "./package.json" ]] ; do
    [[ "$( pwd )" == "$HOME" ]] && echo "No package.json found." && exit 1
    pkg="$( find . -name package.json -maxdepth 3 | grep -v node_modules | awk -F/ '{print NF,$0}' | sort -n | cut -d' ' -f2- | head -1 )"
    cd "$( [[ -n "${pkg}" ]] && dirname "${pkg}" || echo '..' )" || exit 1
  done
  # :: call "nvm use" automatically before running commands :: export ENEX_NVM=1; source "$HOME/enex/enex.sh" (to enable) ::
  [[ "${ENEX_NVM}" =~ ^(1|true|TRUE)$ ]] && nvm use &>/dev/null
  # :: await confirmation of current node+npm versions before executing command :: export ENEX_CONFIRM=1; source "$HOME/enex/enex.sh" (to enable) ::
  if [[ "${ENEX_CONFIRM}" =~ ^(1|true|TRUE)$ ]]; then
    echo -e npm"${run}" "$1" "${2:+--}" "${@:2}" "\nPress ENTER to run · CTRL+C to cancel · node $( node -v ) · npm $( npm -v )"
    head -n 1 >/dev/null  # wait for ENTER keypress, or exit on CTRL+C
  fi
  npm"${run}" "$1" "${2:+--}" "${@:2}" # :: execute constructed npm command ::
)
# :: default command alias :: n -> enex :: eg. n install -> npm install, n build -> npm run build, etc.
# :: export ENEX_COMMAND=0; source "$HOME/enex/enex.sh" (to disable) ::
if ! [[ "${ENEX_COMMAND}" =~ ^(0|false|FALSE)$ ]]; then
  [[ -n "${ENEX_VERBOSE}" ]] && echo "alias ${ENEX_COMMAND:-n}=\"enex\""
  alias "${ENEX_COMMAND:-n}"="enex"
fi
# :: default sub-command aliases ::
#    nb -> npm run build  nt -> npm test        nf -> npm run format  nl -> npm link
#    ni -> npm install    nu -> npm uninstall   ns -> npm start       nh -> npm run help
#    nis, nid, nus, nud -> npm [un]install --save[-dev]               ntw -> npm run test -- --watch
# :: export ENEX_ALIASES=0; source "$HOME/enex/enex.sh" (to disable) ::
if ! [[ "${ENEX_ALIASES}" =~ ^(0|false|FALSE)$ ]]; then
  for word in $( tr -cs '[:alnum:]._-' ' ' <<< "${ENEX_ALIASES:-install,uninstall,start,test,build,format,link,help}" ); do
    [[ "${ENEX_COMMAND}" =~ ^(0|false|FALSE)$ ]] && ENEX_COMMAND='enex'
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
