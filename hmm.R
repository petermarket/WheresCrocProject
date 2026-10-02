# Part 2: HMM Core Algorithm.
# Forward algorithm for Croc's hidden location.
#
# Notation follows the course HMM material (exercise 1 / lecture 7 slides).
#
# Notation -> variable in this file:
#   A[i, j]   -> transition   (built by buildTransition)
#   emission  -> loglik       (log density; densities multiply = loglik sums)
#   alpha_t   -> state        (forward vector, normalised each turn)
#
# Forward equations (alpha_t is the value carried in `state`):
#   alpha_1 = prior * emission                     (first turn: no transition)
#   alpha_t = (alpha_{t-1} %*% A) * emission       (predict, then update)
#
# Where:
#   A[i, j]   = P(hidden state j at time t | hidden state i at time t-1)
#   emission  = P(reading at time t | Croc is at waterhole i), the product of
#               the three normal densities (salinity, phosphate, nitrogen)
#   alpha     = forward probability vector; normalising each turn only rescales
#               it, so the relative probabilities are unchanged.
#
# state: previous posterior, including Part 3's backpacker evidence.
# searched: sites searched last turn; if called again those searches failed.
# Exclude failed searches BEFORE transition prediction, not afterwards.
# On the first turn there is no Croc movement; start from the new-game prior.
# probs[[k]][i, ] = c(mean, sd), k = salinity, phosphate, nitrogen.
# Backpacker observations for the CURRENT turn are handled in routing.R.

# Transition matrix A[i, j] -> transition.
#   A[i, j] = P(Croc moves to j next turn | Croc at i now).
# Croc moves uniformly to any neighbour or stays still, so every option
# (neighbours plus the current hole) is equally likely. Vectorised construction
# keeps this cheap enough to rebuild on every call.
buildTransition <- function(edges, n) {
  degree  <- tabulate(c(edges[, 1], edges[, 2]), nbins = n)
  options <- degree + 1L                       # neighbours plus staying still
  transition <- matrix(0, n, n)
  transition[cbind(edges[, 1], edges[, 2])] <- 1 / options[edges[, 1]]
  transition[cbind(edges[, 2], edges[, 1])] <- 1 / options[edges[, 2]]
  diag(transition) <- 1 / options
  transition
}

# Normalise a probability vector, falling back to uniform if it is degenerate
# (all zero or non-finite), which can happen with contradictory evidence.
normaliseVec <- function(v) {
  total <- sum(v)
  if (!is.finite(total) || total <= 0) rep(1 / length(v), length(v)) else v / total
}

updateProbabilities <- function(state, readings, edges, probs,
                                searched = integer(0), newGame = FALSE) {
  n <- nrow(probs[[1]])

  # 1. Base case: alpha_1 = prior * emission, carried in state. A new game
  #    starts from the uniform prior (pi). A length mismatch means the stored
  #    state is not usable, so treat it like a fresh game too.
  if (newGame || !is.numeric(state) || length(state) != n) {
    state <- rep(1 / n, n)
    newGame <- TRUE
  }

  # 2. Apply failed-search evidence to alpha_t (state). Exclude last turn's
  #    searches before predicting movement. A failed search proves Croc was not
  #    there last turn; Croc may still move back in, which is why this must
  #    precede the transition.
  if (!newGame && length(searched)) {
    state[as.integer(searched)] <- 0
    state <- normaliseVec(state)
  }

  # 3. Predict: alpha_{t-1} %*% A, with A[i, j] -> transition. Skipped on the
  #    first turn of a game because Croc has not moved yet.
  if (!newGame) state <- as.vector(state %*% buildTransition(edges, n))

  # 4. Update: alpha_t = alpha_{t-1} * emission, with emission -> loglik.
  #    emission is the product of the three normal densities; summing their log
  #    densities (loglik) avoids underflow.
  loglik <- numeric(n)
  for (k in seq_along(readings)) {
    loglik <- loglik + dnorm(readings[k], probs[[k]][, 1], probs[[k]][, 2],
                             log = TRUE)
  }
  if (any(is.finite(loglik))) {
    state <- state * exp(loglik - max(loglik[is.finite(loglik)]))
  }

  # 5. Normalise alpha_t (state) into a proper posterior for the next turn.
  normaliseVec(state)
}
