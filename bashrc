shopt -s globstar

alias R='R --no-restore '

alias awk='awk --sandbox'
alias bc='bc -l'
alias cp='cp -iv'
alias e='vim '
[ "$(uname)" = 'Linux' ] && alias ls='ls --quoting-style=shell-always --time-style="long-iso" '
alias l='ls '
alias la='ls -a'
alias lla='ls -la'
alias llh='ls -lh'
alias mv='mv -iv'
alias python='python -I '
alias python3='python3 -I '
alias rm='rm -iv'
[[ -f "${HOME}/.sqliterc" ]] && alias sqlite3='sqlite3 -init ${HOME}/.sqliterc '
alias v='vim '

# fix some typos
alias sl='ls'
alias c='cd'
alias vo='vim'
alias ci='vim'
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
alias VV=' |& view -'
alias LL=' |& less'

git-branch-info() {
  git symbolic-ref --short "HEAD" 2>/dev/null | sed -e 's@^@(@g' -e 's@$@)@g'
}

upgradeoutdated() {
  local sys=$(grep "^ID=" /etc/os-release | tr -d $'"') cmd=""
  case "${sys##*=}" in
    ("ubuntu") cmd="sudo DEBIAN_FRONTEND=noninteractive apt-get update --yes && sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade --yes && sudo DEBIAN_FRONTEND=noninteractive apt-get autoclean --yes && sudo DEBIAN_FRONTEND=noninteractive apt-get autoremove --yes" ;;
    ("debian") cmd="sudo DEBIAN_FRONTEND=noninteractive apt-get update --yes && sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade --yes && sudo DEBIAN_FRONTEND=noninteractive apt-get autoclean --yes && sudo DEBIAN_FRONTEND=noninteractive apt-get autoremove --yes" ;;
    ("amzn") cmd="sudo yum update --assumeyes && sudo yum clean all --assumeyes && sudo yum autoremove --assumeyes" ;;
    ("alpine") cmd="sudo apk update && sudo apk upgrade" ;;
    ("freebsd") cmd="sudo pkg update && sudo pkg upgrade --yes" ;;
    (*) cmd="echo 'Do not know how to upgrade this system.'";;
  esac
  echo -e "Will run: ${cmd//&& /&& \\ '\n'}\n"
  eval "${cmd}"
}

updatecondaenvs() {
  local env="" red=$(tput setaf 1) green=$(tput setaf 2) bold=$(tput bold) reset=$(tput sgr0)
  for env in $(conda env list | awk '!/^#/{print $1}'); do
    echo "Updating conda environment:   ${bold}${green}${env}${reset}"
    conda update --update-all --yes --name "${env}"
  done
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

export PROMPT_DIRTRIM=7
export PS1='\u@\h [SHLVL: ${SHLVL}]: \w\n[jobs: \j] $(git-branch-info) \$ '
export EDITOR="vi"
if [ -d "${VROOT}" ]; then
  export VROOT=${HOME}/VROOT
  export VIRTUALROOT=${VROOT}
  export PATH="${VROOT}/bin${PATH:+:${PATH}}"
fi

## Neat idea from https://github.com/jessfraz/dotfiles/blob/master/.bashrc
for file in ~/.{aliases,functions,path,dockerfunc,extra,exports}; do
    if [[ -r ${file} ]] && [[ -f ${file} ]]; then
        source "${file}"
    fi
done
unset file

#### ## Some very useful functions
## following from https://www.datafix.com.au/cookbook/functions.html
fields() { head -n 1 "$1" | tr "\t" "\n" | nl -w1 | pr -t -2; }
broken() { awk -F"\t" '{print NF}' "$1" | sort | uniq -c | sed 's/^[ ]*//;s/ /\t/' | sort -nr; }
recbyfld() { paste <(head -n1 "$1" | tr '\t' '\n') <(sed -n "$2p" "$1" | tr '\t' '\n') | nl ; }
tally() { tail -n +2 "$1" | cut -f"$2" | sort | uniq -c | sed 's/^[ ]*//;s/ /\t/'; }
csv2tsv() {
  sed 's/""/@@@/g' "$1" | awk -v FPAT='[^,]*|"[^"]*"' -v OFS="\t" '{$1=$1; gsub(/"/,""); print}' | sed 's/\t@@@\t/\t\t/g;s/@@@/"/g' > tsv_"$1"
}
tsv2csv() {
  sed 's/\t/","/g;s/^/"/;s/$/"/' "$1" > "$2"
}
vf() {
  if which fzf 2>/dev/null 1>&2 ; then
    export FZF_DEFAULT_OPTS='--height 40% --border'
    vim -o "$(fzf --reverse --preview='head -n 10 {}' --preview-window=up:10)"
  else
    vim
  fi
}

[[ -z "${TIME_STYLE}" ]] && export TIME_STYLE="long-iso"
[[ -z "${QUOTING_STYLE}" ]] && export QUOTING_STYLE="shell-always"

## Some Python related stuff
## export PYTHONOPTIMIZE=2  ## causes lots of scripts to break (especially in ubuntu and miniconda)
## export PYTHONWARNINGS=error ## Should be set, at least, during developing...
## export PYTHONPROFILEIMPORTTIME=true ## ditto
## export PYTHONUTF8=1 ## aspire to uncomment this!
export PYTHONSAFEPATH=1 ## don't add pwd to sys.path. To avoid custom code execution/injection!

## gdal related ... see https://gdal.org/gdal.pdf
export GDAL_CACHE_MAX=512
case "$(uname)" in
  "Linux")  export GDAL_NUM_THREADS=$(( $(nproc) - 2 )) ;;
  "Darwin") export GDAL_NUM_THREADS=$(( $(sysctl -n hw.physicalcpu) - 2 )) ;;
  "*")      export GDAL_NUM_THREADS=2 ;;
esac
export NUM_THREADS=${GDAL_NUM_THREADS}
export OPJ_NUM_THREADS=${GDAL_NUM_THREADS}
export COMPRESS=LERC_ZSTD
export PREDICTOR=3
export ZLEVEL=5
export ZSTD_LEVEL=7
export PG_USE_COPY=YES
export GDAL_DISABLE_READDIR_ON_OPEN=YES
export CPL_VSIL_CURL_ALLOWED_EXTENSIONS=tif
## Dask related
# Dask searches for all environment variables that start with DASK_, then transforms keys by converting to lower case and changing double-underscores to nested structures.
export DASK_ARRAY__CHUNK_SIZE="128 MiB"
export DASK_DISTRIBUTED__WORKERS__MEMORY__SPILL=0.85
export DASK_DISTRIBUTED__WORKERS__MEMORY__TARGET=0.75
export DASK_DISTRIBUTED__WORKERS__MEMORY__TERMINATE=0.98
export PGTZ='utc'
export PGDATESTYLE='ISO,MDY'
