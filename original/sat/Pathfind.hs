module Pathfind where

import qualified Prelude
import Tip.Prelude

data Dir = U | D | L | R

type Pos = (Nat,Nat)

index2D :: [[a]] -> Pos -> Maybe a
index2D xss (x,y) =
  case index xss y of
    Just xs -> index xs x
    Nothing -> Nothing

p :: Nat -> Nat
p (S n) = n
p Z     = Z

off :: Dir -> Pos -> Pos
off U (x,y) = (x,p y)
off D (x,y) = (x,S y)
off L (x,y) = (p x,y)
off R (x,y) = (S x,y)

data Tile = Wall | Floor | Treasure | Key | Door

__ = Floor
xx = Wall
tt = Treasure
kk = Key
dd = Door

type Map = [[Tile]]

smallMap =
  [ [ __, __, __, xx, tt, __, __, __, __, xx, kk ]
  , [ xx, xx, __, xx, xx, xx, xx, xx, __, xx, __ ]
  , [ __, __, __, xx, __, __, xx, __, __, xx, __ ]
  , [ __, xx, xx, xx, __, xx, xx, dd, xx, xx, __ ]
  , [ __, __, __, __, __, __, __, __, __, __, __ ]
  ]

mediumMap =
  [ [ __, __, __, __, __, xx, kk, xx, __, __, __ ]
  , [ xx, xx, __, xx, __, xx, __, xx, __, xx, __ ]
  , [ __, __, __, xx, __, xx, __, __, __, xx, __ ]
  , [ __, xx, xx, xx, __, xx, xx, xx, xx, xx, __ ]
  , [ __, xx, __, xx, __, __, __, __, __, __, __ ]
  , [ __, xx, __, xx, xx, xx, xx, xx, xx, xx, __ ]
  , [ __, xx, __, __, __, __, __, __, __, xx, __ ]
  , [ xx, xx, __, xx, dd, xx, xx, xx, __, xx, __ ]
  , [ __, __, __, xx, __, __, __, xx, __, xx, __ ]
  , [ __, xx, xx, xx, xx, xx, __, xx, xx, xx, __ ]
  , [ __, __, __, __, tt, xx, __, __, __, __, __ ]
  ]

bigMap =
  [ [ __, __, __, __, __, xx, __, __, __, __, __, __, __, xx, __, __, __, __, __ ]
  , [ __, xx, xx, xx, __, xx, __, xx, xx, xx, __, xx, xx, xx, __, xx, xx, xx, __ ]
  , [ __, __, __, xx, __, __, __, xx, __, __, __, xx, __, __, __, __, __, xx, __ ]
  , [ __, xx, xx, xx, xx, xx, __, xx, __, xx, xx, xx, __, xx, xx, xx, xx, xx, __ ]
  , [ __, xx, __, __, __, xx, __, xx, __, __, __, __, __, __, __, xx, __, __, __ ]
  , [ __, xx, __, xx, __, xx, xx, xx, __, xx, xx, xx, xx, xx, xx, xx, __, xx, __ ]
  , [ __, xx, __, xx, __, __, __, xx, __, xx, __, __, __, __, __, __, __, xx, __ ]
  , [ xx, xx, __, xx, xx, xx, __, xx, xx, xx, __, xx, xx, xx, xx, xx, xx, xx, __ ]
  , [ __, __, __, xx, __, xx, __, __, __, __, __, xx, __, __, __, __, tt, xx, __ ]
  , [ __, xx, xx, xx, __, xx, xx, xx, xx, xx, xx, xx, xx, xx, __, xx, xx, xx, __ ]
  , [ __, xx, __, __, __, __, __, __, __, xx, __, __, __, __, __, xx, __, __, __ ]
  , [ xx, xx, __, xx, xx, xx, xx, xx, __, xx, __, xx, xx, xx, xx, xx, __, xx, xx ]
  , [ __, __, __, __, __, xx, __, xx, __, xx, __, __, __, xx, __, __, __, xx, __ ]
  , [ xx, xx, xx, xx, __, xx, __, xx, __, xx, xx, xx, __, xx, __, xx, xx, xx, __ ]
  , [ __, __, __, __, __, xx, __, xx, __, xx, __, __, __, xx, __, xx, __, __, __ ]
  , [ __, xx, xx, xx, xx, xx, __, xx, __, xx, __, xx, __, xx, __, xx, xx, xx, __ ]
  , [ __, xx, __, __, __, xx, __, __, __, __, __, xx, __, xx, __, xx, __, __, __ ]
  , [ __, xx, __, xx, __, xx, xx, xx, xx, xx, xx, xx, xx, xx, __, xx, __, xx, __ ]
  , [ __, __, __, xx, __, __, __, __, __, __, __, __, __, __, __, __, __, xx, __ ]
  ]

walkKeychain :: Map -> Bool -> [Dir] -> Pos -> Maybe Pos
walkKeychain m key []     p = Just p
walkKeychain m key (d:ds) p =
  let p' = off d p
  in case index2D m p' of
    Just Door | key -> walkKeychain m key  ds p'
    Just Key        -> walkKeychain m True ds p'
    Just Floor      -> walkKeychain m key  ds p'
    Just Treasure   -> walkKeychain m key  ds p'
    _               -> Nothing

walk :: Map -> [Dir] -> Pos -> Maybe Pos
walk m []     p = Just p
walk m (d:ds) p =
  let p' = off d p
  in case index2D m p' of
    Just Door     -> walk m ds p'
    Just Key      -> walk m ds p'
    Just Floor    -> walk m ds p'
    Just Treasure -> walk m ds p'
    _             -> Nothing

goal :: Map -> Maybe Pos -> Bool
goal m Nothing = False
goal m (Just p) =
  case index2D m p of
    Just Treasure -> True
    _             -> False

target_small ds = question (goal smallMap (walkKeychain smallMap False ds (Z,Z)))

target_medium ds = question (goal mediumMap (walkKeychain mediumMap False ds (Z,Z)))

target_big ds = question (goal bigMap (walk bigMap ds (Z,Z)))
