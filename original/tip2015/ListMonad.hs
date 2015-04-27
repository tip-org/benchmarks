-- List monad laws
module ListMonad where

import Prelude hiding ((>>=),(++),fmap,id,(.), return,concat)

import Tip.DSL

(++) :: [a] -> [a] -> [a]
(x:xs) ++ ys = x:(xs ++ ys)
[]     ++ ys = ys

(>>=) :: [a] -> (a -> [b]) -> [b]
(x:xs) >>= f = f x ++ (xs >>= f)
[]     >>= f = []

weird_concat :: [[a]] -> [a]
weird_concat ((x:xs):xss) = x:weird_concat (xs:xss)
weird_concat ([]:xss)     = weird_concat xss
weird_concat []           = []

concat :: [[a]] -> [a]
concat (xs:xss) = xs ++ concat xss
concat []       = []

fmap :: (a -> b) -> [a] -> [b]
fmap f []     = []
fmap f (x:xs) = f x : fmap f xs

-- Here, weird_concat is a somewhat sensible concatenation function,
-- and has a somewhat strange recursion pattern.
prop_weird_is_normal :: Prop ([[a]] -> [a])
prop_weird_is_normal = concat =:= weird_concat
prop_weird_concat_fmap_bind :: (a -> [b]) -> [a] -> Prop [b]
prop_weird_concat_fmap_bind f xs = weird_concat (fmap f xs) =:= xs >>= f

prop_concat_fmap_bind :: (a -> [b]) -> [a] -> Prop [b]
prop_concat_fmap_bind f xs = concat (fmap f xs) =:= xs >>= f

prop_assoc :: [a] -> (a -> [b]) -> (b -> [c]) -> Prop [c]
prop_assoc m f g = ((m >>= f) >>= g) =:= (m >>= (\x -> f x >>= g))

prop_return_1 :: a -> (a -> [b]) -> Prop [b]
prop_return_1 x f = return x >>= f =:= f x

prop_return_2 :: [a] -> Prop [a]
prop_return_2 xs = xs >>= return =:= xs

return :: a -> [a]
return x = [x]

