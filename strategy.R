# Member B: random legal move + search is only a runnable scaffold.
# Replace with shortest paths, target selection and two-action planning.
# Output searched lists actual searched sites, not move destinations alone.
chooseMoves <- function(state, ranger, edges) {
  options <- unique(c(ranger, edges[edges[, 1] == ranger, 2],
                      edges[edges[, 2] == ranger, 1]))
  destination <- options[sample.int(length(options), 1L)]
  list(moves = c(destination, 0L), searched = destination)
}
