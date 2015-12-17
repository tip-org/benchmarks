module Sudoku where

import Tip.Prelude
import qualified Prelude as P

-------------------------------------------------------------------------
-- A

data Cell = C1 | C2 | C3 | C4 | C5 | C6 | C7 | C8 | C9
  deriving (P.Eq,P.Ord,P.Show)

C1 `eqCell` C1 = True
C2 `eqCell` C2 = True
C3 `eqCell` C3 = True
C4 `eqCell` C4 = True
C5 `eqCell` C5 = True
C6 `eqCell` C6 = True
C7 `eqCell` C7 = True
C8 `eqCell` C8 = True
C9 `eqCell` C9 = True
_  `eqCell` _  = False

data Sudoku = Sudoku { rows :: [[Maybe Cell]] }
 deriving ( P.Show, P.Eq )

-- A1.

allBlankSudoku :: Sudoku
allBlankSudoku =
  Sudoku (replicate n9 (replicate n9 Nothing))

replicate :: Nat -> a -> [a]
replicate Z     _ = []
replicate (S n) a = a : replicate n a

-- A2.

n3 :: Nat
n3 = S (S (S Z))

n6 :: Nat
n6 = S (S (S (S (S (S Z)))))

n9 :: Nat
n9 = S (S (S (S (S (S (S (S (S Z))))))))

isSudoku :: Sudoku -> Bool
isSudoku (Sudoku sud) =
     length sud == n9
  && and [ length row ==  n9 | row <- sud ]

-- A3.

isSolved :: Sudoku -> Bool
isSolved (Sudoku sud) =
  and [ isJust x | row <- sud, x <- row ]

isJust Just{} = True
isJust _      = False

-------------------------------------------------------------------------
-- D

type Block = [Maybe Cell]

-- D1.

elem' :: Cell -> [Cell] -> Bool
x `elem'` [] = False
x `elem'` (y:ys) = x `eqCell` y || x `elem'` ys

unique' :: [Cell] -> Bool
unique' []     = True
unique' (x:xs) = if x `elem'` xs then False else unique' xs

isOkayBlock :: Block -> Bool
isOkayBlock blk = unique' [ n | Just n <- blk ]

-- D2.

transpose               :: [[a]] -> [[a]]
transpose []             = []
transpose ([]   : xss)   = transpose xss
transpose ((x:xs) : xss) = (x : [h | (h:_) <- xss]) : transpose (xs : [ t | (_:t) <- xss])

blocks, blocks3x3 :: Sudoku -> [Block]
blocks sud =
  -- rows
  [ row | row <- rows sud ] ++
  -- columns
  [ col | col <- transpose (rows sud) ] ++
  -- 3x3 blocks
  blocks3x3 sud

blocks3x3 sud =
  group3 [ take n3 row | row <- rows sud ] ++
  group3 [ take n3 (drop n3 row) | row <- rows sud ] ++
  group3 [ drop n6 row | row <- rows sud ]

group3 (xs1:xs2:xs3:xss) = (xs1 ++ xs2 ++ xs3) : group3 xss
group3 _                 = []

-- D3.

isOkay :: Sudoku -> Bool
isOkay sud =
  and
  [ isOkayBlock blk
  | blk <- blocks sud
  ]

-- F3.

isSolutionOf :: Sudoku -> Sudoku -> Bool
sud1 `isSolutionOf` sud2 =
  isSolved sud1 && isOkay sud1 &&
    and [ n1 `eqCell` n2
        | (row1,row2) <- rows sud1 `zip` rows sud2
        , (Just n1,Just n2) <- row1 `zip` row2
        ]

sat_blank s   = question (isSudoku s .&&. isOkay s .&&. isSolved s)

sat_example s = question (isSudoku s .&&. s `isSolutionOf` example)

sat_difficult s = question (isSudoku s .&&. s `isSolutionOf` difficult)

example :: Sudoku
example =
  Sudoku
    [ [Just C3, Just C6, Nothing,Nothing,Just C7, Just C1, Just C2, Nothing,Nothing]
    , [Nothing,Just C5, Nothing,Nothing,Nothing,Nothing,Just C1, Just C8, Nothing]
    , [Nothing,Nothing,Just C9, Just C2, Nothing,Just C4, Just C7, Nothing,Nothing]
    , [Nothing,Nothing,Nothing,Nothing,Just C1, Just C3, Nothing,Just C2, Just C8]
    , [Just C4, Nothing,Nothing,Just C5, Nothing,Just C2, Nothing,Nothing,Just C9]
    , [Just C2, Just C7, Nothing,Just C4, Just C6, Nothing,Nothing,Nothing,Nothing]
    , [Nothing,Nothing,Just C5, Just C3, Nothing,Just C8, Just C9, Nothing,Nothing]
    , [Nothing,Just C8, Just C3, Nothing,Nothing,Nothing,Nothing,Just C6, Nothing]
    , [Nothing,Nothing,Just C7, Just C6, Just C9, Nothing,Nothing,Just C4, Just C3]
    ]

-- from http://www.telegraph.co.uk/news/science/science-news/9360022/Worlds-hardest-sudoku-the-answer.html
difficult :: Sudoku
difficult =
  Sudoku
    [ [Just C8,Nothing,Nothing,Nothing,Nothing,Nothing,Nothing,Nothing,Nothing]
    , [Nothing,Nothing,Just C3,Just C6,Nothing,Nothing,Nothing,Nothing,Nothing]
    , [Nothing,Just C7,Nothing,Nothing,Just C9,Nothing,Just C2,Nothing,Nothing]
    , [Nothing,Just C5,Nothing,Nothing,Nothing,Just C7,Nothing,Nothing,Nothing]
    , [Nothing,Nothing,Nothing,Nothing,Just C4,Just C5,Just C7,Nothing,Nothing]
    , [Nothing,Nothing,Nothing,Just C1,Nothing,Nothing,Nothing,Just C3,Nothing]
    , [Nothing,Nothing,Just C1,Nothing,Nothing,Nothing,Nothing,Just C6,Just C8]
    , [Nothing,Nothing,Just C8,Just C5,Nothing,Nothing,Nothing,Just C1,Nothing]
    , [Nothing,Just C9,Nothing,Nothing,Nothing,Nothing,Just C4,Nothing,Nothing]
    ]
