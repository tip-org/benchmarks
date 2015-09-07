ulimit -Sv 7000000
TIMEOUT=1
ghc --make Incremental.hs -o Incremental
./Incremental Done. benchmarks-feat/sat $TIMEOUT runghc
mv runghc_ log_feat
./Incremental - benchmarks-lazysc/sat $TIMEOUT runghc
mv runghc_ log_lazysc
./Incremental - benchmarks/sat $TIMEOUT hbmc -q
./Incremental - benchmarks/sat $TIMEOUT hbmc -q       --memo=False
./Incremental - benchmarks/sat $TIMEOUT hbmc -q       --merge=False
./Incremental - benchmarks/sat $TIMEOUT hbmc -q       --merge=False --memo=False
./Incremental - benchmarks/sat $TIMEOUT hbmc -q    -c
./Incremental unknown benchmarks-cvc4-sk/sat $TIMEOUT cvc4-2015-08-18-x86_64-linux-opt --fmf-fun --dump-models
./Incremental - benchmarks/sat $TIMEOUT hbmc -q    -c --memo=False
./Incremental - benchmarks/sat $TIMEOUT hbmc -q    -c --merge=False
./Incremental - benchmarks/sat $TIMEOUT hbmc -q    -c --merge=False --memo=False
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q -l
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q -l    --memo=False
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q -l    --merge=False
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q -l    --merge=False --memo=False
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q -l -c
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q -l -c --memo=False
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q -l -c --merge=False
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q -l -c --merge=False --memo=False
