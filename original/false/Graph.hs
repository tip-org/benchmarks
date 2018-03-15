module Graph where

import Prelude hiding (last, maximum)
import Tip
import Data.List(elemIndex)

petersen :: Int -> Graph
petersen 0 = []
petersen n =
  concat
    [ [(u,v),(n+u,n+v)]
    | (u,v) <- (pred n,0) : [ (x,succ x) | x <- enumFromTo 0 (pred n) ]
    ] ++
  [ (x,n+x) | x <- enumFromTo 0 n ]

dodeca :: Int -> Graph
dodeca 0 = []
dodeca n =
     ((pred n,0) : [ (x,succ x) | x <- enumFromTo 0 (pred n) ])
  ++ ([ (x,n+x) | x <- enumFromTo 0 n ])
  ++ ([ (n+x,n+n+x) | x <- enumFromTo 0 n ])
  ++ ((n,n+n+pred n):[ (n+succ x,n+n+x) | x <- enumFromTo 0 (pred n) ])
  ++ ([ (n+n+x,n+n+n+x) | x <- enumFromTo 0 n ])
  ++ ((n+n+n+pred n,n+n+n) : [ (n+n+n+x,n+n+n+succ x) | x <- enumFromTo 0 (pred n) ])

type Graph = [(Int,Int)]

type Assignment = [Int]

colouring :: Graph -> Assignment -> Bool
colouring g a =
  and
    [ case (index a u, index a v) of
       (Just c1,Just c2) -> c1 /= c2
       _                 -> False
    | (u,v) <- g
    ]

index :: [a] -> Int -> Maybe a
index [] _ = Nothing
index (x:xs) 0 = Just x
index (x:xs) n = index xs (n-1)

prop_p5 a = question (colouring (petersen n) a && and [ c < 3 | c <- a ])
  where n = 5

prop_p7 a = question (colouring (petersen n) a && and [ c < 3 | c <- a ])
  where n = 7

prop_p9 a = question (colouring (petersen n) a && and [ c < 3 | c <- a ])
  where n = 9

prop_p11 a = question (colouring (petersen n) a && and [ c < 3 | c <- a ])
  where n = 11

prop_p21 a = question (colouring (petersen n) a && and [ c < 3 | c <- a ])
  where n = 21

prop_p31 a = question (colouring (petersen n) a && and [ c < 3 | c <- a ])
  where n = 31

prop_d5 a = question (colouring (dodeca n) a && and [ c < 3 | c <- a ])
  where n = 5

prop_d7 a = question (colouring (dodeca n) a && and [ c < 3 | c <- a ])
  where n = 7

path :: [Int] -> Graph -> Bool
path (x:y:xs) g = or [ u == x && v == y || u == y && v == x | (u,v) <- g ] && path (y:xs) g
path _        _ = True

tour :: [Int] -> Graph -> Bool
tour []       []           = True
tour (_:_)    []           = False
tour []       (_:_)        = False
tour p@(x:xs) g@((u,v):vs) = x == last x xs && path (x:xs) g && unique xs && length p == 2 + maximum (max u v) vs

unique :: Eq a => [a] -> Bool
unique []     = True
unique (x:xs) = if x `elem` xs then False else unique xs

last x []     = x
last x (y:ys) = last y ys

maximum x [] = x
maximum x ((y,z):yzs) = maximum (max x (max y z)) yzs

prop_t3 p = question (tour p (dodeca n))
   where n = 3

prop_t5 p = question (tour p (dodeca n))
   where n = 5

prop_tp5 p = question (tour p (petersen n))
   where n = 5

data B = I | O

bin :: Int -> Bin
bin 0             = []
bin x | even x    = O : bin (x `div` 2)
      | otherwise = I : bin (x `div` 2)

type Bin = [B]

type BGraph = [(Bin,Bin)]

beq :: Bin -> Bin -> Bool
beq [] [] = True
beq (I:xs) (I:ys) = beq xs ys
beq (O:xs) (O:ys) = beq xs ys
beq _ _ = False

belem :: Bin -> [Bin] -> Bool
belem x xs = or [ beq x y | y <- xs ]

bunique :: [Bin] -> Bool
bunique []     = True
bunique (x:xs) = not (belem x xs) && bunique xs

bgraph :: Graph -> BGraph
bgraph g = [ (bin u,bin v) | (u,v) <- g ]

bpath :: [Bin] -> BGraph -> Bool
bpath (x:y:xs) g = or [ beq u x && beq v y || beq u y && beq v x | (u,v) <- g ] && bpath (y:xs) g
bpath _        _ = True

btour :: [Bin] -> Graph -> Bool
btour []       []           = True
btour (_:_)    []           = False
btour []       (_:_)        = False
btour p@(x:xs) g@((u,v):vs) = beq x (last x xs) && bpath (x:xs) (bgraph g) && bunique xs && length p == succ (succ (maximum (max u v) vs))

prop_bt3 p = question (btour p (dodeca n))
   where n = 3

prop_bt4 p = question (btour p (dodeca n))
   where n = 4

prop_bt5 p = question (btour p (dodeca n))
   where n = 5

prop_btp5 p = question (btour p (petersen n))
   where n = 5
