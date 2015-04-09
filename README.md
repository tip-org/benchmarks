# TIP: Tons of Inductive Problems

This repository contains benchmarks and challenge problems for inductive
theorem provers. The benchmarks are written in a superset of SMTLIB
under the `benchmarks/` directory and its subdirectories.  Each file
contains exactly one problem.

The `original` directory contains the original Haskell source
files for many of the problems.

The benchmarks are also available to download in Why3 format, and a
CVC4-compatible version of SMTLIB:

* Why3: http://tip-org.github.io/tip-benchmarks-0.1-why3.tar.gz
* CVC4: http://tip-org.github.io/tip-benchmarks-0.1-cvc4.tar.gz

## Generating problems yourself

After installing the
[TIP tools](http://github.com/tip-org/tools) you can generate the
whole problem set in TIP, Why3 and CVC4 format yourself from the
Haskell sources. To do this run `create.sh`. This may be useful if you
want to add your own problems.

## Contributing to the TIP benchmarks

Contributions are most encouraged! Any inductive problem,
big or small, simple or difficult is welcome.

The simplest method to add new benchmarks is via a github
[pull request](https://help.github.com/articles/using-pull-requests/)
to this git repo.

You are also free to email the maintainers with new problems (or questions):

* Dan Rosén [`danr@chalmers.se`](mailto:danr@chalmers.se)
* Moa Johansson [`jomoa@chalmers.se`](mailto:jomoa@chalmers.se)
* Nick Smallbone [`nicsma@chalmers.se`](mailto:nicsma@chalmers.se)

