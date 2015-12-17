module Ferry where

import qualified Prelude
import Tip.Prelude

data Thing = Wolf | Rabbit | Cabbage

things = [Wolf,Rabbit,Cabbage]

Wolf `eats` Rabbit = True
Rabbit `eats` Cabbage = True
_ `eats` _ = False

type World = (Bool,[Thing],[Thing])

eq Wolf Wolf = True
eq Rabbit Rabbit = True
eq Cabbage Cabbage = True
eq _ _ = False

elm u (t:ts) = eq u t || elm u ts
elm _ []     = False

del u (t:ts)
  | eq u t    = ts
  | otherwise = t:del u ts
del _ [] = []

advance :: Maybe Thing -> World -> Maybe World
advance Nothing  (b,l,r)             = Just (not b,r,l)
advance (Just t) (b,l,r) | t `elm` l = Just (not b,t:r,del t l)
advance _ _                   = Nothing

advanceCheck :: Maybe Thing -> World -> Maybe World
advanceCheck t w = case advance t w of
                     Just w' | bad w' -> Nothing
                     mw'              -> mw'

bad :: World -> Bool
bad (_,_,r) = or [ a `eats` b | a <- r, b <- r ]

good :: Maybe World -> Bool
good (Just (True,l,_)) = and [ a `elm` l | a <- things ]
good _                 = False

go :: [Maybe Thing] -> World -> Maybe World
go []     w = Just w
go (t:ts) w = case advanceCheck t w of
                Just w' -> go ts w'
                Nothing -> Nothing

prop ts = question (good (go ts (False,[Wolf,Rabbit,Cabbage],[])))

