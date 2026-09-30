chooseMoves <- function(state, ranger, edges) {
  # 1. Find the most likely waterhole for Croc
  target <- which.max(state)
  
  # 2. Get the shortest path to the target (using Part 3's routing)
  path <- shortestPath(ranger, target, edges)
  
  # 3. Plan exactly two actions based on distance
  if (length(path) == 1) {
    # Already there: search twice
    moves <- c(0L, 0L)
    searched <- c(ranger, ranger)
  } else if (length(path) == 2) {
    # One step away: move there, then search
    moves <- c(path[2], 0L)
    searched <- c(path[2])
  } else {
    # Two or more steps away: take two steps toward target
    moves <- c(path[2], path[3])
    searched <- integer(0)
  }
  
  list(moves = moves, searched = searched)
}
