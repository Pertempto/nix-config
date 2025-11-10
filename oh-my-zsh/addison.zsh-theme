PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%c%{$reset_color%}"
PROMPT+=' $(jj_prompt_info)'

jj_prompt_info() {
  local ref=$(jj_prompt_template_raw 'if(bookmarks, bookmarks, change_id.short())') || return
  local dirty_status=$(jj_prompt_template_raw 'if(self.working_copy_changes().files(root:""), "✗", "")') || return
  echo -n "${ZSH_THEME_JJ_PROMPT_PREFIX}${ref}${ZSH_THEME_JJ_PROMPT_SUFFIX}${dirty_status}"
}

ZSH_THEME_JJ_PROMPT_PREFIX="%{$fg_bold[blue]%}jj:(%{$fg[red]%}"
ZSH_THEME_JJ_PROMPT_SUFFIX="%{$fg[blue]%}) %{$fg[yellow]%}"
