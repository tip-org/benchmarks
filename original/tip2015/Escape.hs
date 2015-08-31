-- Escaping and unescaping
module Escape where

import Tip.Prelude
import qualified Prelude as P

--------------------------------------------------------------------------------

data Token = A | B | C | D | ESC | P | Q | R

escape :: [Token] -> [Token]
escape []                   = []
escape (x:xs) | isSpecial x = ESC : code x : escape xs
              | otherwise   = x : escape xs

isSpecial :: Token -> Bool
isSpecial ESC = True
isSpecial P   = True
isSpecial Q   = True
isSpecial R   = True
isSpecial _   = False

code :: Token -> Token
code ESC = ESC
code P   = A
code Q   = B
code R   = C
code x   = x

isEsc :: Token -> Bool
isEsc ESC = True
isEsc _   = False

ok :: Token -> Bool
ok x = not (isSpecial x) || isEsc x

--------------------------------------------------------------------------------

prop_Injective xs ys =
  escape xs === escape ys ==> xs === ys

prop_NoSpecial xs =
  all ok (escape xs) === True

