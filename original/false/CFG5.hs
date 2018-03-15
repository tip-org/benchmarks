module CFG5 where

import Tip

data E = E :+: E | E :*: E | EX | EY
  deriving (Eq,Ord,Show)


data Tok = C | D | X | Y | Plus | Mul
  deriving (Eq,Ord,Show)

lin :: E -> [Tok]
lin (a :+: b) = linTerm a ++ [Plus] ++ linTerm b
lin (a :*: b) = lin a ++ [Mul] ++ lin b
lin EX        = [X]
lin EY        = [Y]

linTerm :: E -> [Tok]
linTerm (a :*: b) = [C] ++ lin (a :+: b) ++ [D]
linTerm e         = lin e

prop_unambig u v = lin u === lin v ==> assoc u === assoc v

-- FLAGS: cassoc
assoc :: E -> E
assoc ((a :+: b) :+: c) = assoc (a :+: (b :+: c))
-- assoc ((a :*: b) :*: c) = assoc (a :*: (b :*: c))
assoc (a :+: b) = assoc a :+: assoc b
assoc (a :*: b) = assoc a :*: assoc b
assoc a         = a

