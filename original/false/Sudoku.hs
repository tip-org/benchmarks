module Sudoku where

import Tip

-------------------------------------------------------------------------
-- A

data Cell = C1 | C2 | C3 | C4 | C5 | C6 | C7 | C8 | C9 deriving Eq

data Sudoku = Sudoku { rows :: [[Maybe Cell]] }

-- A1.

allBlankSudoku :: Sudoku
allBlankSudoku =
  Sudoku (replicate 9 (replicate 9 Nothing))

-- A2.

isSudoku :: Sudoku -> Bool
isSudoku (Sudoku sud) =
     length sud == 9
  && and [ length row ==  9 | row <- sud ]

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

unique' :: [Cell] -> Bool
unique' []     = True
unique' (x:xs) = if x `elem` xs then False else unique' xs

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
  group3 [ take 3 row | row <- rows sud ] ++
  group3 [ take 3 (drop 3 row) | row <- rows sud ] ++
  group3 [ drop 6 row | row <- rows sud ]

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
    and [ n1 == n2
        | (row1,row2) <- rows sud1 `zip` rows sud2
        , (Just n1,Just n2) <- row1 `zip` row2
        ]

--solve_blank s   = question (isSudoku s .&&. isOkay s .&&. isSolved s)

-- solve_example s = question (isSudoku s .&&. s `isSolutionOf` example)

solve_difficult s = question (isSudoku s .&&. s `isSolutionOf` difficult)

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

