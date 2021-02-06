alias R='R --no-restore '

alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'

git-branch-info() {
  git symbolic-ref --short "HEAD" 2>/dev/null | sed -e 's@^@(@g' -e 's@$@)@g'
}

upgradeoutdated() {
  if which apt-get > /dev/null 2>&1 ; then
    sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get autoclean -y && sudo apt-get autoremove -y
  fi
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

export PS1='\u@\h: \w\n[jobs: \j] $(git-branch-info) \$ '
export EDITOR="vi"
export VROOT=${HOME}/VROOT
export PATH=${PATH}:${VROOT}/bin

## Neat idea from https://github.com/jessfraz/dotfiles/blob/master/.bashrc
for file in ~/.{aliases,functions,path,dockerfunc,extra,exports}; do
    if [[ -r ${file} ]] && [[ -f ${file} ]]; then
        source "${file}"
    fi
done
unset file

#### ## Some very useful functions
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
recbyfld() { paste <(head -n1 "$1" | tr '\t' '\n') <(sed -n "$2p" "$1" | tr '\t' '\n') | nl ; }
tally() { tail -n +2 "$1" | cut -f"$2" | sort | uniq -c | sed 's/^[ ]*//;s/ /\t/'; }
csv2tsv() {
  sed 's/""/@@@/g' "$1" | awk -v FPAT='[^,]*|"[^"]*"' -v OFS="\t" '{$1=$1; gsub(/"/,""); print}' | sed 's/\t@@@\t/\t\t/g;s/@@@/"/g' > tsv_"$1"
}
tsv2csv() {
  sed 's/\t/","/g;s/^/"/;s/$/"/' "$1" > "$2"
}
