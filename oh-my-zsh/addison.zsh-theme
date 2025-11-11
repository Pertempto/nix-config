PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%c%{$reset_color%}"
PROMPT+=' $(vcs_info)'

vcs_info() {
  local system="" ref="" dirty_status=""

  # First, try getting the jj prompt
  if ref=$(jj_prompt_template_raw 'if(bookmarks, bookmarks, change_id.short())' 2>/dev/null); then
    system="jj"
  # Otherwise, try getting the git branch
  elif [[ -n "$(git branch --show-current 2>/dev/null)" ]]; then
    ref=$(git symbolic-ref --short HEAD 2>/dev/null)
    system="git"
  # Use current git commit hash as fallback
  else
    ref=$(git rev-parse --short HEAD 2>/dev/null)
    system="git"
  fi

  # Get dirty status for detected VCS
  if [[ "$system" == "jj" ]]; then
    if [[ -n "$(jj diff 2>/dev/null)" ]]; then
      dirty_status="✗ "
    fi
  elif [[ "$system" == "git" ]]; then
    if [[ -n "$(git diff --shortstat 2>/dev/null)" ]]; then
      dirty_status="✗ "
    fi
  fi

  # Display prompt
  if [[ -n "$ref" ]]; then
    echo -n "%{$fg_bold[blue]%}${system}:(%{$fg[red]%}${ref}%{$reset_color%}%{$fg_bold[blue]%})%{$reset_color%} %{$fg[yellow]%}${dirty_status}%{$reset_color%}"
  fi
}
