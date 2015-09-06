mkdir -p benchmarks-cvc4-sk/sat
cd benchmarks-cvc4
for i in sat/*; do
  tip $i --make-conjecture 0 --skolemise-conjecture --negate-conjecture > ../benchmarks-cvc4-sk/$i
done
