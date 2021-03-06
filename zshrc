
git_branch_info() {
  git symbolic-ref --short "HEAD" 2>/dev/null | sed -e 's@^@«@g' -e 's@$@»@g'
}
## precmd() { RPROMPT="$(git_branch_info)" } ## For right prompt!!

getinteractive() {
    if which qsub>/dev/null 2>&1 ; then
        qsub -I -q interactive -l nodes=1:ppn=8,walltime=08:00:00
    fi
}

upgradeoutdated() {
  if which apt-get > /dev/null 2>&1 ; then
    sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get autoclean -y && sudo apt-get autoremove -y
  fi
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
    echo -n $1 | awk -v RS=$2 -v ORS=$2 '{if (!arr[$0]++) {print $0}}' | sed -e "s@$2\$@@"
}

## From "Data cleaner's cookbook" https://www.datafix.com.au/cookbook/functions.html

## vf() { vim -o `fzf` } ## vim fuzzy!!  Use fzf fuzzy finder to find a file to open with vim
vf() {
  if /usr/bin/which fzf 2>/dev/null 1>&2 ; then
    ## vim -o $(fzf --preview='cat {}')
    vim -o $(fzf)
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
  for f in $(docker images --format "{{.Repository}}"); do
    docker pull ${f}
  done
  local dangling=$(docker images -q --filter "dangling=true")
  if [ ${#dangling} -gt 0 ]; then
    docker rmi ${dangling}
  fi
}

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

fpath=(~/.zsh/completion $fpath)


REPORTTIME=30  ## Very Useful!!

setopt PROMPT_SUBST   ## For prompt substitution

export PIPENV_VENV_IN_PROJECT=1
## PROMPT=$(print "\n%n@%m [jobs: %j] [shlvl: $SHLVL] %~\n%# ")
export PS1=$'\n%B%F{cyan}%n@%m%(2L. [SHLVL: %L].): %~%f%b\n%B[%D{%Y.%m.%d}]\$(git_branch_info) %#%b '
export RPROMPT="%(1j.%B%F{green}[Jobs: %j]%f%b.)%(?..%B%F{red} x %?%f%b)"
# if [[ -d "${HOME}/VROOT" && $SHLVL == 1 ]]; then
if [[ -d "${HOME}/VROOT" ]]; then
    export VROOT="${HOME}/VROOT"
    export VIRTUALROOT="${HOME}/VROOT"
    ## export PATH="${PATH}${PATH:+:}${VROOT}/bin"
    export PATH="${VROOT}/bin${PATH:+:}${PATH}"
fi


# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

## use setopt all by itself to see what zshoptions are different from default

## Zsh options
### Changing directories
setopt autopushd pushdignoredups

### Completion
setopt autolist autoparamslash autoremoveslash listambiguous listtypes

### Expansion and globbing
setopt markdirs nomatch

### history
setopt histignorealldups histignorespace histreduceblanks histsavenodups nobanghist
# setopt sharehistory  ## enables EXTENDED_HISTORY too!

## job control
setopt autoresume longlistjobs monitor noclobber notify

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


zstyle ':completion:*' users-hosts 'vlulla@quarry.uits.iu.edu' 'vlulla@karst.uits.iu.edu' 'vlulla@apps.science.iupui.edu'
if [[ -d "${HOME}/.cargo" ]]; then
    export PATH="${PATH}${PATH:+:}${HOME}/.cargo/bin"
fi
if [[ -d "${HOME}/anaconda3" ]]; then
    export CONDAHOME="${HOME}/anaconda3"
    export PATH="${PATH}${PATH:+:}${CONDAHOME}/bin"
fi
if [[ -d "${HOME}/code/go/gocode" ]]; then
    test -f "/usr/local/go/bin/go" && export PATH="${PATH:+${PATH}:}/usr/local/go/bin"
    export GOPATH=${HOME}/code/go/gocode
    export PATH="${PATH}${PATH:+:}${GOPATH}/bin"
    export GO111MODULE=on
fi

if [[ -d "${HOME}/code/J/j901" ]]; then
    export JHOME=${HOME}/code/J/j901
    export PATH="${PATH}${PATH:+:}${JHOME}/bin"
fi

if [[ -n "${VROOT}" && -d "${VROOT}/julia-1.5.3" ]]; then
    export JULIAHOME="${VROOT}/julia-1.5.3"
    export PATH="${PATH}${PATH:+:}${JULIAHOME}/bin"
    ## export MANPATH="${MANPATH}${MANPATH:+:}${JULIAHOME}/share/man"
fi


if [[ -d "${HOME}/.local" ]]; then
    export PATH="${PATH}${PATH:+:}${HOME}/.local/bin"
fi
if [[ -d "${HOME}/code/racket/racket7.4" ]]; then
    export RACKETHOME=$HOME/code/racket/racket7.4
    export PATH="${PATH}${PATH:+:}${RACKETHOME}/bin"
    ## export MANPATH="${MANPATH}${MANPATH:+:}${RACKETHOME}/man"
fi
if [[ -d "${HOME}/code/swift/swift-5.1.3-RELEASE-ubuntu18.04" ]]; then
    export SWIFTHOME="${HOME}/code/swift/swift-5.1.3-RELEASE-ubuntu18.04"
    export PATH="${PATH}${PATH:+:}${SWIFTHOME}/usr/bin"
    ## export MANPATH="${MANPATH}${MANPATH:+:}${SWIFTHOME}/usr/share/man"
fi
# OPAM configuration
[[ -f ${HOME}/.opam/opam-init/init.zsh ]] && . /home/v/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
[[ -f ${CONDAHOME}/bin/aws_zsh_completer.sh ]] && source ${CONDAHOME}/bin/aws_zsh_completer.sh
## Some aliases
alias bc='bc -l'
alias cp='cp -iv'
alias dm='docker-machine '
alias e='vim '
alias fsi='dotnet fsi'
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

[[ ! -z "${LS_COLORS}" ]] && unset LS_COLORS
[[ ! -z "${ZLS_COLORS}" ]] && unset ZLS_COLORS

## man zshbuiltins  ...  /typeset
## typeset -U removes duplicates!!
typeset -U PATH path MANPATH manpath FPATH fpath

export PAGER=less
export LESS='-eiMFXsSx4r'
export EDITOR='vi'
## export MANPAGER="vim -M +MANPAGER -" # breaks the info command!

