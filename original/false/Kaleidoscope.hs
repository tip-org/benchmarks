module Kaleidoscope where

import Tip

data Token
    = Butterfly
    | I
    | In
    | Me
    | Kaleidoscope
    | Saw
    | The
  deriving (Show,Eq)

data S = S NP VP
  deriving (Show,Eq)

data Case = Subj | Obj

linS :: S -> [Token]
linS (S np vp) = linNP Subj np ++ linVP vp

data NP = Pron1 | Det N | NP `NP_In` NP
  deriving (Show,Eq)

linNP :: Case -> NP -> [Token]
linNP c Pron1           = case c of Subj -> [I]; Obj -> [Me]
linNP _ (Det n)         = [The] ++ linN n
linNP c (NP_In np1 np2) = linNP c np1 ++ [In] ++ linNP c np2

data N = N_Butterfly | N_Kaleidoscope
  deriving (Show,Eq)

linN :: N -> [Token]
linN N_Butterfly    = [Butterfly]
linN N_Kaleidoscope = [Kaleidoscope]

data VP = See NP | VP `VP_In` NP
  deriving (Show,Eq)

linVP :: VP -> [Token]
linVP (See np)      = [Saw]    ++         linNP Obj np
linVP (VP_In vp np) = linVP vp ++ [In] ++ linNP Obj np

-- examples --

ex3 s t1 t2 = s === linS t1 ==> s === linS t2 ==> t1 === t2

--
-- ex1 s = linS s === [I,Saw,The,Butterfly,In,The,Kaleidoscope] ==> True === False
--
-- ex2 t1 t2 =
--         linS t1 === [I,Saw,The,Butterfly,In,The,Kaleidoscope]
--     ==> linS t2 === [I,Saw,The,Butterfly,In,The,Kaleidoscope]
--     ==> t1 === t2
--

-- lscex1 s = neg (lift (linS s == [I,Saw,The,Butterfly,In,The,Kaleidoscope]))
--
-- lscex2 t1 t2 =
--            lift (linS t1 == [I,Saw,The,Butterfly,In,The,Kaleidoscope])
--       *=>* lift (linS t2 == [I,Saw,The,Butterfly,In,The,Kaleidoscope])
--       *=>* lift (t1 == t2)
--
-- lscex3 t1 t2 = lift (linS t1 == linS t2) *=>* lift (t1 == t2)

-- append --

-- showing --

-- instance Show (S,S) where
--   show (s1,s2) = show s1 ++ "\n" ++ show s2 ++ "\n" ++ show (linS s1)

