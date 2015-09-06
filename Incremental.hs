module Main where

import System.Directory
import System.FilePath
import Control.Applicative

import System.Environment
import System.Process
import System.Exit

import Data.Time.Clock
import Numeric
import Text.Printf

import Data.Char
import Data.List
import Data.Ord
import Data.Function
import System.Timeout

groupOn f = groupBy ((==) `on` f) . sortBy (comparing f)

incrementalGroups = map sort . groupOn removeDigitPairs

removeDigitPairs (x:y:xs) | isDigit x && isDigit y = removeDigitPairs xs
removeDigitPairs (x:xs) = x:removeDigitPairs xs
removeDigitPairs []     = []

timeIt :: IO a -> IO (Double,a)
timeIt m =
  do t0 <- getCurrentTime
     r <- m
     t1 <- getCurrentTime
     let t :: Double
         t = fromRat (toRational (diffUTCTime t1 t0))
     return (t,r)

main = do
  all_args@(bad:dir:timelimit:cmd:args) <- getArgs
  files <- filter ((".smt2" ==) . takeExtension) <$> getDirectoryContents dir

  let is_ok = case bad of
        "-" -> const True
        _   -> not . (bad `isInfixOf`)

      log_filename = (concatMap (++ "_") (cmd:args))

      log :: FilePath -> Maybe Double -> IO ()
      log f maybe_time =
        do let time_str = case maybe_time of
                            Just t  -> printf "%0.5f" t
                            Nothing -> "-"
           appendFile log_filename (f ++ "," ++ time_str ++ "\n")

  b <- doesFileExist log_filename
  if b then removeFile log_filename
       else return ()

  putStrLn (unwords all_args)
  putStrLn log_filename

  let process []     = return ()
      process (f:fs) =
        do putStrLn f
           (t,(exc,out,err)) <- timeIt (readProcessWithExitCode "timeout" (timelimit:cmd:(dir </> f):args) "")
           putStrLn (printf "%0.5fs" t ++ ", " ++ show exc)
           putStrLn out
           putStrLn err
           case exc of
             ExitSuccess | is_ok out
               -> do log f (Just t)
                     process fs
             _ -> do sequence_ [ log fl Nothing | fl <- f:fs ]

  mapM_ process (incrementalGroups files)

