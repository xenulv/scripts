#
# magic cross-platform "open" command
#
# if [ "$OSTYPE" == "cygwin" ]; then
#   alias open='cygstart'
# elif [ -f /usr/bin/xdg-open ]; then
alias open='xdg-open "$@" 2>/dev/null'
# elif [ -f /usr/bin/exo-open ]; then
#   alias open='exo-open "$@" 2>/dev/null'
# elif [ -f /usr/bin/gnome-open ]; then
#   alias open='gnome-open "$@" 2>/dev/null'
# fi

function alias_all_as_sudo() {
  for var in "$@"
  do
    alias $var="sudoifnotroot $var"
  done
}

## if CLICOLOR doesn't work, this can hard-wire color-ls
if [ "$TERM" != "dumb" ]; then
  #export LS_OPTIONS='--color=auto'
  eval `dircolors -b`
  alias ls="ls --color=auto"
fi

## aliases

# ls
alias ll='ls -l'
alias l='ls -al'
alias la='ls -la'
alias ll='ls -l'
alias lts='lt -s'

# cd
alias up='cd ..'
alias back='cd "$OLDPWD"'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
# alias +='pushd .'
# alias -- -='popd'

mkcd() {
  if [ ! -d "$@" ]; then
    mkdir "$@"
  fi
  cd "$@"
}

pushpath() {
  if [ "$1" == "" ]; then
    dir="$PWD"
  else
    dir="`readlink -m "$1"`"
  fi

  export PATH="$dir":$PATH
  echo "'$dir' added to path."
}

# filesystem
alias mv="mv -v"
alias cp="cp -v"
alias rm='trsh'
alias rehash='hash -r'
alias cx='chmod +x'
alias c-x='chmod -x'

# text
alias nano="nano -w"
alias pico="nano"
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias ag='ag --pager "less -RSFXi"'
alias less='less -X -F -i'
alias diff='diff -u'

# audio
alias a="audacious"
alias ae="a -e"
alias a2="a"

#if [ "$TERM" == "xterm" ]
#then
#  alias ssh='ssh-termtitle'
#fi

# net
alias_all_as_sudo iptables ifconfig route netctl ufw dhcpcd ip bhogs bwm-ng listening
alias ssh='ssh -2'
alias scpfast='scp -c arcfour128'
alias sshfast='ssh -c arcfour128'
alias mosh='msh'
alias bmon='bwm-ng'
alias whois='whois -H'
alias geoip='geoiplookup'
alias iptraf='sudoifnotroot iptraf-ng'

# disks
alias_all_as_sudo fdisk blkid fatrace
alias md='mdadm'
alias df='df -h'
alias screen='screen -U'
alias dd='dcfldd'
alias lsblk='lsblk -o MODEL,SIZE,TYPE,NAME,MOUNTPOINT,LABEL,FSTYPE'
alias disks='lsblk'

# system
alias_all_as_sudo sysdig swapped
alias dmesg='dmesg -T --color=always|less -S -R +\>'
alias dstat-wide='dstat -tcyifd'
alias off='sudoifnotroot shutdown -h now || sudoifnotroot systemctl poweroff'
alias reboot='sudoifnotroot shutdown -r now || sudoifnotroot systemctl reboot'
alias sus='ssu'

# systemd
alias_all_as_sudo systemctl journalctl
alias jc='journalctl'
alias jt='journalctl -f'
alias sys='systemctl'
alias j='journalctl'

# misc
alias dict='dictless'
alias chrome='google-chrome'
alias dmenu="dmenu -l 50"
alias resett="tput reset"
alias xmem='xrestop'
alias flash='crutziplayer'
alias rdp='xfreerdp'
alias gource='gource --user-image-dir ~/.cache/gravatars'
alias psx='pcsxr'
alias detach='bg; disown'
alias dpkg='sudoifnotroot dpkg'
alias record-desktop="simplescreenrecorder"
alias b='chromium'
alias qemu='qemu-system-x86_64 -enable-kvm'

# archives
alias ax="aunpack"
alias ac="apack"
alias al="als"

# git
alias git="hub"
alias gs="git status"
alias gd="git diff"
alias ga="git add"
#alias gl="git log"
alias gch="git checkout"
# alias g[[="git stash"
# alias g]]="git stash pop"
# alias g[]="git stash list; git stash show"
alias g+="git add"
alias gr="git remote -v"
alias cu="pull"

# alias gc="git clone"
gc() {
  # Cloning into 'reponame'...
  git clone "$@"
}

# ruby
alias r="rails"
alias be="bundle exec"
alias pad="padrino"
alias z='be zeus'
gem-cd() { cd `gem-dir $@` ;}


# Things with literal arguments!
#alias math='noglob math'
#alias gfv='noglob gfv'

# arch
alias pacman='sudo pacman'
alias pacs='pacman -Ss'   # search for package
alias pacg='pacman -Qg'   # show groups
alias pacu='pacman -Syu'  # update packages
alias pacd='pacman -Syuw' # only download updates (no install)
alias pacr='pacman -Rs'   # remove package (and unneeded dependencies)
alias pacrf='pacman -Rc'  # remove package (and force removal of dependencies)
alias pacpurge='pacman -Rns' # purge a package and all config files
alias pacf='pacman -Ql|grep' # which package contains this file?
alias pacq='pacman -Q|grep'  # find a package
alias pacuproot='pacman -Rsc' # remove package, dependencies, and dependants
alias y='yaourt'
alias yu='y -Syua'
alias abs='sudoifnotroot abs'
alias pkgfile='sudoifnotroot pkgfile'

