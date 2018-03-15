all: $(patsubst %.hs, %.tip, $(wildcard *.hs))

%.tip: %.hs
	tip-ghc $< > $@ || rm $@
