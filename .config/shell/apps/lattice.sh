alias pb='pnpm bootstrap'
alias pfw='pnpm -F weaver'
alias pfd='pnpm -F dazzle'

function updateTsgo() {
  npm install -g @typescript/native-preview
}

alias psfon='pnpm statsigFlag:on'
alias psfoff='pnpm statsigFlag:off'

# AWS SQS Local Development Utilities
# These functions work with local SQS (LocalStack, ElasticMQ, etc.)

# Get the SQS endpoint URL (checks env vars, defaults to LocalStack)
function sqs-endpoint() {
  echo "${AWS_ENDPOINT_URL:-${LOCALSTACK_ENDPOINT:-${SQS_ENDPOINT:-http://localhost:4566}}}"
}

# Internal helper: Resolve queue name to queue URL
function _sqs-resolve-queue-url() {
  if [ -z "$1" ]; then
    return 1
  fi
  
  local queue_name="$1"
  local endpoint=$(sqs-endpoint)
  local queue_url=$(aws-local sqs get-queue-url \
    --queue-name "$queue_name" \
    --endpoint-url "$endpoint" \
    --query 'QueueUrl' \
    --output text 2>/dev/null)
  
  if [ -z "$queue_url" ]; then
    echo "Error: Queue '$queue_name' not found" >&2
    return 1
  fi
  
  echo "$queue_url"
}

# List all queues that have more than 0 messages
function sqs-queues-with-messages() {
  local endpoint=$(sqs-endpoint)
  local queues=$(aws-local sqs list-queues --endpoint-url "$endpoint" --query 'QueueUrls[]' --output text 2>/dev/null)
  
  if [ -z "$queues" ]; then
    echo "No queues found or unable to connect to endpoint: $endpoint"
    return 1
  fi
  
  echo "Checking queues for messages (endpoint: $endpoint)..."
  echo ""
  
  for queue_url in $queues; do
    local count=$(aws-local sqs get-queue-attributes \
      --queue-url "$queue_url" \
      --attribute-names ApproximateNumberOfMessages \
      --endpoint-url "$endpoint" \
      --query 'Attributes.ApproximateNumberOfMessages' \
      --output text 2>/dev/null)
    
    if [ -n "$count" ] && [ "$count" -gt 0 ]; then
      local queue_name=$(basename "$queue_url")
      printf "%-60s %s messages\n" "$queue_name" "$count"
    fi
  done
}

# Get messages from a queue
# Usage: sqs-get-messages <queue-name> [max-messages] [wait-seconds]
function sqs-get-messages() {
  if [ -z "$1" ]; then
    echo "Usage: sqs-get-messages <queue-name> [max-messages] [wait-seconds]"
    echo "  queue-name: name of the queue (e.g., weaver-worker-job-architecture-default-attributes)"
    echo "  max-messages: number of messages to receive (default: 10, max: 10)"
    echo "  wait-seconds: long polling wait time (default: 0, max: 20)"
    return 1
  fi
  
  local queue_name="$1"
  local max_messages="${2:-10}"
  local wait_seconds="${3:-0}"
  local endpoint=$(sqs-endpoint)
  
  local queue_url=$(_sqs-resolve-queue-url "$queue_name")
  if [ $? -ne 0 ]; then
    return 1
  fi
  
  if [ "$max_messages" -gt 10 ]; then
    max_messages=10
  fi
  
  if [ "$wait_seconds" -gt 20 ]; then
    wait_seconds=20
  fi
  
  echo "Receiving messages from queue: $queue_name"
  echo "Endpoint: $endpoint"
  echo ""
  
  aws-local sqs receive-message \
    --queue-url "$queue_url" \
    --max-number-of-messages "$max_messages" \
    --wait-time-seconds "$wait_seconds" \
    --endpoint-url "$endpoint" \
    --output json
}

