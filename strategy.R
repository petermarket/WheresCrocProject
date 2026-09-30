# Part 1: Game Strategy & Search Logic.
# Consumes the probability map AFTER backpacker evidence has been applied.
# Owns target selection and when to move/search, not pathfinding itself.
# TODO: compare rushing to which.max(state) with searching likely sites en route.
# TODO: use Part 3's shortestPath once implemented; plan exactly two actions.
# Output searched lists actual searched sites, not move destinations alone.
# The random move + search below is only a runnable scaffold.
chooseMoves <- function(state, ranger, edges) {
  options <- unique(c(ranger, getNeighbours(ranger, edges)))
  destination <- options[sample.int(length(options), 1L)]
  list(moves = c(destination, 0L), searched = destination)
}
