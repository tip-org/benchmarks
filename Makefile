# mkdir -p benchmarks-{sk,feat,lazysc}/

files_sat  = $(wildcard benchmarks/**/*smt2)

lazy_hs = $(subst benchmarks,benchmarks-lazysc,$(files_sat:.smt2=.hs))
feat_hs = $(subst benchmarks,benchmarks-feat,$(files_sat:.smt2=.hs))

# min_tff = $(subst benchmarks,benchmarks-min,$(files_sat:.smt2=.tff))
# min_targets = $(min_tff:.tff=.p)

hs = $(lazy_hs) $(feat_hs)

files_cvc4 = $(wildcard benchmarks-cvc4/*smt2)
sk_targets = $(subst cvc4,sk,$(files_cvc4))

targets = $(hs:.hs=.bin) $(sk_targets)

%.bin: %.hs
	ghc --make $< -o $@

# benchmarks-min/%.tff: benchmarks/%.smt2
# 	tip $< --bool-op-to-if --skolemise-conjecture --tff-min > $@

%.p: %.tff
	jukebox fof $< --output $@

benchmarks-sk/%: benchmarks-cvc4/%
	mkdir -p $$(dirname $@)
	tip $< --make-conjecture 0 --skolemise-conjecture --negate-conjecture > $@

benchmarks-lazysc/%.hs: benchmarks/%.smt2
	mkdir -p $$(dirname $@)
	tip $< --haskell-lazysc-depth > $@

benchmarks-smten/%.hs: benchmarks/%.smt2
	mkdir -p $$(dirname $@)
	tip $< --haskell-lazysc-smten > $@

benchmarks-feat/%.hs: benchmarks/%.smt2
	mkdir -p $$(dirname $@)
	tip $< --haskell-feat > $@

# min: $(min_targets)

all: $(targets)

.SECONDARY: $(hs) benchmarks-sk/sat benchmarks-feat/sat benchmarks-lazysc/sat

clean:
	rm -rf benchmarks-sk/*
	rm -rf benchmarks-feat/*
	rm -rf benchmarks-lazysc/*

.PHONY: all clean dirs
