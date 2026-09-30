# Member A: replace this uniform placeholder with the forward algorithm.
# state: posterior from the previous turn; searched: previous turn's searches.
# On a continued game, searches failed: exclude them BEFORE prediction.
# On the first turn there is no Croc movement; reset the prior per game.
# probs[[k]][i, ] = c(mean, sd), k = salinity, phosphate, nitrogen.
updateProbabilities <- function(state, readings, positions, edges, probs,
                                searched = integer(0), newGame = FALSE) {
  # TODO: transition matrix with uniform adjacent-or-stay probabilities.
  # TODO: prediction, then three dnorm likelihoods (prefer log densities).
  # TODO: tourists >0 exclude sites; <0 reveal Croc; NA gives no new evidence.
  # TODO: normalize and handle zero/non-finite likelihoods robustly.
  rep(1 / length(state), length(state))
}
