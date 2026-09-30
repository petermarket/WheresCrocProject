chooseMoves <- function(state, ranger, edges) {
  target <- which.max(state)
  
  path <- shortestPath(ranger, target, edges)
  
  if (length(path) == 1) {
    moves <- c(0L, 0L)
    searched <- c(ranger, ranger)
  } else if (length(path) == 2) {
    moves <- c(path[2], 0L)
    searched <- c(path[2])
  } else {
    moves <- c(path[2], path[3])
    searched <- integer(0)
  }
  
  list(moves = moves, searched = searched)
}
