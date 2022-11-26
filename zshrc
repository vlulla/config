## Neat idea from https://github.com/jessfraz/dotfiles/blob/master/.bashrc
for file in ~/.{aliases,functions,path,dockerfunc,extra,exports}; do
    if [[ -r ${file} ]] && [[ -f ${file} ]]; then
        source "${file}"
    fi
done
unset file

git_branch_info() {
  git symbolic-ref --short "HEAD" 2>/dev/null | sed -e 's@^@ (@g' -e 's@$@)@g'
}
## precmd() { RPROMPT="$(git_branch_info)" } ## For right prompt!!

getinteractive() {
    if which qsub>/dev/null 2>&1 ; then
        qsub -I -q interactive -l nodes=1:ppn=8,walltime=08:00:00
    fi
}

upgradeoutdated() {
  local sys
  local cmd
  local bold
  local reset
  sys=$(grep "^ID=" /etc/os-release | tr -d $'"')
  cmd=""
  bold=$(tput bold)
  reset=$(tput sgr0)
  case "${sys##*=}" in
    ("ubuntu") cmd="sudo DEBIAN_FRONTEND=noninteractive apt-get update --yes && sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade --yes && sudo DEBIAN_FRONTEND=noninteractive apt-get autoclean --yes && sudo DEBIAN_FRONTEND=noninteractive apt-get autoremove --yes" ;;
    ("debian") cmd="sudo DEBIAN_FRONTEND=noninteractive apt-get update --yes && sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade --yes && sudo DEBIAN_FRONTEND=noninteractive apt-get autoclean --yes && sudo DEBIAN_FRONTEND=noninteractive apt-get autoremove --yes" ;;
    ("amzn" | "fedora") cmd="sudo dnf update --assumeyes && sudo dnf clean all --assumeyes && sudo dnf autoremove --assumeyes" ;;
    ("alpine") cmd="sudo apk update && sudo apk upgrade" ;;
    ("freebsd") cmd="sudo pkg update && sudo pkg upgrade --yes" ;;
    (*) cmd="echo 'Do not know how to upgrade this system'" ;;
  esac
  echo "Will run the command:"
  echo "${bold}${cmd//&& /&& \\ \n}${reset}\n\n"
  eval "${cmd}"
}

updatecondaenvs() {
  local env
  local red
  local green
  local bold
  local reset
  env=""
  red=$(tput setaf 1)
  green=$(tput setaf 2)
  bold=$(tput bold)
  reset=$(tput sgr0)
  for env in $(mamba env list | awk '!/^#/{print $1}'); do
    echo "Updating mamba environment:   ${bold}${green}${env}${reset}"
    mamba update --update-all --yes --name "${env}"
  done
}

enable_OTB() {
  ## OTB related!  Commented because it interferes with lots of other things!
  otbenv_profile=${HOME}/code/rs_gis/OTB-6.6.1-Linux64/otbenv.profile
  if [[ -r "${otbenv_profile}" ]] && [[ -f "${otbenv_profile}" ]]; then
    source "${otbenv_profile}"
  fi
  unset otbenv_profile

  ## otbenv.profile modifies PATH and other env variables.  You can remove OTB
  ## the path variable using the following:
  ##
  ##   zsh:~ $ PATH=$(echo PATH | sed -e 's@/home/v/code/rs_gis/OTB-6.6.1-Linux64/bin:@@g')
}

removeduplicates() {
    ## Use this to remove duplicates from PATH and MANPATH
    ## Call it like:
    ##
    ##
    ## $ removeduplicates ${PATH} : | tr ':' '\n'
    ## $ # compare the above with echo ${PATH} | tr ':' '\n'
    ##
    ## $ export PATH=$(removeduplicates ${PATH} :)
    echo -n "$1" | awk -v RS="$2" -v ORS="$2" '{if (!arr[$0]++) {print $0}}' | sed -e "s@$2\$@@"
}

## From "Data cleaner's cookbook" https://www.datafix.com.au/cookbook/functions.html

## vf() { vim -o `fzf` } ## vim fuzzy!!  Use fzf fuzzy finder to find a file to open with vim
vf() {
  if /usr/bin/which fzf 2>/dev/null 1>&2 ; then
    ## vim -o $(fzf --preview='cat {}')
    export FZF_DEFAULT_OPTS='--height 40% --border'
    vim -o "$(fzf --reverse --preview='head -n 10 {}' --preview-window=up:10)"
  else
    vim
  fi
}
## following from https://www.datafix.com.au/cookbook/functions.html
fields() { head -n 1 "$1" | tr "\t" "\n" | nl -w1 | pr -t -2; }
broken() { awk -F"\t" '{print NF}' "$1" | sort | uniq -c | sed 's/^[ ]*//;s/ /\t/' | sort -nr; }
recbyfld() { paste <(head -n 1 "$1" | tr '\t' '\n') <(sed -n "$2p" "$1" | tr '\t' '\n') | nl; }
tally() { tail -n +2 "$1" | cut -f"$2" | sort | uniq -c | sed 's/^[ ]*//;s/ /\t/'; }
csv2tsv() {
  sed 's/""/@@@/g' "$1" | awk -v FPAT='[^,]*|"[^"]*"' -v OFS="\t" '{$1=$1; gsub(/"/, ""); print}' | sed 's/\t@@@\t/\t\t/g;s/@@@/"/g' > tsv_"$1"
}
tsv2csv() {
  sed 's/\t/","/g;s/^/"/;s/$/"/' "$1" > "$2"
}

