alias g='git '
alias gco='git checkout origin/main'
alias gdash='gh dash'

# https://www.gh-dash.dev/getting-started/
function installGithubDashExtension() {
  gh extension install dlvhdr/gh-dash
}

# Prune local branches (and their worktrees) whose origin branch has been merged.
# Usage: git-prune-merged [--dry-run]
function git-prune-merged() {
  local dry_run=false
  [[ "${1:-}" == "--dry-run" ]] && dry_run=true

  if ! git rev-parse --git-dir &>/dev/null; then
    echo "Not inside a git repository." >&2
    return 1
  fi

  # Remove stale lock files left by crashed git processes
  local git_dir
  git_dir=$(git rev-parse --git-dir)
  find "$git_dir" -name "*.lock" -delete 2>/dev/null

  echo "Fetching from origin..."
  git fetch --prune origin

  # Determine default branch (main or master)
  local default_branch
  default_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||')
  [[ -z "$default_branch" ]] && default_branch="main"

  # Build a lookup of branch -> worktree path.
  # `git worktree list` format: /path/to/wt  <sha>  [branch-name]
  # The main worktree itself is included but we skip it when removing.
  local main_worktree_path
  main_worktree_path=$(git worktree list | awk 'NR==1{print $1}')

  declare -A worktree_for_branch
  while read -r wt_path _ wt_branch_raw; do
    local wt_branch="${wt_branch_raw//[\[\]]/}"
    [[ -n "$wt_branch" ]] && worktree_for_branch[$wt_branch]="$wt_path"
  done < <(git worktree list)

  # Get all local branch names (excluding default branch and current)
  local local_branches
  local_branches=$(git branch | sed 's/^[*+[:space:]]*//' | grep -vE "^(${default_branch}|master|main)$" | grep -v '^$')

  # Source 1: local branches with no corresponding remote branch (fetch would fail)
  echo "Checking remote branches..."
  local remote_branches
  remote_branches=$(git ls-remote --heads origin | awk '{print $2}' | sed 's|refs/heads/||')
  local no_remote_branches
  no_remote_branches=$(comm -23 \
    <(echo "$local_branches" | sort) \
    <(echo "$remote_branches" | sort))

  # Source 2: branches with a merged PR on GitHub
  echo "Checking merged PRs on GitHub..."
  local merged_on_github
  merged_on_github=$(gh pr list --state merged --limit 500 --json headRefName --jq '.[].headRefName' 2>/dev/null)
  local github_merged_branches
  github_merged_branches=$(comm -12 \
    <(echo "$local_branches" | sort) \
    <(echo "$merged_on_github" | sort))

  local merged_branches
  merged_branches=$(
    { echo "$no_remote_branches"; echo "$github_merged_branches"; } \
    | grep -v '^$' \
    | sort -u
  )

  if [[ -z "$merged_branches" ]]; then
    echo "No merged branches to clean up."
    return 0
  fi

  echo ""
  echo "Branches merged into origin/$default_branch:"
  while IFS= read -r branch; do
    local wt="${worktree_for_branch[$branch]:-}"
    if [[ -n "$wt" && "$wt" != "$main_worktree_path" ]]; then
      echo "  $branch  (worktree: $wt)"
    else
      echo "  $branch"
    fi
  done <<< "$merged_branches"

  if $dry_run; then
    echo ""
    echo "[dry-run] No changes made."
    return 0
  fi

  echo ""
  read -r "confirm?Delete all of the above? [y/N] "
  [[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; return 0; }

  while IFS= read -r branch; do
    local wt="${worktree_for_branch[$branch]:-}"

    # Remove the worktree first if it's a linked worktree (not the main one)
    if [[ -n "$wt" && "$wt" != "$main_worktree_path" ]]; then
      echo "Removing worktree: $branch"
      wt remove "$branch"
      # Prune stale worktree refs so git allows deleting the branch
      git worktree prune
    fi

    # Safe to force-delete since we already verified the branch is merged
    echo "Deleting branch: $branch"
    git branch -D "$branch"
  done <<< "$merged_branches"

  echo "Done."
}
