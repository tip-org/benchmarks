-- From the Reach article
--
-- Presumably, this property is true
--
-- Ints replaced with nats, and all functions made total
module Mux1 where

import qualified Prelude
import Tip.Prelude

orList [] = False
orList (x:xs) = x || orList xs

orTree [] = False
orTree [x] = x
orTree (x:y:ys) = orTree (ys ++ [x || y])

hd [] = []
hd (x:xs) = [x]

tl [] = []
tl (x:xs) = xs

flatten [] = []
flatten (x:xs) = x ++ flatten xs

map_hd [] = []
map_hd (x:xs) = hd x : map_hd xs

map_tl [] = []
map_tl (x:xs) = tl x : map_tl xs

map_orTree [] = []
map_orTree (x:xs) = orTree x : map_orTree xs

transpose xs =
  case flatten xs of
    [] -> []
    _  -> flatten (map_hd xs) : transpose (map_tl xs)

distAnd x [] = []
distAnd x (y:ys) = (x && y) : distAnd x ys

zipDistAnd (x:xs) (y:ys) = distAnd x y : zipDistAnd xs ys
zipDistAnd _ _ = []

mux sel xs =
  map_orTree
    (transpose
      (zipDistAnd sel xs))

oneHot [] = False
oneHot (x:xs) = if x then not (orList xs) else oneHot xs

len [] = Z
len (x:xs) = S (len xs)

allLen n [] = True
allLen n (x:xs) = len x == n && allLen n xs

sameLen (x:xs) = allLen (len x) xs
sameLen [] = True

firstHot [] = Z
firstHot (x:xs) = if x then Z else S (firstHot xs)

xnor False x = not x
xnor True x = x

[] <=> ys = null ys
(x:xs) <=> ys = case ys of
                  [] -> False
                  y:ys -> x `xnor` y && (xs <=> ys)

-- Property

ok sel xs n = case index xs n of
            Just b -> mux sel xs <=> b
            Nothing -> False

prop_mux sel xs =
      oneHot sel
  ==> (len sel == len xs)
  ==> sameLen xs
  ==> ok sel xs n
  where
    n = firstHot sel