# Get message count for a queue
# Usage: sqs-queue-count <queue-name>
function sqs-queue-count() {
  if [ -z "$1" ]; then
    echo "Usage: sqs-queue-count <queue-name>"
    echo "  queue-name: name of the queue (e.g., weaver-worker-job-architecture-default-attributes)"
    return 1
  fi
  
  local queue_name="$1"
  local endpoint=$(sqs-endpoint)
  
  local queue_url=$(_sqs-resolve-queue-url "$queue_name")
  if [ $? -ne 0 ]; then
    return 1
  fi
  
  aws-local sqs get-queue-attributes \
    --queue-url "$queue_url" \
    --attribute-names ApproximateNumberOfMessages ApproximateNumberOfMessagesNotVisible \
    --endpoint-url "$endpoint" \
    --query 'Attributes' \
    --output json
}

# List all queues
function sqs-list-queues() {
  local endpoint=$(sqs-endpoint)
  
  echo "Queues (endpoint: $endpoint):"
  aws-local sqs list-queues --endpoint-url "$endpoint" --output table
}

# Get queue URL from queue name
# Usage: sqs-get-queue-url <queue-name>
function sqs-get-queue-url() {
  if [ -z "$1" ]; then
    echo "Usage: sqs-get-queue-url <queue-name>"
    return 1
  fi
  
  local queue_name="$1"
  local endpoint=$(sqs-endpoint)
  
  aws-local sqs get-queue-url \
    --queue-name "$queue_name" \
    --endpoint-url "$endpoint" \
    --query 'QueueUrl' \
    --output text
}

# Send a test message to a queue
# Usage: sqs-send-message <queue-name> [message-body]
function sqs-send-message() {
  if [ -z "$1" ]; then
    echo "Usage: sqs-send-message <queue-name> [message-body]"
    echo "  queue-name: name of the queue (e.g., weaver-worker-job-architecture-default-attributes)"
    return 1
  fi
  
  local queue_name="$1"
  local message_body="${2:-{\"test\": \"message\", \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}}"
  local endpoint=$(sqs-endpoint)
  
  local queue_url=$(_sqs-resolve-queue-url "$queue_name")
  if [ $? -ne 0 ]; then
    return 1
  fi
  
  echo "Sending message to: $queue_name"
  aws-local sqs send-message \
    --queue-url "$queue_url" \
    --message-body "$message_body" \
    --endpoint-url "$endpoint" \
    --output json
}

# Purge a queue
# Usage: sqs-purge-queue <queue-name>
function sqs-purge-queue() {
  if [ -z "$1" ]; then
    echo "Usage: sqs-purge-queue <queue-name>"
    echo "  queue-name: name of the queue (e.g., weaver-worker-job-architecture-default-attributes)"
    return 1
  fi
  
  local queue_name="$1"
  local endpoint=$(sqs-endpoint)
  
  local queue_url=$(_sqs-resolve-queue-url "$queue_name")
  if [ $? -ne 0 ]; then
    return 1
  fi
  
  echo "Purging queue: $queue_name"
  aws-local sqs purge-queue \
    --queue-url "$queue_url" \
    --endpoint-url "$endpoint"
  
  if [ $? -eq 0 ]; then
    echo "Queue purged successfully"
  fi
}

# Get all attributes for a queue
# Usage: sqs-queue-attributes <queue-name>
function sqs-queue-attributes() {
  if [ -z "$1" ]; then
    echo "Usage: sqs-queue-attributes <queue-name>"
    echo "  queue-name: name of the queue (e.g., weaver-worker-job-architecture-default-attributes)"
    return 1
  fi
  
  local queue_name="$1"
  local endpoint=$(sqs-endpoint)
  
  local queue_url=$(_sqs-resolve-queue-url "$queue_name")
  if [ $? -ne 0 ]; then
    return 1
  fi
  
  aws-local sqs get-queue-attributes \
    --queue-url "$queue_url" \
    --attribute-names All \
    --endpoint-url "$endpoint" \
    --output json
}
