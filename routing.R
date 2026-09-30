# Part 3: Routing & Edge Cases.
# Owns graph navigation, backpacker evidence, and per-game memory.
getNeighbours <- function(waterhole, edges) {
  unique(c(edges[edges[, 1] == waterhole, 2],
           edges[edges[, 2] == waterhole, 1]))
}

# Contract: return the full path including start and target.
# For start == target return start; for an unreachable target return integer(0).
# This scaffold deliberately leaves BFS and route caching to Part 3.
shortestPath <- function(start, target, edges) {
  if (start == target) return(as.integer(start))
  stop("TODO (Part 3): implement shortestPath using BFS before using it in strategy.")
}

prepareMemory <- function(mem, n) {
  newGame <- is.null(mem$status) || mem$status %in% c(0, 1)
  if (newGame) {
    mem$state <- rep(1 / n, n)
    mem$searched <- integer(0)
  }
  # TODO: cache routes and the Part 2 transition matrix across games.
  # Do not cache sensor distributions: probs changes between games.
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
