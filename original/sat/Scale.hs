module Scale where

import Tip.Prelude hiding ((<),(<=))
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

True  =~ x = x
False =~ x = not x

usorted :: [Object] -> Bool
usorted (x:y:xs) = (x < y) && usorted (y:xs)
usorted _        = True

disjoint :: [Object] -> [Object] -> Bool
disjoint (x:xs) (y:ys)
  | x <= y    = if y <= x then False else disjoint xs (y:ys)
  | otherwise = disjoint (x:xs) ys
disjoint _      _      = True

overlap :: [Object] -> [Object] -> Bool
overlap xs ys = or [ x ~~ y | x <- xs, y <- ys]

data Schema
  = Answer Bool Object
  | Weigh [Object] [Object] Schema Schema Schema

isFine :: Schema -> Bool
isFine (Answer _ x)        = True
isFine (Weigh xs ys p q r) =
  -- len xs (S (S (S (S Z)))) &&
  -- len ys (S (S (S (S Z)))) &&
  usorted xs && usorted ys && disjoint xs ys &&
  -- not (overlap xs ys) &&
  {- sameSize xs ys && -} isFine p && isFine q && isFine r

len :: [a] -> Nat -> Bool
len []     _     = True
len (_:xs) (S n) = len xs n
len _      _     = False

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

depth :: Nat -> Schema -> Bool
depth Z     (Answer _ _)      = True
depth (S n) (Weigh _ _ p q r) = depth n p && depth n q && depth n r
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

-- sat_solution s = question (depth (S (S (S Z))) s .&&. isSolution s)

sat_solution
   -- a1 a2 a3 a4 a5 a6 a7 a8
   d1 d2 d3 d4 e1 e2 e3 e4
   dd1 dd2 dd3 dd4 dd5 dd6
   ee1 ee2 ee3 ee4 ee5 ee6
   aa1 aa4
   aa2 aa5
   aa3 aa6

   ab1 ab4
   ab2 ab5
   ab3 ab6

   ac1 ac4
   ac2 ac5
   ac3 ac6
   ba1 oa1 ba4 oa4 ba7 oa7
   ba2 oa2 ba5 oa5 ba8 oa8
   ba3 oa3 ba6 oa6 ba9 oa9
   bb1 ob1 bb4 ob4 bb7 ob7
   bb2 ob2 bb5 ob5 bb8 ob8
   bb3 ob3 bb6 ob6 bb9 ob9
   bc1 oc1 bc4 oc4 bc7 oc7
   bc2 oc2 bc5 oc5 bc8 oc8
   bc3 oc3 bc6 oc6 bc9 oc9
   =
   question (isSolution
              (Weigh [d1,d2,d3,d4] [e1,e2,e3,e4]
                (Weigh [dd1,dd2] [ee1,ee2]
                  (Weigh [aa1] [aa4] (Answer ba1 oa1) (Answer ba4 oa4) (Answer ba7 oa7))
                  (Weigh [aa2] [aa5] (Answer ba2 oa2) (Answer ba5 oa5) (Answer ba8 oa8))
                  (Weigh [aa3] [aa6] (Answer ba3 oa3) (Answer ba6 oa6) (Answer ba9 oa9)))
                (Weigh [dd3,dd4] [ee3,ee4]
                  (Weigh [ab1] [ab4] (Answer bb1 ob1) (Answer bb4 ob4) (Answer bb7 ob7))
                  (Weigh [ab2] [ab5] (Answer bb2 ob2) (Answer bb5 ob5) (Answer bb8 ob8))
                  (Weigh [ab3] [ab6] (Answer bb3 ob3) (Answer bb6 ob6) (Answer bb9 ob9)))
                (Weigh [dd5,dd6] [ee5,ee6]
                  (Weigh [ac1] [ac4] (Answer bc1 oc1) (Answer bc4 oc4) (Answer bc7 oc7))
                  (Weigh [ac2] [ac5] (Answer bc2 oc2) (Answer bc5 oc5) (Answer bc8 oc8))
                  (Weigh [ac3] [ac6] (Answer bc3 oc3) (Answer bc6 oc6) (Answer bc9 oc9)))))

{-
allCases :: [(Bool,Object)]
allCases = [(False,O1),(False,O2),(False,O3),(False,O4)
           --,(False,O5),(False,O6),(False,O7),(False,O8)
           --,(False,O9),(False,O10),(False,O11),(False,O12)
           ,(True,O1),(True,O2),(True,O3),(True,O4)
           --,(True,O5),(True,O6),(True,O7),(True,O8)
           --,(True,O9),(True,O10),(True,O11),(True,O12)
           ]

prop s = question (depth (S (S Z)) s .&&. isSolution s)
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

prop s = depth (S (S Z)) s === True ==> isSolution s === False
-}