## From https://github.com/jessfraz/dotfiles/blob/master/.dockerfunc
## See also: https://www.computerhope.com/unix/bash/mapfile.htm
dc() {
  local containers
  ## read -d '\n' containers < <(docker ps -aq 2>/dev/null)
  containers=$(docker ps -aq 2>/dev/null)
  echo "${containers[@]}"
}

dcup() {
  docker-compose up --build -d
}

dcdown() {
  docker-compose down
}

dcleanup() {
  ## mapfile works only in bash!
  ## local containers
  ## mapfile -t containers < <(docker ps -aq 2>/dev/null)
  docker rm $(docker ps -aq ) 2>/dev/null

  ## local volumes
  ## mapfile -t volumes < <(docker ps --filter status=exited -q 2>/dev/null)
  ## docker rm -v $(docker ps --filter status=exited -q ) 2>/dev/null
  ##
  #docker volume prune -f

  ## local images
  ## mapfile -t images < <(docker images --filter dangling=true -q 2>/dev/null)
  docker rmi $(docker images --filter dangling=true -q) 2>/dev/null
}

del_stopped() {
  local name=$1
  local state
  state=$(docker inpsect --format "{{.State.Running}}" "$name" 2>/dev/null)

  if [[ "$state" == "false" ]]; then
    docker rm "$name"
  fi
}

