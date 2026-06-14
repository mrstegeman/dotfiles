local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %s)"
PROMPT=$'[%{$fg[yellow]%}%n%{$reset_color%}@%{$fg[blue]%}%m%{$reset_color%}]─[%{$fg[magenta]%}%~%{$reset_color%}]%{$reset_color%}$(git_prompt_info) % %{$reset_color%}
${ret_status} %{$reset_color%} '

PROMPT2="%{$fg_bold[black]%}%_> %{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="─[%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%}] %{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}]"
