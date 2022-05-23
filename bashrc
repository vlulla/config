alias R='R --no-restore '

alias awk='awk --sandbox'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'

git-branch-info() {
  git symbolic-ref --short "HEAD" 2>/dev/null | sed -e 's@^@(@g' -e 's@$@)@g'
}

upgradeoutdated() {
  local sys
  local cmd
  sys=$(grep "^ID=" /etc/os-release | tr -d $'"')
  cmd=""
  case "${sys##*=}" in
    "ubuntu") cmd="sudo apt-get update --yes && sudo apt-get upgrade --yes && sudo apt-get autoclean --yes && sudo apt-get autoremove --yes" ;;
    "debian") cmd="sudo apt-get update --yes && sudo apt-get upgrade --yes && sudo apt-get autoclean --yes && sudo apt-get autoremove --yes" ;;
    "amzn") cmd="sudo yum update --assumeyes && sudo yum clean all --assumeyes && sudo yum autoremove --assumeyes" ;;
    "alpine") cmd="sudo apk update && sudo apk upgrade" ;;
    "freebsd") cmd="sudo pkg update && sudo pkg upgrade --yes" ;;
    "*") cmd="echo 'Do not know how to upgrade this system.'";;
  esac
  echo -e "Will run: ${cmd}\n"
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
export PS1='\u@\h: \w\n[jobs: \j] $(git-branch-info) \$ '
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

## gdal related ... see https://gdal.org/gdal.pdf
export GDAL_CACHE_MAX=512
export GDAL_NUM_THREADS=$(( $(nproc) - 2 ))
export NUM_THREADS=${GDAL_NUM_THREADS}
export OPJ_NUM_THREADS=${GDAL_NUM_THREADS}
export COMPRESS=LERC_ZSTD
export PREDICTOR=3
export ZLEVEL=5
export ZSTD_LEVEL=7
export PG_USE_COPY=YES
