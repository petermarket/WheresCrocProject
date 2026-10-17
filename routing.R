# Part 3: Routing & Edge Cases.
# Owns graph navigation, backpacker evidence, and per-game memory.
getNeighbours <- function(waterhole, edges) {
  unique(c(edges[edges[, 1] == waterhole, 2],
           edges[edges[, 2] == waterhole, 1]))
}

# Stop BFS when the target is discovered; only reconstruct the requested path.
shortestPath <- function(start, target, edges) {
  parent <- rep(NA_integer_, max(c(start, target, edges)))
  parent[start] <- start
  queue <- start
  head <- 1L
  while (head <= length(queue) && is.na(parent[target])) {
    current <- queue[head]
    head <- head + 1L
    for (nextHole in getNeighbours(current, edges)) {
      if (is.na(parent[nextHole])) {
        parent[nextHole] <- current
        queue <- c(queue, nextHole)
        if (nextHole == target) break
      }
    }
  }
  if (is.na(parent[target])) return(integer(0))
  path <- as.integer(target)
  while (path[1] != start) path <- c(parent[path[1]], path)
  path
}

prepareMemory <- function(mem, n) {
  newGame <- is.null(mem$status) || mem$status %in% c(0, 1)
  if (newGame) {
    mem$state <- rep(1 / n, n)
    mem$searched <- integer(0)
  }
  list(mem = mem, newGame = newGame)
}

applyBackpackerEvidence <- function(state, positions) {
  tourists <- positions[1:2]
  eaten <- -tourists[!is.na(tourists) & tourists < 0]
  if (length(eaten)) {
    state[] <- 0
    state[eaten[1]] <- 1
    return(state)
  }
  alive <- tourists[!is.na(tourists) & tourists > 0]
  state[alive] <- 0
  # Recover from an impossible prior without restoring excluded locations.
  if (!is.finite(sum(state)) || sum(state) <= 0) {
    state[] <- 1
    state[alive] <- 0
  }
  state / sum(state)
}
