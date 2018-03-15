module Queue where

import Prelude hiding (head, tail, init, last)
import Tip

--------------------------------------------------------------------------------

data Q a = Q [a] [a]

empty :: Q a
empty = Q [] []

enqL :: a -> Q a -> Q a
enqL x (Q xs ys) = mkQ (x:xs) ys

enqR :: Q a -> a -> Q a
enqR (Q xs ys) y = mkQ xs (y:ys)

deqL :: Q a -> Maybe (Q a)
deqL (Q []    [_]) = Just empty
deqL (Q (x:xs) ys) = Just (mkQ xs ys)
deqL _             = Nothing

deqR :: Q a -> Maybe (Q a)
deqR (Q [_] [])    = Just empty
deqR (Q xs (y:ys)) = Just (mkQ xs ys)
deqR _             = Nothing

fstL :: Q a -> Maybe a
fstL (Q []  [y]) = Just y
fstL (Q (x:_) _) = Just x
fstL _           = Nothing

fstR :: Q a -> Maybe a
fstR (Q [x] [])  = Just x
fstR (Q _ (y:_)) = Just y
fstR _           = Nothing

(+++) :: Q a -> Q a -> Q a
Q xs ys +++ Q vs ws = mkQ (xs ++ reverse ys) (ws ++ reverse vs)
--Q xs ys +++ Q vs ws = mkQ (xs ++ reverse ys) (reverse vs ++ ws)
--Q xs ys +++ Q vs ws = Q (xs ++ reverse ys) (ws ++ reverse vs)

mkQ :: [a] -> [a] -> Q a
mkQ [] ys = let (as,bs) = halve ys in Q (reverse as) bs
--mkQ [] ys = let (as,bs) = halve ys in Q (reverse bs) as
mkQ xs [] = let (as,bs) = halve xs in Q as (reverse bs) 
mkQ xs ys = Q xs ys

halve :: [a] -> ([a],[a])
halve xs = (take k xs, drop k xs)
 where
  k = length xs `div` 2

--------------------------------------------------------------------------------

data E a
  = Empty
  | EnqL a (E a)
  | EnqR (E a) a
  | DeqL (E a)
  | DeqR (E a)
  | App (E a) (E a)
 deriving ( Show )

queue :: E a -> Q a
queue Empty      = empty
queue (EnqL x e) = enqL x (queue e)
queue (EnqR e y) = enqR (queue e) y
queue (DeqL e)   = let q = queue e in fromMaybe q (deqL q)
queue (DeqR e)   = let q = queue e in fromMaybe q (deqR q)
queue (App a b)  = queue a +++ queue b

fromMaybe x Nothing  = x
fromMaybe x (Just y) = y

list :: E a -> [a]
list Empty      = []
list (EnqL x e) = x : list e
list (EnqR e y) = list e ++ [y]
list (DeqL e)   = tail (list e)
list (DeqR e)   = init (list e)
list (App a b)  = list a ++ list b

head []    = Nothing
head (x:_) = Just x

tail []     = []
tail (_:xs) = xs

init []     = []
init [x]    = []
init (x:xs) = x : init xs

last []     = Nothing
last [x]    = Just x
last (_:xs) = last xs

prop_QueueL e =
  fstL (queue e) === head (list e)

prop_QueueR e =
  fstR (queue e) === last (list e)

