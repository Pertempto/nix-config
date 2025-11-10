PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%c%{$reset_color%}"
PROMPT+=' $(jj_prompt_info)'

jj_prompt_info() {
  if jj root &>/dev/null; then
    local branch=$(jj log -r @ --no-graph -T 'bookmarks' 2>/dev/null | head -n1)
    local change_id=$(jj log -r @ --no-graph -T 'change_id.short()' 2>/dev/null | head -n1)
    local has_changes=$(jj diff --summary 2>/dev/null | grep -q . && echo "dirty" || echo "clean")
    
    if [[ -n "$branch" ]]; then
      echo -n "${ZSH_THEME_JJ_PROMPT_PREFIX}${branch}${ZSH_THEME_JJ_PROMPT_SUFFIX}"
    else
      echo -n "${ZSH_THEME_JJ_PROMPT_PREFIX}${change_id}${ZSH_THEME_JJ_PROMPT_SUFFIX}"
    fi
    
    if [[ "$has_changes" == "dirty" ]]; then
      echo -n "${ZSH_THEME_JJ_PROMPT_DIRTY}"
    else
      echo -n "${ZSH_THEME_JJ_PROMPT_CLEAN}"
    fi
  fi
}

ZSH_THEME_JJ_PROMPT_PREFIX="%{$fg_bold[blue]%}jj:(%{$fg[red]%}"
ZSH_THEME_JJ_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_JJ_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
ZSH_THEME_JJ_PROMPT_CLEAN="%{$fg[blue]%})"
