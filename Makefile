# mkdir -p benchmarks-{sk,feat,lazysc}/sat/

files_sat  = $(wildcard benchmarks/sat/*smt2)

lazy_hs = $(subst benchmarks,benchmarks-lazysc,$(files_sat:.smt2=.hs))
feat_hs = $(subst benchmarks,benchmarks-feat,$(files_sat:.smt2=.hs))

hs = $(lazy_hs) $(feat_hs)

files_cvc4 = $(wildcard benchmarks-cvc4/sat/*smt2)
sk_targets = $(subst cvc4,sk,$(files_cvc4))

targets = $(hs:.hs=.bin) $(sk_targets)

%.bin: %.hs
	ghc --make $< -main-is A -o $@

benchmarks-sk/sat/%: benchmarks-cvc4/sat/%
	tip $< --make-conjecture 0 --skolemise-conjecture --negate-conjecture > $@

benchmarks-lazysc/sat/%.hs: benchmarks/sat/%.smt2
	tip $< --haskell-lazysc > $@

benchmarks-feat/sat/%.hs: benchmarks/sat/%.smt2
	tip $< --haskell-feat > $@

all: $(targets)

.SECONDARY: $(hs) benchmarks-sk/sat benchmarks-feat/sat benchmarks-lazysc/sat

clean:
	rm -rf benchmarks-sk/sat/*
	rm -rf benchmarks-feat/sat/*
	rm -rf benchmarks-lazysc/sat/*

.PHONY: all clean dirs
