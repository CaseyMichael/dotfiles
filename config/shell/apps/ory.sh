alias ory='ory --format json-pretty'

function export-mcp-client() {
  ory get oauth2-client "$1" --format json |
    jq 'del(.client_id, .client_secret, .client_secret_expires_at, .created_at, .updated_at, .jwks)' \
      >"$2-client.json"
}
