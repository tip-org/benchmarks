-- Property about rotate and mod
module ModRotate where

import Tip
import Rotate
import Mod
import Prelude hiding (mod)

prop_mod :: Int -> [a] -> Equality [a]
prop_mod n xs = rotate n xs === drop (n `mod` length xs) xs ++ take (n `mod` length xs) xs

prop_structural_mod :: Int -> [a] -> Equality [a]
prop_structural_mod n xs = rotate n xs === drop (n `mod_structural` length xs) xs ++ take (n `mod_structural` length xs) xs
