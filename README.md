# WheresCroc Project

Uppsala Assignment 2: Where's Croc

An R assignment repository for a team of three. The main function must be named
`myFunction`.

The current version is a **runnable project scaffold**: a uniform probability
placeholder followed by a random legal move and a search. The team still needs
to implement the HMM, routing, and performance improvements. This is not a
finished assignment solution.

## Files and responsibilities

| File / branch | Owner | Responsibilities |
|---|---|---|
| `hmm.R` / `hmm` | Member A | Transition model, forward algorithm, sensor and tourist evidence, probability normalization |
| `strategy.R` / `strategy` | Member B | Shortest paths, target selection, and planning two actions per turn |
| `myFunction.R`, `test.R`, `notes/results.md` / `integration-test` | Member C | State management, integration, testing, and experiment records |
| `main` | Whole team | Shared version checked to run successfully |

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
git switch strategy   # Member A: hmm; Member C: integration-test
git pull --ff-only
# Edit the files assigned to you.
git add strategy.R
git commit -m "Implement routing strategy"
git push -u origin strategy
```

Open a pull request to `main` on GitHub. Another team member reviews the changes,
and Member C runs the tests before merging. To update a working branch, run
`git fetch origin`, then `git merge origin/main`.

Agree on module interface changes with the team before editing another member's
files. Branch protection has not been configured.

## Final single-file submission

Keep the three implementation files separate during development, then combine
them into a standalone R script for submission. The submitted script must not
depend on local `source()` paths. Run this from the repository root:

```r
dir.create("dist", showWarnings = FALSE)
files <- c("hmm.R", "strategy.R", "myFunction.R")
writeLines(unlist(lapply(files, function(f) c(readLines(f), ""))),
           "dist/myFunction.R")
```

Before submission, start a clean R session, load only `dist/myFunction.R` as the
solution, and run the course tests. Follow the instructor's final submission and
naming requirements. All members must join a Where's Croc group on the course
platform.
