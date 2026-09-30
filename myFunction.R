# Main controller: source hmm.R and strategy.R before this file.
myFunction <- function(moveInfo, readings, positions, edges, probs) {
  mem <- moveInfo$mem
  newGame <- is.null(mem$status) || mem$status %in% c(0, 1)
  if (newGame) {
    mem$state <- rep(1 / nrow(probs[[1]]), nrow(probs[[1]]))
    mem$searched <- integer(0)
  }
  mem$state <- updateProbabilities(mem$state, readings, positions,
                                   edges, probs, mem$searched, newGame)
  plan <- chooseMoves(mem$state, positions[3], edges)
  moveInfo$moves <- plan$moves
  mem$searched <- plan$searched
  # The engine sets status=1 after a win; 2 denotes an ongoing game.
  mem$status <- 2L
  moveInfo$mem <- mem
  moveInfo
}
