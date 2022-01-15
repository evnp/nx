A minimalist command runner for npm packages, with a focus on developer ergonomics.

```
 ______    __    __    ______    __  __
/\  ___\  /\ `. /\ \  /\  ___\  /\_\_\_\
\ \  ___\ \ \  `. \ \ \ \  ___\ \/_/\_\/_
 \ \_____\ \ \_\ `.\_\ \ \_____\  /\_\/\_\
  \/_____/  \/_/  \/_/  \/_____/  \/_/\/_/  n(pm) execute
```

[![shellcheck](https://github.com/evnp/enex/workflows/shellcheck/badge.svg)](https://github.com/evnp/enex/actions)
[![latest release](https://img.shields.io/github/release/evnp/enex.svg)](https://github.com/evnp/enex/releases/latest)
[![npm package](https://img.shields.io/npm/v/enex.svg)](https://www.npmjs.com/package/enex)
[![license](https://img.shields.io/github/license/evnp/enex.svg?color=blue)](https://github.com/evnp/enex/blob/master/LICENSE.md)

`enex` is only 50 lines of code (with comments!) — if you're interested in knowing exactly what will be running on your system, peruse it [here](https://github.com/evnp/enex/blob/main/enex.sh). Any project that touts minimalism should strive to be understood completely within a few minutes; this is, and will remain, a goal of `enex`.

Setup
-----
```sh
npm install -g enex
which enex
> /some/path/to/node_modules/.bin/enex.sh

# add to your .bashrc / .zshrc / etc. ->
source "/some/path/to/node_modules/.bin/enex.sh"
```
Or if you prefer, install by checking out the repository manually:
```sh
git clone https://github.com/evnp/enex.git

# add to your .bashrc / .zshrc / etc. ->
source "$HOME/enex/enex.sh"

# or if you didn't check the repository in $HOME directory:
source "/your/path/to/repository/enex/enex.sh"
```
Open a new shell instance and `enex` will have initialized these aliases:
```sh
alias n="enex"  # -> contextually equivalent to `npm ...` or `npm run ...`

alias ni="enex install"    # -> npm install
alias nu="enex uninstall"  # -> npm uninstall
alias ns="enex start"      # -> npm start
alias nt="enex test"       # -> npm test
alias nb="enex build"      # -> npm run build
alias nb="enex format"     # -> npm run format
```
If you'd like to opt out of these default aliases or customize them, use env vars when initializing `enex` to configure:
```sh
# to opt out of `n` alias and simply use the full command `enex`:
ENEX_COMMAND=0 source "$HOME/enex/enex.sh"

# to opt out of enex aliasing altogether:
ENEX_COMMAND=0 ENEX_ALIASES=0 source "$HOME/enex/enex.sh"

# to use the custom command `myencmd` to invoke enex instead of `n`:
ENEX_COMMAND=myencmd source "$HOME/enex/enex.sh"
> alias myencmd="enex"

# to define your own custom set of enex aliases:
ENEX_ALIASES=build,push,deploy source "$HOME/enex/enex.sh"
> alias n="enex"
> alias nb="enex build"
> alias np="enex push"
> alias nd="enex deploy"
# note: this overrides the set of default aliases entirely, so you
#       will need to redefine them explicitly if some are desired
```
During configuration, it may be useful to have enex output the complete set of aliases that are generated when a new shell session begins. To do so, add:
```sh
ENEX_VERBOSE=1 source "$HOME/enex/enex.sh"
```
That's it!

License
-------
MIT
