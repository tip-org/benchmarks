import System.Environment
import Data.Char
import Data.List hiding (find)

comments :: [String] -> ([String], [String])
comments xs = (map (drop 3) ys, zs)
  where
    (ys, zs) = span (isPrefixOf "-- ") xs

decorate start start2 end [] = []
decorate start start2 end (line:lines) =
  decorateLast ((start ++ line):map (start2 ++) lines)
  where
    decorateLast lines =
      init lines ++ [last lines ++ end]

chop [] = []
chop ("":lines) =
  []:chop lines
chop (xs@(x:_):ys:lines) | isAlpha x && "-- " `isPrefixOf` ys =
  [xs]:chop (ys:lines)
chop (x:xs) =
  case chop xs of
    [] -> [[x]]
    (ys:yss) -> (x:ys):yss

find name (xs:xss)
  | any (isPrefixOf name) xs = fst (comments xs)
  | otherwise = find name xss
find _ [] = []

main = do
  [file, prop, start, start2, end] <- getArgs
  source <- fmap lines (readFile file)
  let (moduleComments, rest) = comments source
      functionComments = find prop (chop rest)
      allComments = moduleComments ++ ["" | not (null moduleComments) && not (null functionComments) ] ++ functionComments

  mapM_ putStrLn (decorate start start2 end allComments)

