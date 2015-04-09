{-# LANGUAGE TemplateHaskell #-}
module ListMonad where

import Prelude hiding ((>>=),(++),fmap,id,(.), return,concat)

import Data.Typeable

import Tip.DSL
import Test.QuickCheck hiding ((==>))
import Data.Typeable

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
{-
f . g = \x -> f (g x)

id :: a -> a
id x = x

main = hipSpec $(fileName)
    [ pvars ["x","y","z"]       (undefined :: A)
    , pvars ["xs","ys","zs"]    (undefined :: [A])
    , pvars ["xss","yss","zss"] (undefined :: [[A]])
    , vars ["f","g","h"]        (undefined :: A -> A)
    , vars ["k"]                (undefined :: A     -> [A])
    , vars ["i"]                (undefined :: [A]   -> A)
    , vars ["j"]                (undefined :: [A]   -> [[A]])
    , vars ["r"]                (undefined :: [[A]] -> [A])
    , vars ["t"]                (undefined :: A     -> [[A]])
    , blind0 "id"               (id        :: [A] -> [A])
    , blind0 "id"               (id        :: A   -> A)
    , blind2 "."                ((.)       :: (A   -> A)   -> (A   -> A)   -> A   -> A)
    , blind2 "."                ((.)       :: ([A] -> [A]) -> ([A] -> [A]) -> [A] -> [A])
    , fun0 "[]"                 ([]        :: [A])
    , fun0 "[]"                 ([]        :: [[A]])
    , blind0 "return"            (return     :: A   -> [A])
    , fun1 "return"              (return     :: A   -> [A])
    , fun2 ":"                  ((:)       :: A   -> [A]   -> [A])
    , fun2 ":"                  ((:)       :: [A] -> [[A]] -> [[A]])
    , fun2 "++"                 ((++)      :: [A]   -> [A]   -> [A])
    , fun2 "++"                 ((++)      :: [[A]] -> [[A]] -> [[A]])
    , fun1 "concat"               (concat      :: [[A]] -> [A])
    , fun1 "concat"               (concat      :: [[[A]]] -> [[A]])
    , fun2 ">>="                ((>>=)     :: [A] -> (A -> [A]) -> [A])
    , fun2 ">>="                ((>>=)     :: [A] -> (A -> [[A]]) -> [[A]])
    , fun2 "fmap"               (fmap      :: (A -> A) -> [A] -> [A])
    , fun2 "fmap"               (fmap      :: (A -> [A]) -> [A] -> [[A]])
    ]

-}
