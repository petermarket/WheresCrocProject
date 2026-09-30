# Shared entry point, integrated by Part 3.
# Load routing.R, hmm.R, and strategy.R before this file.
myFunction <- function(moveInfo, readings, positions, edges, probs) {
  context <- prepareMemory(moveInfo$mem, nrow(probs[[1]]))
  mem <- context$mem
  mem$state <- updateProbabilities(mem$state, readings, edges, probs,
                                   mem$searched, context$newGame)
  mem$state <- applyBackpackerEvidence(mem$state, positions)
  plan <- chooseMoves(mem$state, positions[3], edges)
  moveInfo$moves <- plan$moves
  mem$searched <- plan$searched
  # The engine sets status=1 after a win; 2 denotes an ongoing game.
  mem$status <- 2L
  moveInfo$mem <- mem
  moveInfo
}