dockerpull() {
  local f
  for f in $(docker images --format "{{.Repository}}:{{.Tag}}" --filter "dangling=false"); do
    docker pull "${f}"
  done
  local dangling
  dangling="$(docker images -q --filter "dangling=true")"
  if [ ${#dangling} -gt 0 ]; then
    docker rmi "${dangling}"
  fi
}

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

fpath=(~/.zsh/completion $fpath)


export REPORTTIME=30  ## Very Useful!!

setopt PROMPT_SUBST   ## For prompt substitution

export PIPENV_VENV_IN_PROJECT=1
## PROMPT=$(print "\n%n@%m [jobs: %j] [shlvl: $SHLVL] %~\n%# ")
if [[ "aws" == "${$(uname -r)##*-}" ]]; then
  ## This only works for zsh.
  ## For bash you'll have to do something like this:
  ## u=$(uname -r)
  ## if [[ "aws" == "${u##*-}" ]]; then
  PUBLIC_HOSTNAME=$(curl -s 'http://169.254.169.254/latest/meta-data/public-hostname/')
else
  PUBLIC_HOSTNAME="%m"
fi
export PS1=$'\n%B%F{cyan}%n@${PUBLIC_HOSTNAME}%(2L. [SHLVL: %L].): %(8~|%-1~/.../%6~|%7~)%f%b\n%B[%D{%Y.%m.%d}]\$(git_branch_info) %#%b '
export RPROMPT="%(1j.%B%F{green}[Jobs: %j]%f%b.)%(?..%B%F{red} x %?%f%b)"
# if [[ -d "${HOME}/VROOT" && $SHLVL == 1 ]]; then
if [[ -d "${HOME}/VROOT" ]]; then
    export VROOT="${HOME}/VROOT"
    export VIRTUALROOT="${VROOT}"
    ## export PATH="${PATH:+${PATH}:}${VROOT}/bin"
    export PATH="${VROOT}/bin${PATH:+:${PATH}}"
fi


# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

## use setopt all by itself to see what zshoptions are different from default

## Zsh options
### Changing directories
setopt autopushd pushdignoredups

### Completion
setopt autolist autoparamslash autoremoveslash listambiguous listtypes

## ### Initialisation
## setopt allexport

### Expansion and globbing
setopt markdirs nomatch

### history
setopt histignorealldups histignorespace histreduceblanks histsavenodups nobanghist
# setopt sharehistory  ## enables EXTENDED_HISTORY too!

## job control
setopt autoresume longlistjobs monitor noclobber notify

## shell emulation
setopt ksharrays

### Zle options
setopt nobeep
# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
if which dircolors > /dev/null 2>&1 ; then
  eval "$(dircolors -b)"
fi
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

#####################################################################
#  Above was setup by first run of zsh
#
#  Below is my setup

if [[ -d "${HOME}/.cargo" ]]; then
    export PATH="${PATH:+${PATH}:}${HOME}/.cargo/bin"
fi
if [[ -d "${HOME}/mambaforge" ]]; then
    export CONDAHOME="${HOME}/mambaforge"
    export PATH="${PATH:+${PATH}:}${CONDAHOME}/bin"
fi

[[ -x "/usr/local/go/bin/go" ]] && export PATH="${PATH:+${PATH}:}/usr/local/go/bin"

if [[ -d "${HOME}/code/J/j903" ]]; then
    export JHOME=${HOME}/code/J/j903
    export PATH="${PATH:+${PATH}:}${JHOME}/bin"
fi

if [[ -d "${HOME}/.local/bin" ]]; then
    export PATH="${PATH}${PATH:+:}${HOME}/.local/bin"
fi
if [[ -d "${HOME}/bin" ]]; then
    export PATH="${HOME}/bin${PATH:+:${PATH}}"
fi
# OPAM configuration
[[ -f ${HOME}/.opam/opam-init/init.zsh ]] && source "${HOME}"/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
[[ -f ${CONDAHOME}/bin/aws_zsh_completer.sh ]] && source "${CONDAHOME}"/bin/aws_zsh_completer.sh
## Some aliases
[[ -f "${HOME}/code/config/bashrc" ]] && alias bash='bash --rcfile "${HOME}/code/config/bashrc" '
alias bc='bc -l'
alias cp='cp -iv'
alias date='date -Iseconds'
alias dm='docker-machine '
alias e='vim '
[ "$(uname)" = 'Linux' ] && alias ls='ls --quoting-style=shell-always --time-style="long-iso" '
alias l='ls '
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias llh='ls -lh'
alias mv='mv -iv'
alias rm='rm -I'
alias sqlite3='sqlite3 -init ${HOME}/.sqliterc '
alias v='vim '

# fix some typos
alias sl='ls'
alias c='cd'
alias vo='vim'
alias ci='vim'
alias iv='vim'
alias grpe='grep'
alias Grep='grep'
alias les='less'
alias Les='less'
alias Less='less'
alias cd.='cd .'
alias cd..='cd ..'

# Make piping easier...
# $ ls -la LL
# $ ls -la VV
alias -g VV=' |& view -'
alias -g LL=' |& less'

[[ -n "${LS_COLORS}" ]] && unset LS_COLORS
[[ -n "${ZLS_COLORS}" ]] && unset ZLS_COLORS

## man zshbuiltins  ...  /typeset
## typeset -U removes duplicates!!
typeset -U PATH path MANPATH manpath FPATH fpath

export PAGER=less
export LESS='-eiMFXsSx4R'
export LESSSECURE=1
export EDITOR='vi'
## export MANPAGER="vim -M +MANPAGER -" # breaks the info command!
# man ls ... then /(TIME|QUOTING)_STYLE
[[ -z "${TIME_STYLE}" ]] && export TIME_STYLE="long-iso"
[[ -z "${QUOTING_STYLE}" ]] && export QUOTING_STYLE="shell-always"

## if [ -x "$(command -v tmux)" ] && [ -n "${DISPLAY}" ]; then
##   [ -z "${TMUX}" ] && (tmux attach || tmux) >/dev/null 2>&1
## fi

## Some Python related stuff
## export PYTHONOPTIMIZE=2  ## causes lots of scripts to break (especially in ubuntu and miniconda!)
## export PYTHONWARNINGS=error ## This should be set, at least, during developing ...
## export PYTHONPROFILEIMPORTTIME=true ## ditto
## export PYTHONUTF8=1 ## aspire to uncmoment this!

## gdal related ... see https://gdal.org/gdal.pdf
export GDAL_CACHE_MAX=512
case "$(uname)" in
  "Linux")  export GDAL_NUM_THREADS=$(( $(nproc) - 2 )) ;;
  "Darwin") export GDAL_NUM_THREADS=$(( $(sysctl -n hw.physicalcpu) - 2 )) ;;
  "*")      export GDAL_NUM_THREADS=2
esac
export NUM_THREADS=${GDAL_NUM_THREADS}
export OPJ_NUM_THREADS=${GDAL_NUM_THREADS}
## GDAL/OGR options
export OGR_SQLITE_SYNCHRONOUS=OFF
export OGR_SQLITE_CACHE=1024
export OGR_SQL_LIKE_AS_ILIKE=YES
export FGDB_BULK_LOAD=YES
export COMPRESS=LERC_ZSTD
export SPARSE_OK=TRUE
export ZLEVEL=5
export ZSTD_LEVEL=7
export PG_USE_COPY=YES
export GDAL_DISABLE_READDIR_ON_OPEN=YES
export CPL_VSIL_CURL_ALLOWED_EXTENSIONS=tif
## Dask options
# From dask docs Dask searches for all environment variables that start with DASK_, then transforms keys by converting to lower case and changing double-underscores to nested structures.
export DASK_ARRAY__CHUNK_SIZE="128 MiB"
export DASK_DISTRIBUTED__WORKERS__MEMORY__SPILL=0.85
export DASK_DISTRIBUTED__WORKERS__MEMORY__TARGET=0.75
export DASK_DISTRIBUTED__WORKERS__MEMORY__TERMINATE=0.98
export PGTZ='utc'
export PGDATESTYLE='ISO,MDY"
