module Palin where

import Tip

data T = A | B
 deriving (Eq,Ord,Show)

data C = C P P
 deriving (Eq,Ord,Show)

data P = AP P | BP P | PA | PB | PE
 deriving (Eq,Ord,Show)

linC :: C -> [T]
linC (C p q) = linP p ++ linP q

linP :: P -> [T]
linP (AP p) = [A] ++ linP p ++ [A]
linP (BP p) = [B] ++ linP p ++ [B]
linP PA     = [A]
linP PB     = [B]
linP PE     = []

unambig u v = linC u === linC v ==> u === v

