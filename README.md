# TIP: Tons of Inductive Problems

This repository contains benchmarks and challenge problems for inductive
theorem provers. The benchmarks are written in a superset of SMTLIB
under the [`benchmarks/`](https://github.com/tip-org/benchmarks/tree/master/benchmarks)
directory and its subdirectories.  Each file contains exactly one problem.

The `original` directory contains the original Haskell source
files for many of the problems.

The benchmarks are also available to download in Why3 format, and a
CVC4-compatible version of SMTLIB:

* Why3: http://tip-org.github.io/tip-benchmarks-0.2-why3.tar.gz
* CVC4: http://tip-org.github.io/tip-benchmarks-0.2-cvc4.tar.gz
* TIP format: http://tip-org.github.io/tip-benchmarks-0.2.tar.gz

## Generating problems yourself

After installing the
[TIP tools](http://github.com/tip-org/tools) you can generate the
whole problem set in TIP, Why3 and CVC4 format yourself from the
Haskell sources. To do this run [`omake`](http://omake.metaprl.org/index.html).
This may be useful if you want to add your own problems,
but it is not a requirement that they come from a Haskell source file.

## Contributing to the TIP benchmarks

Contributions are most encouraged! Any inductive problem,
big or small, simple or difficult is welcome.

The simplest method to add new benchmarks is via a github
[pull request](https://help.github.com/articles/using-pull-requests/)
to this git repo.

We're also looking for non-theorem benchmarks to evaluate
tools that find counterexamples to false properties.
They can be expressed in the same format, but should be
under another directory, to be able to keep them apart.

You are also free to email the maintainers with new problems (or questions):

* Dan Rosén [`danr@chalmers.se`](mailto:danr@chalmers.se)
* Moa Johansson [`jomoa@chalmers.se`](mailto:jomoa@chalmers.se)
* Nick Smallbone [`nicsma@chalmers.se`](mailto:nicsma@chalmers.se)

<!--

## Known nuances

* The tree sort exists in two versions, one sorting Ints, and the other sorting Nats.
  Dan suggests to write a transformer from theories which use only the ordering
  functions from Int into other orderables, such as Nat.

* There are heap benchmarks in two versions, where the difference is whether
  the toList function is structurally recursive. Like the tree sort version,
  they also differ in whether they sort Nats or Ints.

-->
