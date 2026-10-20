alias ory='ory --format json-pretty'

function export-mcp-client() {
  ory get oauth2-client "$1" --format json |
    jq 'del(.client_id, .client_secret, .client_secret_expires_at, .created_at, .updated_at, .jwks)' \
      >"$2-client.json"
}

function export-company-mcp-clients() {
  if [[ -z "$1" ]]; then
    echo "usage: export-company-mcp-clients <companyEntityId> [output-file]" >&2
    return 1
  fi

  local owner="company:$1"
  local output="${2:-$1-clients.json}"
  local -a page_args=()
  local page

  while :; do
    page=$(ory list oauth2-clients --format json --page-size 250 "${page_args[@]}") || return 1
    printf '%s' "$page" | jq -c --arg owner "$owner" '.items[] | select(.owner == $owner)'
    [[ "$(printf '%s' "$page" | jq -r '.is_last_page')" == "true" ]] && break
    page_args=(--page-token "$(printf '%s' "$page" | jq -r '.next_page_token')")
  done |
    jq -s 'map(del(.client_id, .client_secret, .client_secret_expires_at, .created_at, .updated_at, .jwks))' \
      >"$output"

  echo "wrote $(jq 'length' "$output") clients for $owner to $output" >&2
}
