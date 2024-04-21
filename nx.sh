#!/usr/bin/env bash
# :: nx 1.0.6 ::
# shellcheck disable=SC2139 # shellcheck.net/wiki/SC2139 # allow parameter expansion within alias strings #
function nx() ( local pkg="" cmd="" npmcmds="" nodev="" npmv=""
  npmcmds="run|$( npm -h | awk '/access/,/whoami/' | sed -E 's/ (help|start|test),//g' | xargs | sed 's/, /|/g' )" || true
  # :: print current aliases and exit when "n" is run with no arguments ::
  [[ -z "$1" ]] && nodev="$( node -v | tr -d 'v' )" && npmv="$( npm -v )" && echo "node ${nodev} · npm ${npmv}"$'\n'"˙˙˙˙ ${nodev//?/˙}   ˙˙˙ ${npmv//?/˙}" \
    && alias | grep "='nx " | sed -E -e 's/^alias //' -e 's/=/ · /' -e 's/nx /npm run /' -e "s/run (${npmcmds})/\1/" | tr -d "'" && exit 0
  [[ "|${npmcmds}|" == *"|$1|"* ]] && cmd=('npm' "$1") || cmd=('npm' 'run' "$1")
  [[ "$2" == 'w' ]] && set -- "$1" '--' '--watch' "${@:3}" # :: rewrite 'w' to '--' '--watch' if provided as second arg ""
  shift # :: done with command arg, following args are all arguments to command ::
  # :: find closest package.json (file path containing fewest "/" characters) :: to disable auto-find behavior, export NX_FIND=0; source "$HOME/nx/nx.sh" ::
  while [[ ! "${NX_FIND}" =~ ^(0|false|FALSE)$ && ! -f './package.json' ]] && [[ "$1" != '--global' ]]; do
    [[ -f './frontend/package.json' ]] && cd './frontend' && break # :: look for ./frontend/package.json first ::
    [[ "$( pwd )" == "$HOME" ]] && echo 'No package.json found.' && exit 1
    pkg="$( find . -name package.json -maxdepth 3 | grep -v node_modules | awk -F/ '{print NF,$0}' | sort -n | cut -d' ' -f2- | head -1 )"
    cd "$( [[ -n "${pkg}" ]] && dirname "${pkg}" || echo '..' )" || exit 1
  done
  # :: call "nvm use" automatically before running commands :: to enable auto-nvm behavior, export NX_NVM=1; source "$HOME/nx/nx.sh" ::
  [[ "${NX_NVM}" =~ ^(1|true|TRUE)$ ]] && nvm use &>/dev/null
  # :: await confirmation of current node+npm versions before executing command :: to enable await-confirm behavior, export NX_CONFIRM=1 source "$HOME/nx/nx.sh" ::
  if [[ "${NX_CONFIRM}" =~ ^(1|true|TRUE)$ ]]; then
    read -rsn1 -p "${cmd[*]} ${*}"$'\n'"${cmd[*]//?/˙} ${*//?/˙}"$'\n'"Press any key to run · CTRL+C to cancel · node $( node -v | tr -d 'v' ) · npm $( npm -v )"$'\n\n'
  elif ! [[ "${NX_QUIET}" =~ ^(1|true|TRUE)$ ]]; then
    echo "${cmd[*]} ${*}"$'\n'"${cmd[*]//?/˙} ${*//?/˙}"$'\n'"node $( node -v | tr -d 'v' ) · npm $( npm -v )"$'\n\n'
  fi
  if (( $# )); then "${cmd[@]}" "${@}"; else "${cmd[@]}"; fi # :: execute npm command (only pass extra arguments if there _are_ extra arguments)
)
# :: default command alias :: n -> nx :: eg. n install -> npm install, n build -> npm run build, etc. :: to change name, export NX_COMMAND="name"; source "$HOME/nx/nx.sh" ::
# :: default sub-command aliases :: to disable all aliases, export NX_ALIASES=0; source "$HOME/nx/nx.sh" ::
#    ni -> npm install     nis, nus -> npm [un]install --save       ns -> npm start     nt -> npm test   nf -> npm run format   nl -> npm run lint   nd -> npm run dev
#    nu -> npm uninstall   nid, nud -> npm [un]install --save-dev   np -> npm publish   nk -> npm link   nb -> npm run build    nh -> npm run help   nr X -> npm run X
if ! [[ "${NX_ALIASES}" =~ ^(0|false|FALSE)$ ]]; then
  alias "${NX_COMMAND:-n}"='nx'
  for word in $( tr -cs '[:alnum:]._-/' ' ' <<< "${NX_ALIASES:-run,install,uninstall,start,test,dev,build,format,lint,k/link,publish,help},${NX_EXTEND_ALIASES:-}" ); do
    [[ "${NX_COMMAND}" =~ ^(0|false|FALSE)$ ]] && NX_COMMAND='nx'
    alias "${NX_COMMAND:-n}${word:0:1}"="nx ${word#[a-z]/}"; [[ -n "${NX_VERBOSE}" ]] && alias "${NX_COMMAND:-n}${word:0:1}"
    if [[ "${word}" =~ ^(un)?install$ ]]; then
      alias "${NX_COMMAND:-n}${word:0:1}s"="nx ${word#[a-z]/} --save"; [[ -n "${NX_VERBOSE}" ]] && alias "${NX_COMMAND:-n}${word:0:1}s"
      alias "${NX_COMMAND:-n}${word:0:1}d"="nx ${word#[a-z]/} --save-dev"; [[ -n "${NX_VERBOSE}" ]] && alias "${NX_COMMAND:-n}${word:0:1}d"
      alias "${NX_COMMAND:-n}${word:0:1}g"="nx ${word#[a-z]/} --global"; [[ -n "${NX_VERBOSE}" ]] && alias "${NX_COMMAND:-n}${word:0:1}g"
    fi
  done
fi
