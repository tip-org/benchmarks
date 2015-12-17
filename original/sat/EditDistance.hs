module EditDistance where

import Tip.Prelude hiding (S,Z)
import qualified Tip.Prelude as Tip
import qualified Prelude

data Char = A | B | C | D | E | F | G | H | I | J | K | L | M | N | O | P | Q | R | S | T | U | V | W | X | Y | Z

eq :: Char -> Char -> Bool
A `eq` A = True
B `eq` B = True
C `eq` C = True
D `eq` D = True
E `eq` E = True
F `eq` F = True
G `eq` G = True
H `eq` H = True
I `eq` I = True
J `eq` J = True
K `eq` K = True
L `eq` L = True
M `eq` M = True
N `eq` N = True
O `eq` O = True
P `eq` P = True
Q `eq` Q = True
R `eq` R = True
S `eq` S = True
T `eq` T = True
U `eq` U = True
V `eq` V = True
W `eq` W = True
X `eq` X = True
Y `eq` Y = True
Z `eq` Z = True
_ `eq` _ = False

data Edit
  = Insert Char Nat
  | Delete Nat
  | Subst Char Nat
  -- | Transpose Nat

type String = [Char]

edit :: Edit -> String -> String
edit (Insert c n)  s = take n s ++ [c] ++ drop n s
edit (Delete n)    s = take n s ++ drop (Tip.S n) s
edit (Subst c n)   s = take n s ++ [c] ++ drop (Tip.S n) s

{-
data Where = Here | There Where

data Edit
  = Insert Char Where
  | Delete Where
  | Subst Char Where
  | Transpose Where

edit :: Edit -> String -> String
edit (Insert c  Here) s     = c:s
edit (Delete    Here) (c:s) = s
edit (Subst c   Here) (_:s) = c:s
edit (Transpose Here) (c1:c2:s) = c2:c1:s
edit (Insert c  (There w)) (h:s) = h:edit (Insert c w) s
edit (Delete    (There w)) (h:s) = h:edit (Delete w) s
edit (Subst c   (There w)) (h:s) = h:edit (Subst c w) s
edit (Transpose (There w)) (h:s) = h:edit (Transpose w) s
edit _ s = s
-}

edits :: [Edit] -> String -> String
edits (e:es) s = edits es (edit e s)
edits []     s = s

-- test es = question (edits es [A,P,A,B,E,P,A] === [B,A,R,B,A,P,A,P,P,A])

-- test es = question (edits es [H,A,S,K,E,L,L] === [T,R,A,S,E,L,L])

-- test a b c   = question (edits [a,b,c]   [H,A,S,K,E,L,L] === [T,R,A,S,E,L,L])
-- test a b c d = question (edits [a,b,c,d] [H,A,S,K,E,L,L] === [T,R,A,S,E,L,L])

-- test es = question (edits es [K,I,T,T,E,N] === [S,I,T,T,I,N,G])
-- test a b = question (edits [a,b] [K,I,T,T,E,N] === [S,I,T,T,I,N,G])
-- test a b c = question (edits [a,b,c] [K,I,T,T,E,N] === [S,I,T,T,I,N,G])
-- test a b c d = question (edits [a,b,c,d] [K,I,T,T,E,N] === [S,I,T,T,I,N,G])
-- test a b c d e = question (edits [a,b,c,d,e] [K,I,T,T,E,N] === [S,I,T,T,I,N,G])

test a b = question (edits [a,b] [K,I,T,T,E,N] === [M,I,T,T,E,N,S])

-- test a b c d e = question (edits [a,b,c,d,e] [K,I,T,T,E,N] === [M,I,T,T,E,N,S])

