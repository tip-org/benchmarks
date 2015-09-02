-- | A simple grammar with ambiguity
module Kaleidoscope where

import Tip.Prelude hiding (S)
import qualified Prelude

data Token
    = Butterfly
    | I
    | In
    | Me
    | Kaleidoscope
    | Saw
    | The

data S = S NP VP

data Case = Subj | Obj

linS :: S -> [Token]
linS (S np vp) = linNP Subj np ++ linVP vp

data NP = Pron1 | Det N | NP `NP_In` NP

linNP :: Case -> NP -> [Token]
linNP c Pron1           = case c of Subj -> [I]; Obj -> [Me]
linNP _ (Det n)         = [The] ++ linN n
linNP c (NP_In np1 np2) = linNP c np1 ++ [In] ++ linNP c np2

data N = N_Butterfly | N_Kaleidoscope

linN :: N -> [Token]
linN N_Butterfly    = [Butterfly]
linN N_Kaleidoscope = [Kaleidoscope]

data VP = See NP | VP `VP_In` NP

linVP :: VP -> [Token]
linVP (See np)      = [Saw]    ++         linNP Obj np
linVP (VP_In vp np) = linVP vp ++ [In] ++ linNP Obj np

sat_parse s = question (linS s === [I,Saw,The,Butterfly,In,The,Kaleidoscope])

sat_two_parses t1 t2 =
  question
    (linS t1 === [I,Saw,The,Butterfly,In,The,Kaleidoscope] .&&.
     linS t2 === [I,Saw,The,Butterfly,In,The,Kaleidoscope] .&&.
     t1 =/= t2)

sat_ambiguity s t1 t2 =
  question
    (t1 =/= t2 .&&. linS t1 === s .&&. linS t2 === s)

