PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%c%{$reset_color%}"
PROMPT+=' $(vcs_info)'

# Display VCS info with jj/git fallback
vcs_info() {
  local ref=$(jj_prompt_template_raw 'if(bookmarks, bookmarks, change_id.short())' 2>/dev/null)
  local dirty_status=$(jj_prompt_template_raw 'if(self.working_copy_changes().files(root:""), "✗", "")' 2>/dev/null)
  
  if [[ -n "$ref" ]]; then
    echo -n "%{$fg_bold[blue]%}jj:(%{$fg[red]%}${ref}%{$reset_color%}${dirty_status}"
  else
    git_prompt_info
  fi
}