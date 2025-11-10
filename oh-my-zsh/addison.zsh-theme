PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%c%{$reset_color%}"
PROMPT+=' $(vcs_info)'

# Display VCS info with jj/git fallback
vcs_info() {
  local system=""
  local ref=""
  local dirty_status=""

  # Try jj first
  if ref=$(jj_prompt_template_raw 'if(bookmarks, bookmarks, change_id.short())' 2>/dev/null); then
    system="jj"
    dirty_status=$(jj_prompt_template_raw 'if(self.working_copy_changes().files(root:""), "✗", "")' 2>/dev/null)
  # Fall back to git
  elif ref=$(git symbolic-ref --short HEAD 2>/dev/null | head -c 7); then
    system="git"
    dirty_status=$(git diff --shortstat 2>/dev/null | head -n 1)
  fi

  if [[ -n "$ref" ]]; then
    echo -n "%{$fg_bold[blue]%}${system}:(%{$fg[red]%}${ref}%{$reset_color%}"
    echo -n "${dirty_status}%{$fg_bold[blue]%})%{$reset_bold%} "
  fi
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
