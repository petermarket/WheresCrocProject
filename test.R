# Run from the repository root: Rscript test.R [number-of-games] [seed]
source("routing.R")
source("hmm.R")
source("strategy.R")
source("myFunction.R")
if (!requireNamespace("WheresCroc", quietly = TRUE)) {
  stop("Install the course WheresCroc_1.2.2.tar.gz package first; see README.md.")
}
args <- commandArgs(trailingOnly = TRUE)
n <- if (length(args) >= 1L) as.integer(args[1]) else 10L
seed <- if (length(args) >= 2L) as.integer(args[2]) else 21L
stopifnot(!is.na(n), n > 0L, n <= 25000L, !is.na(seed))
# Treat illegal moves as failures instead of silently continuing.
options(warn = 2)
elapsed <- system.time({
  scores <- WheresCroc::testWC(myFunction, n = n, seed = seed,
                             returnVec = TRUE, verbose = 1, timeLimit = 30)
})[["elapsed"]]
stopifnot(length(scores) == n, all(is.finite(scores)), all(scores >= 1))
cat(sprintf("\nVerified %d games; seed=%d; mean=%.3f; sd=%.3f; elapsed=%.3fs\n",
            n, seed, mean(scores), sd(scores), elapsed))
