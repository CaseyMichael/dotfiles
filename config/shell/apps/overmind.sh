alias o=overmind
alias ora='overmind restart' # restarts all processes

alias ord='overmind restart dazzle-frontend'
alias orw='overmind restart weaver'

# overmind
# export OVERMIND_SOCKET=$HOME/.overmind.sock
# export OVERMIND_TMUX=1
# export OVERMIND_CONFIG=$HOME/.overmind.tmux.conf

# kill all overmind processes
function overmind-kill-all() {
  pgrep -f overmind | while read -r pid; do
    pkill -P "$pid" 2>/dev/null
    kill "$pid" 2>/dev/null
  done
}
