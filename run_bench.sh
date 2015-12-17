ulimit -Sv 7000000
TIMEOUT=60
ghc --make Incremental.hs -o Incremental || exit
./Incremental - benchmarks $TIMEOUT hbmc -q -d 3
./Incremental - benchmarks $TIMEOUT hbmc -q -d 7
./Incremental - benchmarks $TIMEOUT hbmc -q -d 10
./Incremental - benchmarks $TIMEOUT hbmc -q -d 15
./Incremental - benchmarks $TIMEOUT hbmc -q -d 30
# ./Incremental Done. benchmarks-feat/sat $TIMEOUT _feat
# ./Incremental - benchmarks-lazysc/sat $TIMEOUT _lazysc
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q       --memo=False
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q       --merge=False
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q       --merge=False --memo=False
# ./Incremental unknown benchmarks-sk/sat $TIMEOUT cvc4-2015-08-18-x86_64-linux-opt --fmf-fun --dump-models
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q    -c
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q    -c --memo=False
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q    -c --merge=False
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q    -c --merge=False --memo=False
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q -l
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q -l    --memo=False
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q -l    --merge=False
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q -l    --merge=False --memo=False
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q -l -c
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q -l -c --memo=False
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q -l -c --merge=False
# ./Incremental - benchmarks/sat $TIMEOUT hbmc -q -l -c --merge=False --memo=False
