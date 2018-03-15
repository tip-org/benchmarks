module Scale where

import Tip
import qualified Prelude
import Prelude ( Bool(..) )

data Object = O1 | O2 | O3 | O4 | O5 | O6 | O7 | O8 | O9 | O10 | O11 | O12

O1  <= _   = True
_   <= O1  = False
O2  <= _   = True
_   <= O2  = False
O3  <= _   = True
_   <= O3  = False
O4  <= _   = True
_   <= O4  = False
O5  <= _   = True
_   <= O5  = False
O6  <= _   = True
_   <= O6  = False
O7  <= _   = True
_   <= O7  = False
O8  <= _   = True
_   <= O8  = False
O9  <= _   = True
_   <= O9  = False
O10 <= _   = True
_   <= O10 = False
O11 <= _   = True
_   <= O11 = False
_   <= _   = True

x <  y = not (y <= x)

O1  ~~ O1  = True
O2  ~~ O2  = True
O3  ~~ O3  = True
O4  ~~ O4  = True
O5  ~~ O5  = True
O6  ~~ O6  = True
O7  ~~ O7  = True
O8  ~~ O8  = True
O9  ~~ O9  = True
O10 ~~ O10 = True
O11 ~~ O11 = True
O12 ~~ O12 = True
_   ~~ _   = False

otherwise = True

not False = True
not True  = False

True  =~ x = x
False =~ x = not x

True  && b = b
False && b = False

usorted :: [Object] -> Bool
usorted (x:y:xs) = (x < y) && usorted (y:xs)
usorted _        = True

-- FLAGS: cdisjoint
disjoint :: [Object] -> [Object] -> Bool
disjoint (x:xs) (y:ys)
  | x <= y    = if y <= x then False else disjoint xs (y:ys)
  | otherwise = disjoint (x:xs) ys
disjoint _      _      = True

data Schema
  = Answer Bool Object
  | Weigh [Object] [Object] Schema Schema Schema

isFine :: Schema -> Bool
isFine (Answer _ x)        = True
isFine (Weigh xs ys p q r) =
  len xs (Succ (Succ (Succ (Succ Zero)))) &&
  len ys (Succ (Succ (Succ (Succ Zero)))) &&
  usorted xs && usorted ys && disjoint xs ys && sameSize xs ys && isFine p && isFine q && isFine r

len :: [a] -> Nat -> Bool
len []     _        = True
len (_:xs) (Succ n) = len xs n
len _      _        = False

sameSize :: [a] -> [a] -> Bool
sameSize []     []     = True
sameSize (_:xs) (_:ys) = sameSize xs ys
sameSize _      _      = False

solves :: Schema -> Bool -> Object -> Bool
solves (Answer hx x)       heavy y = (hx =~ heavy) && (x ~~ y)
solves (Weigh xs ys p q r) heavy y = solves (weigh heavy y xs ys p q r) heavy y

weigh :: Bool -> Object -> [Object] -> [Object] -> Schema -> Schema -> Schema -> Schema
weigh heavy y (a:as) (b:bs) p q r
  | y ~~ a    = if heavy then p else r
  | y ~~ b    = if heavy then r else p
  | otherwise = weigh heavy y as bs p q r
weigh heavy y _ _ p q r = q

data Nat
  = Zero
  | Succ Nat

depth :: Nat -> Schema -> Bool
depth Zero     (Answer _ _)      = True
depth (Succ n) (Weigh _ _ p q r) = depth n p && depth n q && depth n r
depth _        _                 = False

isSolution :: Schema -> Bool
isSolution s = isFine s && solvesAll s allCases

solvesAll :: Schema -> [(Bool,Object)] -> Bool
solvesAll s [] = True
solvesAll s ((h,o):css) = solves s h o && solvesAll s css

allCases :: [(Bool,Object)]
allCases = [(False,O1),(False,O2),(False,O3),(False,O4)
           ,(False,O5),(False,O6),(False,O7),(False,O8),(False,O9),(False,O10),(False,O11),(False,O12)
           ,(True,O1),(True,O2),(True,O3),(True,O4)
           ,(True,O5),(True,O6),(True,O7),(True,O8),(True,O9),(True,O10),(True,O11),(True,O12)
           ]

prop s = depth (Succ (Succ (Succ Zero))) s === True ==> isSolution s === False

{-
allCases :: [(Bool,Object)]
allCases = [(False,O1),(False,O2),(False,O3),(False,O4)
           --,(False,O5),(False,O6),(False,O7),(False,O8)
           --,(False,O9),(False,O10),(False,O11),(False,O12)
           ,(True,O1),(True,O2),(True,O3),(True,O4)
           --,(True,O5),(True,O6),(True,O7),(True,O8)
           --,(True,O9),(True,O10),(True,O11),(True,O12)
           ]

prop s = depth (Succ (Succ Zero)) s === True ==> isSolution s === False
-}

{-
allCases :: [(Bool,Object)]
allCases = [(False,O1),(False,O2),(False,O3),(False,O4)
           --,(False,O5),(False,O6),(False,O7),(False,O8)
           --,(False,O9),(False,O10),(False,O11),(False,O12)
           --,(True,O1),(True,O2),(True,O3),(True,O4)
           ,(True,O5),(True,O6),(True,O7),(True,O8)
           --,(True,O9),(True,O10),(True,O11),(True,O12)
           ]

prop s = depth (Succ (Succ Zero)) s === True ==> isSolution s === False
-}
