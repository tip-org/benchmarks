-- List monad laws
module ListMonad where

import Tip
import Prelude hiding ((>>=), return)

(>>=) :: [a] -> (a -> [b]) -> [b]
(x:xs) >>= f = f x ++ (xs >>= f)
[]     >>= f = []

weird_concat :: [[a]] -> [a]
weird_concat ((x:xs):xss) = x:weird_concat (xs:xss)
weird_concat ([]:xss)     = weird_concat xss
weird_concat []           = []

-- Here, weird_concat is a somewhat sensible concatenation function,
-- and has a somewhat strange recursion pattern.
prop_weird_is_normal :: Equality ([[a]] -> [a])
prop_weird_is_normal = concat === weird_concat
prop_weird_concat_map_bind :: (a -> [b]) -> [a] -> Equality [b]
prop_weird_concat_map_bind f xs = weird_concat (map f xs) === xs >>= f

prop_concat_map_bind :: (a -> [b]) -> [a] -> Equality [b]
prop_concat_map_bind f xs = concat (map f xs) === xs >>= f

prop_assoc :: [a] -> (a -> [b]) -> (b -> [c]) -> Equality [c]
prop_assoc m f g = ((m >>= f) >>= g) === (m >>= (\x -> f x >>= g))

prop_return_1 :: a -> (a -> [b]) -> Equality [b]
prop_return_1 x f = return x >>= f === f x

prop_return_2 :: [a] -> Equality [a]
prop_return_2 xs = xs >>= return === xs

return :: a -> [a]
return x = [x]

