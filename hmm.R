# Part 2: HMM Core Algorithm.
# Replace the uniform placeholder with the forward algorithm.
# state: previous posterior, including Part 3's backpacker evidence.
# searched: sites searched last turn; if called again those searches failed.
# Exclude failed searches BEFORE transition prediction, not afterwards.
# On the first turn there is no Croc movement; start from the new-game prior.
# probs[[k]][i, ] = c(mean, sd), k = salinity, phosphate, nitrogen.
# Backpacker observations for the CURRENT turn are handled in routing.R.
updateProbabilities <- function(state, readings, edges, probs,
                                searched = integer(0), newGame = FALSE) {
  # TODO: build T[i,j] = P(next=j | current=i), including staying still.
  # TODO: remove failed-search mass, normalize, then predict with state %*% T.
  # TODO: combine three dnorm likelihoods (prefer log densities).
  # TODO: normalize and handle zero/non-finite likelihoods robustly.
  rep(1 / length(state), length(state))
}
