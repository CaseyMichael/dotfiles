# Install all default claude sub agents
function claude-install-default-agents() {
  local agents=(
    architect-reviewer
    code-reviewer
    performance-engineer
    graphql-architect
    ui-designer
    backend-developer
    api-designer
    typescript-pro
  )

  echo "Installing ${#agents[@]} default agents..."
  for agent in "${agents[@]}"; do
    claude-install-agent "$agent"
  done
  echo "✓ All default agents installed"
}

# install a specific claude sub agents
function claude-install-agent() {
  local agent_name="$1"
  local repo_dir="$HOME/Developer/awesome-claude-code-subagents"
  local agents_dir="$HOME/.config/claude/agents"

  if [ -z "$agent_name" ]; then
    echo "Usage: claude-install-agent <agent-name>"
    echo "Example: claude-install-agent code-reviewer"
    return 1
  fi

  # Find the agent file
  local agent_file=$(find "$repo_dir/categories" -type f -name "${agent_name}.md" ! -name "README.md" | head -n 1)

  if [ -z "$agent_file" ]; then
    echo "Error: Agent '$agent_name' not found"
    echo "Available agents:"
    find "$repo_dir/categories" -type f -name "*.md" ! -name "README.md" -exec basename {} .md \; | sort
    return 1
  fi

  # Create directory and copy file
  mkdir -p "$agents_dir"
  cp "$agent_file" "$agents_dir/${agent_name}.md"

  echo "✓ Installed agent: $agent_name"
  echo "  Location: $agents_dir/${agent_name}.md"
}
