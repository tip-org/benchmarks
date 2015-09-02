cpp Untyped.hs -D USE_K -D USE_S -D USE_B -D USE_C -D USE_W > UntypedKSBCW.hs
cpp Untyped.hs -D USE_K -D USE_S -D USE_B -D USE_C          > UntypedKSBC.hs
cpp Untyped.hs -D USE_K -D USE_S -D USE_B                   > UntypedKSB.hs
cpp Untyped.hs -D USE_K -D USE_S                            > UntypedKS.hs
cpp Untyped.hs -D USE_K          -D USE_B -D USE_C -D USE_W > UntypedKBCW.hs
cpp Untyped.hs                   -D USE_B -D USE_C -D USE_W > UntypedBCW.hs
cpp Untyped.hs          -D USE_S -D USE_B -D USE_C -D USE_W > UntypedSBCW.hs
cpp Untyped.hs          -D USE_S -D USE_B                   > UntypedSB.hs
