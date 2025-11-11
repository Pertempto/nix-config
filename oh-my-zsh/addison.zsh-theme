PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%c%{$reset_color%}"
PROMPT+=' $(vcs_info)'

vcs_info() {
  local system="" ref="" dirty_status=""

  # First, try getting the jj prompt
  if ref=$(jj_prompt_template_raw 'if(bookmarks, bookmarks, change_id.short())' 2>/dev/null); then
    system="jj"
  # Otherwise, try getting the git branch
  elif [[ -n "$(git branch --show-current)" ]]; then
    ref=$(git symbolic-ref --short HEAD 2>/dev/null | head -c 7)
    system="git"
  # Use current git commit hash as fallback
  else
    ref=$(git rev-parse --short HEAD)
    system="git"
  fi

  # Get dirty status for detected VCS
  # TODO: this isn't working for either system
  if [[ "$system" == "jj" ]]; then
    dirty_status=$(jj_prompt_template_raw 'if(self.working_copy_changes().files(root:""), "✗", "")' 2>/dev/null)
  elif [[ "$system" == "git" ]]; then
    dirty_status=$(git diff --shortstat 2>/dev/null | head -n 1)
  fi

  # Display prompt
  if [[ -n "$ref" ]]; then
    echo -n "%{$fg_bold[blue]%}${system}:(%{$fg[red]%}${ref}%{$reset_color%}%{$fg[blue]%}${dirty_status}%{$reset_color%}%{$fg_bold[blue]%})%{$reset_color%} "
  fi
}
