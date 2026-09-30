# WheresCroc Project

Uppsala Assignment 2: Where's Croc

An R assignment repository for a team of three. The main function must be named
`myFunction`.

The current version is a **runnable project scaffold**: a uniform probability
placeholder followed by a random legal move and a search. The team still needs
to implement the HMM, routing, and performance improvements. This is not a
finished assignment solution.

## Files and responsibilities

The team is organized into the following three parts.

| Part | Files / branch | Responsibilities |
|---|---|---|
| 1. Game Strategy & Search Logic | `strategy.R` / `strategy` | Decide where to go and when to search using the probability map. Compare rushing to the most likely waterhole with searching high-probability sites along the route. |
| 2. HMM Core Algorithm | `hmm.R` / `hmm` | Implement transition matrices and the forward algorithm using `dnorm` sensor likelihoods. Apply previous failed searches before predicting movement. |
| 3. Routing & Edge Cases | `routing.R`, `myFunction.R` / `integration-test` | Implement shortest paths, handle backpacker deaths and surviving backpackers, manage `mem`, and integrate the controller. |
| Shared testing | `test.R`, `notes/results.md` | Check module integration and record performance. Each member verifies their own part. |

`integration-test` remains the branch name for Part 3 so existing clones continue
to work. `packages/` contains the original course package; develop the solution
in the R files at the repository root, without modifying the supplied archive.

### Module contracts

1. `prepareMemory(mem, n)` in `routing.R` resets per-game state and returns
   `list(mem, newGame)`.
2. `updateProbabilities(state, readings, edges, probs, searched, newGame)` in
   `hmm.R` returns the sensor-updated probability vector. Previous failed searches
   must be processed before the movement prediction.
3. `applyBackpackerEvidence(state, positions)` in `routing.R` applies current
   tourist observations. A newly eaten backpacker reveals Croc's exact location;
   living backpackers exclude their locations; `NA` adds no evidence.
4. `chooseMoves(state, ranger, edges)` in `strategy.R` returns two actions and
   the sites searched, as `list(moves, searched)`.
5. `myFunction` connects these steps, stores state and searches in `mem`, and
   returns the updated `moveInfo`.

Routing helpers are `getNeighbours(waterhole, edges)` and
`shortestPath(start, target, edges)`. The latter must return the complete path,
including both endpoints, or `integer(0)` if unreachable. Only the same-location
case is implemented now; other calls deliberately raise a TODO error until
Part 3 implements BFS. The current random strategy does not call this placeholder.

Memory reset and backpacker evidence are implemented as basic integration
helpers. HMM filtering, failed-search updates, general pathfinding, route caching,
and probability-based strategy remain team TODOs.

## Setup and running

Use R and the course-provided `WheresCroc_1.2.2.tar.gz` package. Do not use
additional third-party packages for the algorithm.

The course package is in `packages/WheresCroc_1.2.2.tar.gz`. See
`materials/naming-conventions.pdf` for function naming requirements and
`materials/README.md` for material details.

Run the following in R from the repository root:

```r
dir.create(".Rlib", showWarnings = FALSE)
.libPaths(c(normalizePath(".Rlib"), .libPaths()))
install.packages("packages/WheresCroc_1.2.2.tar.gz", repos = NULL,
                 type = "source", lib = ".Rlib")
source("routing.R")
source("hmm.R")
source("strategy.R")
source("myFunction.R")
WheresCroc::runWheresCroc(myFunction, doPlot = FALSE, pause = 0)
```

Run a quick check (10 games) or a full-size evaluation (500 games) from a
macOS/Linux terminal:

```sh
R_LIBS_USER=.Rlib Rscript test.R 10 21
R_LIBS_USER=.Rlib Rscript test.R 500 21
```

The package documentation reports a par mean of 5.444 and an SD of approximately
3.853 for 500 games with seed 21. The target runtime is under 30 seconds on the
evaluation machine. Although `testWC` defaults to a 300-second limit, this project
explicitly sets it to 30 seconds. Assessment uses a different seed, so do not tune
only for seed 21.

## Verified function interface

```r
myFunction <- function(moveInfo, readings, positions, edges, probs)
```

- Return the updated `moveInfo`, with exactly two actions in `moves`.
- `0` searches the current waterhole. A positive number moves to an adjacent
  waterhole or stays at the current one. Croc moves between turns, not between
  the ranger's two actions.
- `readings` contains salinity, phosphate, and nitrogen measurements. `probs`
  contains the corresponding three matrices of means and standard deviations.
- `positions[1:2]` describes the tourists: a positive value is a living tourist's
  location, a negative value marks where a tourist was eaten this turn, and `NA`
  means the tourist was eaten earlier. `positions[3]` is the ranger's location.
- `edges` contains bidirectional connections, with each edge listed once.
- Reset per-game state when `mem$status` is 0 (initial setup) or 1 (the previous
  game ended). This controller then sets it to 2. Graph and routing data can be
  cached across games, but `probs` is generated again for each game.
- `updateProbabilities` returns a normalized probability vector. `chooseMoves`
  returns `list(moves = ..., searched = ...)`. If the controller is called again
  in the same game, the previous searches failed: exclude those locations before
  predicting Croc's movement. Do not apply a movement prediction on the first
  turn of a new game.

## Team workflow

The repository is **Public**, as confirmed by the requesting team member.
Code and uploaded course materials are publicly visible. The repository owner
can invite teammates through GitHub Settings → Collaborators using their GitHub
usernames. Do not commit credentials or personal information. Copyright in the
course materials remains with the original authors.

```sh
git clone https://github.com/petermarket/WheresCrocProject.git
cd WheresCrocProject
git switch strategy   # Part 2: hmm; Part 3: integration-test
git pull --ff-only
# Edit the files assigned to you.
git add strategy.R
git commit -m "Implement routing strategy"
git push -u origin strategy
```

Open a pull request to `main` on GitHub. Another team member reviews the changes,
and the Part 3 owner runs the integration tests before merging. To update a working branch, run
`git fetch origin`, then `git merge origin/main`.

Agree on module interface changes with the team before editing another member's
files. Branch protection has not been configured.

## Final single-file submission

Keep the four implementation files separate during development, then combine
them into a standalone R script for submission. The submitted script must not
depend on local `source()` paths. Run this from the repository root:

```r
dir.create("dist", showWarnings = FALSE)
files <- c("routing.R", "hmm.R", "strategy.R", "myFunction.R")
writeLines(unlist(lapply(files, function(f) c(readLines(f), ""))),
           "dist/myFunction.R")
```

Before submission, start a clean R session, load only `dist/myFunction.R` as the
solution, and run the course tests. Follow the instructor's final submission and
naming requirements. All members must join a Where's Croc group on the course
platform.
