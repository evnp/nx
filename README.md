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

`enex` lets you interact with any NPM package — that is, anything with a `package.json` — in as few keystrokes as you want (or as possible!). It's eminently configurable, but with a default setup of `source $HOME/enex/enex.sh` in your dotfile of choice, it will add these aliases to any shell:

```sh
n <cmd>     ->  npm <cmd> OR npm run <cmd> # enex intelligently adds `run`
                                           # only when necessary, but you
ns <opts>   ->  npm run start <opts>       # may use it if you prefer
nb <opts>   ->  npm run build <opts>
nf <opts>   ->  npm run format <opts>
nt <opts>   ->  npm run test <opts>
ntw <opts>  ->  npm run test -- --watch <opts>

ni <opts>   ->  npm install <opts>
nu <opts>   ->  npm uninstall <opts>
nis <opts>  ->  npm install --save <opts>
nus <opts>  ->  npm uninstall --save <opts>
nid <opts>  ->  npm install --save-dev <opts>
nud <opts>  ->  npm uninstall --save-dev <opts>
```

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

alias ns="enex start"      # -> npm start
alias nt="enex test"       # -> npm test; also ntw -> npm run test -- --watch
alias nb="enex build"      # -> npm run build
alias nf="enex format"     # -> npm run format
alias ni="enex install"    # -> npm install
alias nu="enex uninstall"  # -> npm uninstall
# also nis, nid, nus, nud for install/uninstall --save/--save-dev combinations, see above
```
If you'd like to opt out of these default aliases or customize them, use env vars when initializing `enex` to configure:
```sh
# to opt out of `n` alias and simply use the full command `enex`:
export ENEX_COMMAND=0; source "$HOME/enex/enex.sh"

# to opt out of enex aliasing altogether:
export ENEX_COMMAND=0; export ENEX_ALIASES=0; source "$HOME/enex/enex.sh"

# to use the custom command `myencmd` to invoke enex instead of `n`:
export ENEX_COMMAND=myencmd; source "$HOME/enex/enex.sh"
> alias myencmd="enex"

# to define your own custom set of enex aliases:
export ENEX_ALIASES=build,push,deploy; source "$HOME/enex/enex.sh"
> alias n="enex"
> alias nb="enex build"
> alias np="enex push"
> alias nd="enex deploy"
# note: this overrides the set of default aliases entirely, so you
#       will need to redefine them explicitly if some are desired
```

By default, if enex does not detect a `package.json` file within the directory it is being invoked from, it will search for one within directories up to 2 levels below, and an arbitary number of levels above, exiting immediately if it reaches your home directory. This allows you to run enex commands from anywhere within a project with this very common directory structure, or similar project structures:
```sh
$HOME/
 └─project/
   ├─backend/
   │ └─dir/
   └─frontend/
     ├─src/
     └─dir/
```
Normally, you'd need to first navigate to the `frontend/` before invoking any `npm` command; enex handles this step invisibly for you in a subshell, so that you remain in the same directory you started in after the operation is complete.

If for any reason you prefer to skip this "auto-find" step, add the following env var to your enex configuration:
```sh
export ENEX_FIND=0; source "$HOME/enex/enex.sh"
```

If you use [nvm](https://github.com/nvm-sh/nvm), enex can be configured to call `nvm use` before each command invocation to ensure NodeJS and NPM versions matching the current directory's `.nvmrc` are used. To enable this behavior, add the following env var to your enex configuration:
```sh
export ENEX_NVM=1; source "$HOME/enex/enex.sh"
```

If you'd like enex to await confirmation of current node+npm versions before executing commands, add the following env var to your enex configuration:
```sh
export ENEX_CONFIRM=1; source "$HOME/enex/enex.sh"
```

While sorting out configuration, it may be useful to have enex output the complete set of aliases that are generated when a new shell session begins. To do so, add:
```sh
export ENEX_VERBOSE=1; source "$HOME/enex/enex.sh"
```

That's it!

License
-------
MIT
