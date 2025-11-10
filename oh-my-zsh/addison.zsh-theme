PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%c%{$reset_color%}"
PROMPT+=' $(vcs_info)'

vcs_info() {
  local system="" ref="" dirty_status=""

  # VCS detection: jj first, then git (branch or detached HEAD)
  if ref=$(jj_prompt_template_raw 'if(bookmarks, bookmarks, change_id.short())' 2>/dev/null); then
    system="jj"
  elif git symbolic-ref --short HEAD 2>/dev/null | head -c 7 | read -r ref; then
    system="git"
  elif ref=$(git describe --tags --always --abbrev=7 2>/dev/null); then
    system="git"
  fi

  # Get dirty status for detected VCS
  if [[ "$system" == "jj" ]]; then
    dirty_status=$(jj_prompt_template_raw 'if(self.working_copy_changes().files(root:""), "✗", "")' 2>/dev/null)
  elif [[ "$system" == "git" ]]; then
    dirty_status=$(git diff --shortstat 2>/dev/null | head -n 1)
  fi

  # Display prompt
  if [[ -n "$ref" ]]; then
    echo -n "%{$fg_bold[blue]%}${system}:(%{$fg[red]%}${ref}%{$reset_color%}${dirty_status}%{$fg_bold[blue]%})%{$reset_bold%} "
  fi
}
