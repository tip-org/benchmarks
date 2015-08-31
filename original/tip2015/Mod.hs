-- Modulus, structurally recursive and straightforward implementation
module Mod where

import Tip.Prelude
import Rotate
import qualified Prelude as P

mod :: Nat -> Nat -> Nat
n `mod` Z = Z
n `mod` m
    | n < m     = n
    | otherwise = (n - m) `mod` m


mod_structural :: Nat -> Nat -> Nat
n `mod_structural` m = go n Z m

-- go n k m = (n-k) mod m
go :: Nat -> Nat -> Nat -> Nat
go _ _ Z = Z
go Z Z _ = Z                    -- 0 % m = 0
go Z (S n) m = m - S n          -- (-S n) % m = m - S n
go (S n) Z (S m) = go n m (S m) -- S n % S m = (S n - S m) % S m = (n - m) % S m
go (S n) (S k) m = go n k m

prop_same m n = m `mod` n === m `mod_structural` n

