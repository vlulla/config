alias R='R --no-restore '

alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'

gitinfo() {
  BRANCH=`git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/^* \(.*\)/\1/'`
  if [ "${BRANCH}" = "" ]
  ## if [ -z $BRANCH ]  ## This also works.
  then
    echo ""
  else
    echo "[branch: $BRANCH]"
  fi
}

export PS1='\u@\h [jobs: \j]$(gitinfo): \w\n\$ '
export VROOT=$HOME/VROOT
export PATH=$PATH:$VROOT/bin
