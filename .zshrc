#! /bin/zsh
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

typeset -A _zulu
_zulu="$HOME/.zsh"

###
# Plugins
###
source $_zulu/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $_zulu/plugins/zsh-histdb/sqlite-history.zsh
source $_zulu/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $_zulu/plugins/powerlevel10k/powerlevel10k.zsh-theme
###
#
# Histdb and autosuggestions strategy
_zsh_autosuggest_strategy_histdb_top_here() {
    local query="select commands.argv from
history left join commands on history.command_id = commands.rowid
left join places on history.place_id = places.rowid
where places.dir LIKE '$(sql_escape $PWD)%'
and commands.argv LIKE '$(sql_escape $1)%'
group by commands.argv order by count(*) desc limit 1"
    suggestion=$(_histdb_query "$query")
}

ZSH_AUTOSUGGEST_STRATEGY=histdb_top_here

fpath=($_zulu/plugins/zsh-completions/src $fpath)

export CLICOLOR=1
export GPG_TTY=$(tty)
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export NPM_TOKEN="npm_"
export GHCR_PAT="ghp_"

alias grep='grep --color=always'
alias lsa='ls -lah --color'
alias l='ls --color'
alias dive="docker run -ti --rm  -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive"

autoload -Uz add-zsh-hook
autoload -Uz compinit
autoload -U colors && colors

compinit -i

setopt interactivecomments
setopt correct
setopt autocd
setopt magicequalsubst
setopt notify
setopt numericglobsort

unsetopt BEEP
unsetopt nomatch

zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==34=34}:${(s.:.)LS_COLORS}")';
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:options' list-colors '=^(-- *)=34'
zstyle ':completion:*' menu select

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^H' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey -M viins '^a'    beginning-of-line
bindkey -M viins '^e'    end-of-line
bindkey -M viins '^k'    kill-line
bindkey -M viins '^w'    backward-kill-word
bindkey -M viins '^u'    backward-kill-line
zle -N edit-command-line
bindkey -M viins '^xe'  edit-command-line
bindkey -M viins '^x^e'  edit-command-line
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

HISTFILE=$HOME/.zsh_history       # enable history saving on shell exit
setopt SHARE_HISTORY           # share history between sessions
HISTSIZE=10000                  # lines of history to maintain memory
SAVEHIST=1000                  # lines of history to maintain in history file.
setopt HIST_EXPIRE_DUPS_FIRST  # allow dups, but expire old ones when I hit HISTSIZE
setopt EXTENDED_HISTORY        # save timestamp and runtime information
