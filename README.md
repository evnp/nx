A minimalist command runner for npm packages, with a focus on developer ergonomics.

```
 __   __    __  __
/\ `./\ \  /\_\_\_\
\ \ .`.` \ \/_/\_\/_
 \ \_\ `._\  /\_\/\_\
  \/_/ \/_/  \/_/\/_/  npm execute
```

[![shellcheck](https://github.com/evnp/nx/workflows/shellcheck/badge.svg)](https://github.com/evnp/nx/actions)
[![latest release](https://img.shields.io/github/release/evnp/nx.svg)](https://github.com/evnp/nx/releases/latest)
[![npm package](https://img.shields.io/npm/v/nx.svg)](https://www.npmjs.com/package/nx)
[![license](https://img.shields.io/github/license/evnp/nx.svg?color=blue)](https://github.com/evnp/nx/blob/master/LICENSE.md)

`nx` lets you interact with any NPM package (anything with a `package.json`) in as few keystrokes as as possible.<br>
With a default setup of `source $HOME/nx/nx.sh` in your dotfile of choice, it will add these aliases to any shell:

```sh
n           ->  # show list of currently configured nx aliases
n <cmd>     ->  npm <cmd> OR npm run <cmd>  # nx intelligently adds `run`
                                            # only when necessary, but you
ns <opts>   ->  npm run start <opts>        # may use it if you prefer
nb <opts>   ->  npm run build <opts>
nf <opts>   ->  npm run format <opts>
nl <opts>   ->  npm run lint <opts>
nk <opts>   ->  npm run link <opts>
nt <opts>   ->  npm run test <opts>
nt w <opts> ->  npm run test --watch <opts>
#  w may be added to any nx command in place of --watch

ni <pkg>    ->  npm install <pkg>
nu <pkg>    ->  npm uninstall <pkg>
nis <pkg>   ->  npm install --save <pkg>
nus <pkg>   ->  npm uninstall --save <pkg>
nid <pkg>   ->  npm install --save-dev <pkg>
nud <pkg>   ->  npm uninstall --save-dev <pkg>
nig <pkg>   ->  npm install --global <pkg>
nug <pkg>   ->  npm uninstall --glboal <pkg>
```

Of these aliases, only `nl` exists as a pre-existing Bash command (<https://ss64.com/bash/nl.html>), used for prefixing file lines with line numbers. If you'd like to disable this particular `nx` alias so that the built-in `nl` is not overridden, use this configuration in your shell rc file:

```bash
export NX_ALIASES=install,uninstall,start,test,build,format,k/link,help; source "$HOME/nx/nx.sh"
```

`nx` is only 50 lines of code (with comments!) — if you're interested in knowing exactly what will be running on your system, peruse it [here](https://github.com/evnp/nx/blob/main/nx.sh). Any project that touts minimalism should strive to be understood completely within a few minutes; this is, and will remain, a goal of `nx`.

Setup
-----
```sh
npm install -g nx
which nx
> /some/path/to/node_modules/.bin/nx.sh

# add to your .bashrc / .zshrc / etc. ->
source "/some/path/to/node_modules/.bin/nx.sh"
```
Or if you prefer, install by checking out the repository manually:
```sh
git clone https://github.com/evnp/nx.git

# add to your .bashrc / .zshrc / etc. ->
source "$HOME/nx/nx.sh"

# or if you didn't check the repository in $HOME directory:
source "/your/path/to/repository/nx/nx.sh"
```
Open a new shell instance and `nx` will have initialized these aliases:
```sh
alias n="nx"  # -> contextually equivalent to `npm ...` or `npm run ...`

alias ns="nx start"      # -> npm start
alias nt="nx test"       # -> npm test; also ntw -> npm run test -- --watch
alias nb="nx build"      # -> npm run build
alias nf="nx format"     # -> npm run format
alias ni="nx install"    # -> npm install
alias nu="nx uninstall"  # -> npm uninstall
# also nis, nid, nus, nud for install/uninstall --save/--save-dev combinations, see above
```
If you'd like to opt out of these default aliases or customize them, use env vars when initializing `nx` to configure:
```sh
# to opt out of `n` alias and simply use the full command `nx`:
export NX_COMMAND=0; source "$HOME/nx/nx.sh"

# to opt out of nx aliasing altogether:
export NX_COMMAND=0; export NX_ALIASES=0; source "$HOME/nx/nx.sh"

# to use the custom command `myencmd` to invoke nx instead of `n`:
export NX_COMMAND=myencmd; source "$HOME/nx/nx.sh"
> alias myencmd="nx"

# to define your own custom set of nx aliases:
export NX_ALIASES=build,push,deploy; source "$HOME/nx/nx.sh"
> alias n="nx"
> alias nb="nx build"
> alias np="nx push"
> alias nd="nx deploy"
# note: this overrides the set of default aliases entirely, so you
#       will need to redefine them explicitly if some are desired

# to define an alias whose shortcut does not match its first letter:
export NX_ALIASES=build,x/specialthing,deploy; source "$HOME/nx/nx.sh"
> alias n="nx"
> alias nb="nx build"
> alias nx="nx specialthing"
> alias nd="nx deploy"
```


By default, if nx does not detect a `package.json` file within the directory it is being invoked from, it will search for one within directories up to 2 levels below, and an arbitary number of levels above, exiting immediately if it reaches your home directory. This allows you to run nx commands from anywhere within a project with this very common directory structure, or similar project structures:
```sh
$HOME/
 └─project/
   ├─backend/
   │ └─dir/
   └─frontend/
     ├─src/
     └─dir/
```
Normally, you'd need to first navigate to the `frontend/` before invoking any `npm` command; nx handles this step invisibly for you in a subshell, so that you remain in the same directory you started in after the operation is complete.

If for any reason you prefer to skip this "auto-find" step, add the following env var to your nx configuration:
```sh
export NX_FIND=0; source "$HOME/nx/nx.sh"
```

If you use [nvm](https://github.com/nvm-sh/nvm), nx can be configured to call `nvm use` before each command invocation to ensure NodeJS and NPM versions matching the current directory's `.nvmrc` are used. To enable this behavior, add the following env var to your nx configuration:
```sh
export NX_NVM=1; source "$HOME/nx/nx.sh"
```

If you'd like nx to await confirmation of current node+npm versions before executing commands, add the following env var to your nx configuration:
```sh
export NX_CONFIRM=1; source "$HOME/nx/nx.sh"
```

While sorting out configuration, it may be useful to have nx output the complete set of aliases that are generated when a new shell session begins. To do so, add:
```sh
export NX_VERBOSE=1; source "$HOME/nx/nx.sh"
```

That's it!

License
-------
MIT
