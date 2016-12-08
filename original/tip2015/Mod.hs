-- Modulus, structurally recursive and straightforward implementation
module Mod where

import Rotate
import Tip
import Prelude hiding (mod)

mod :: Int -> Int -> Int
n `mod` 0 = 0
n `mod` m
    | n < m     = n
    | otherwise = (n - m) `mod` m


mod_structural :: Int -> Int -> Int
n `mod_structural` m = go n 0 m

-- go n k m = (n-k) mod m
go :: Int -> Int -> Int -> Int
go _ _ 0 = 0
go 0 0 _ = 0              -- 0 % m = 0
go 0 n m = m - n          -- (-S n) % m = m - S n
go n 0 m = go (n-1) (m-1) m -- S n % S m = (S n - S m) % S m = (n - m) % S m
go n k m = go (n-1) (k-1) m

prop_same m n = m `mod` n === m `mod_structural` n

