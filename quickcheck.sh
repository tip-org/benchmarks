for i in benchmarks/**/*.smt2; do
    echo -n "$i "
    tip-parser $i hs > A.hs
    ghc --make A.hs -main-is A >/dev/null
    timeout 5 ./A 1>/tmp/o 2>/tmp/e || (echo -n $? && head -c 100 /tmp/o && head -c 100 /tmp/e)
    killall A >/dev/null 2>/dev/null
    echo;
done
