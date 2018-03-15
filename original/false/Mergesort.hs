{-# LANGUAGE CPP #-}
module Mergesort where

import Tip

count :: Int -> [Int] -> Int
count n [] = 0
count n (x:xs)
  | x == n = succ (count n xs)
  | otherwise = count n xs

-- FLAGS: cmsort
msort :: [Int] -> [Int]
msort []  = []
msort [x] = [x]
--msort xs  = merge (msort (evens xs)) (msort (odds xs))
msort xs  = merge (msort ys) (msort zs)
  where
    (ys,zs) = splitAt (length xs `div` 2) xs

evens :: [a] -> [a]
evens [] = []
evens [x] = [x]
evens (x:_:xs) = x:evens xs

odds :: [a] -> [a]
odds [] = []
odds [_] = []
odds (_:y:xs) = y:odds xs

-- FLAGS: cmerge
merge :: [Int] -> [Int] -> [Int]
merge (x:xs) (y:ys)
    | x <= y    = x:(merge xs (y:ys))
    | otherwise = y:(merge (x:xs) ys)
merge (x:xs) [] = x:xs
merge []     [] = []
merge [] ys = ys

prop_merge_comm xs ys zs =
  merge xs ys === merge ys xs ==>
  merge xs zs === merge zs xs ==>
  merge ys zs === merge zs ys

ord :: [Int] -> Bool
ord (x:y:xs) = if x <= y then ord (y:xs) else False
ord _        = True

nub :: [Int] -> [Int]
nub (x:xs) = x:remove x (nub xs)
nub []     = []

sorted :: [Int] -> Bool
sorted (x:y:xs) = x <= y && sorted (y:xs)
sorted _        = True

usorted :: [Int] -> Bool
usorted (x:y:xs) = x < y && usorted (y:xs)
usorted _        = True

allsmall :: Int -> [Int] -> Bool
allsmall n []     = True
allsmall n (x:xs) = x < n && allsmall n xs

{-
assoc x xs ys zs = (xs ++ (ys ++ zs)) === ((xs ++ ys) ++ zs)
               ==> ((x:xs) ++ (ys ++ zs)) === (((x:xs) ++ ys) ++ (zs :: [Bool]))

assoc0 ys zs = [] ++ (ys ++ zs) === ([] ++ ys) ++ (zs :: [Bool])
-}

{-
pins y x xs = not (sorted xs) || sorted (insert x xs) === True
          ==> sorted (x:xs) === True
          ==> sorted (insert y (x:xs)) === True
-}

pallsmall     xs = usorted (rev xs) === True ==> allsmall 1 xs === True ==> length xs <= 1 === True

unique :: [Int] -> Bool
unique []     = True
unique (x:xs) = if x `elem` xs then False else unique xs

remove :: Int -> [Int] -> [Int]
remove x [] = []
remove x (y:ys) = if x == y then ys else y:remove x ys

isort :: [Int] -> [Int]
isort [] = []
isort (x:xs) = insert x (isort xs)

insert :: Int -> [Int] -> [Int]
insert n [] = [n]
insert n (x:xs) =
  case n <= x of
    True -> n : x : xs
    False -> x : (insert n xs)

partition :: Int -> [Int] -> ([Int],[Int])
partition _ [] = ([],[])
partition p (x:xs) =
  case partition p xs of
    (ys,zs) ->
      case p <= x of
        True  -> (x:ys,zs)
        False -> (ys,x:zs)

singleton x = [x]

-- FLAGS: cqsort
qsort :: [Int] -> [Int]
qsort []     = []
qsort (p:xs) =
  case partition p xs of
    (ys,zs) -> qsort ys ++ (singleton p ++ qsort zs)

rev :: [a] -> [a]
rev []     = []
rev (x:xs) = rev xs ++ [x]

qrev :: [a] -> [a] -> [a]
qrev []     acc = acc
qrev (x:xs) acc = qrev xs (x:acc)

psorted      xs = sorted xs           === True ==> unique xs === True ==> length xs <= 3 === True
psorted_rev  xs = sorted (rev xs)     === True ==> unique xs === True ==> length xs <= 3 === True
psorted_qrev xs = sorted (qrev xs []) === True ==> unique xs === True ==> length xs <= 3 === True

pusorted      xs = usorted xs           === True ==> length xs <= 10 === True
pusorted_rev  xs = usorted (rev xs)     === True ==> length xs <= 9 === True
pusorted_qrev xs = usorted (qrev xs []) === True ==> length xs <= 4 === True

#define INJ(sort,name,num) name xs ys = sort xs === sort ys ==> length xs <= num === False ==> xs === ys
#define NUB(sort,name,num) name xs ys = sort xs === sort ys ==> length xs <= num === False ==> nub xs === xs ==> xs === ys
#define UNQ(sort,name,num) name xs ys = sort xs === sort ys ==> length xs <= num === False ==> unique xs === True ==> xs === ys

INJ(msort,minj0,0)
INJ(msort,minj1,1)
INJ(msort,minj2,2)
INJ(msort,minj3,3)
INJ(msort,minj4,4)
INJ(msort,minj5,5)
INJ(msort,minj6,6)
INJ(msort,minj7,7)
INJ(msort,minj8,8)
INJ(msort,minj9,9)
INJ(msort,minj10,10)
INJ(msort,minj11,11)
INJ(msort,minj12,12)
INJ(msort,minj13,13)
INJ(msort,minj14,14)
INJ(msort,minj15,15)
INJ(msort,minj16,16)
INJ(msort,minj17,17)
INJ(msort,minj18,18)
INJ(msort,minj19,19)
INJ(msort,minj20,20)
INJ(msort,minj21,21)
INJ(msort,minj22,22)
INJ(msort,minj23,23)
INJ(msort,minj24,24)
INJ(msort,minj25,25)
INJ(msort,minj26,26)
INJ(msort,minj27,27)
INJ(msort,minj28,28)
INJ(msort,minj29,29)

NUB(msort,mnub0,0)
NUB(msort,mnub1,1)
NUB(msort,mnub2,2)
NUB(msort,mnub3,3)
NUB(msort,mnub4,4)
NUB(msort,mnub5,5)
NUB(msort,mnub6,6)
NUB(msort,mnub7,7)
NUB(msort,mnub8,8)
NUB(msort,mnub9,9)
NUB(msort,mnub10,10)
NUB(msort,mnub11,11)
NUB(msort,mnub12,12)
NUB(msort,mnub13,13)
NUB(msort,mnub14,14)
NUB(msort,mnub15,15)
NUB(msort,mnub16,16)
NUB(msort,mnub17,17)
NUB(msort,mnub18,18)
NUB(msort,mnub19,19)
NUB(msort,mnub20,20)
NUB(msort,mnub21,21)
NUB(msort,mnub22,22)
NUB(msort,mnub23,23)
NUB(msort,mnub24,24)
NUB(msort,mnub25,25)
NUB(msort,mnub26,26)
NUB(msort,mnub27,27)
NUB(msort,mnub28,28)
NUB(msort,mnub29,29)

UNQ(msort,munq0,0)
UNQ(msort,munq1,1)
UNQ(msort,munq2,2)
UNQ(msort,munq3,3)
UNQ(msort,munq4,4)
UNQ(msort,munq5,5)
UNQ(msort,munq6,6)
UNQ(msort,munq7,7)
UNQ(msort,munq8,8)
UNQ(msort,munq9,9)
UNQ(msort,munq10,10)
UNQ(msort,munq11,11)
UNQ(msort,munq12,12)
UNQ(msort,munq13,13)
UNQ(msort,munq14,14)
UNQ(msort,munq15,15)
UNQ(msort,munq16,16)
UNQ(msort,munq17,17)
UNQ(msort,munq18,18)
UNQ(msort,munq19,19)
UNQ(msort,munq20,20)
UNQ(msort,munq21,21)
UNQ(msort,munq22,22)
UNQ(msort,munq23,23)
UNQ(msort,munq24,24)
UNQ(msort,munq25,25)
UNQ(msort,munq26,26)
UNQ(msort,munq27,27)
UNQ(msort,munq28,28)
UNQ(msort,munq29,29)

INJ(qsort,qinj0,0)
INJ(qsort,qinj1,1)
INJ(qsort,qinj2,2)
INJ(qsort,qinj3,3)
INJ(qsort,qinj4,4)
INJ(qsort,qinj5,5)
INJ(qsort,qinj6,6)
INJ(qsort,qinj7,7)
INJ(qsort,qinj8,8)
INJ(qsort,qinj9,9)
INJ(qsort,qinj10,10)
INJ(qsort,qinj11,11)
INJ(qsort,qinj12,12)
INJ(qsort,qinj13,13)
INJ(qsort,qinj14,14)
INJ(qsort,qinj15,15)
INJ(qsort,qinj16,16)
INJ(qsort,qinj17,17)
INJ(qsort,qinj18,18)
INJ(qsort,qinj19,19)
INJ(qsort,qinj20,20)
INJ(qsort,qinj21,21)
INJ(qsort,qinj22,22)
INJ(qsort,qinj23,23)
INJ(qsort,qinj24,24)
INJ(qsort,qinj25,25)
INJ(qsort,qinj26,26)
INJ(qsort,qinj27,27)
INJ(qsort,qinj28,28)
INJ(qsort,qinj29,29)

NUB(qsort,qnub0,0)
NUB(qsort,qnub1,1)
NUB(qsort,qnub2,2)
NUB(qsort,qnub3,3)
NUB(qsort,qnub4,4)
NUB(qsort,qnub5,5)
NUB(qsort,qnub6,6)
NUB(qsort,qnub7,7)
NUB(qsort,qnub8,8)
NUB(qsort,qnub9,9)
NUB(qsort,qnub10,10)
NUB(qsort,qnub11,11)
NUB(qsort,qnub12,12)
NUB(qsort,qnub13,13)
NUB(qsort,qnub14,14)
NUB(qsort,qnub15,15)
NUB(qsort,qnub16,16)
NUB(qsort,qnub17,17)
NUB(qsort,qnub18,18)
NUB(qsort,qnub19,19)
NUB(qsort,qnub20,20)
NUB(qsort,qnub21,21)
NUB(qsort,qnub22,22)
NUB(qsort,qnub23,23)
NUB(qsort,qnub24,24)
NUB(qsort,qnub25,25)
NUB(qsort,qnub26,26)
NUB(qsort,qnub27,27)
NUB(qsort,qnub28,28)
NUB(qsort,qnub29,29)

UNQ(qsort,qunq0,0)
UNQ(qsort,qunq1,1)
UNQ(qsort,qunq2,2)
UNQ(qsort,qunq3,3)
UNQ(qsort,qunq4,4)
UNQ(qsort,qunq5,5)
UNQ(qsort,qunq6,6)
UNQ(qsort,qunq7,7)
UNQ(qsort,qunq8,8)
UNQ(qsort,qunq9,9)
UNQ(qsort,qunq10,10)
UNQ(qsort,qunq11,11)
UNQ(qsort,qunq12,12)
UNQ(qsort,qunq13,13)
UNQ(qsort,qunq14,14)
UNQ(qsort,qunq15,15)
UNQ(qsort,qunq16,16)
UNQ(qsort,qunq17,17)
UNQ(qsort,qunq18,18)
UNQ(qsort,qunq19,19)
UNQ(qsort,qunq20,20)
UNQ(qsort,qunq21,21)
UNQ(qsort,qunq22,22)
UNQ(qsort,qunq23,23)
UNQ(qsort,qunq24,24)
UNQ(qsort,qunq25,25)
UNQ(qsort,qunq26,26)
UNQ(qsort,qunq27,27)
UNQ(qsort,qunq28,28)
UNQ(qsort,qunq29,29)

INJ(isort,iinj0,0)
INJ(isort,iinj1,1)
INJ(isort,iinj2,2)
INJ(isort,iinj3,3)
INJ(isort,iinj4,4)
INJ(isort,iinj5,5)
INJ(isort,iinj6,6)
INJ(isort,iinj7,7)
INJ(isort,iinj8,8)
INJ(isort,iinj9,9)
INJ(isort,iinj10,10)
INJ(isort,iinj11,11)
INJ(isort,iinj12,12)
INJ(isort,iinj13,13)
INJ(isort,iinj14,14)
INJ(isort,iinj15,15)
INJ(isort,iinj16,16)
INJ(isort,iinj17,17)
INJ(isort,iinj18,18)
INJ(isort,iinj19,19)
INJ(isort,iinj20,20)
INJ(isort,iinj21,21)
INJ(isort,iinj22,22)
INJ(isort,iinj23,23)
INJ(isort,iinj24,24)
INJ(isort,iinj25,25)
INJ(isort,iinj26,26)
INJ(isort,iinj27,27)
INJ(isort,iinj28,28)
INJ(isort,iinj29,29)

NUB(isort,inub0,0)
NUB(isort,inub1,1)
NUB(isort,inub2,2)
NUB(isort,inub3,3)
NUB(isort,inub4,4)
NUB(isort,inub5,5)
NUB(isort,inub6,6)
NUB(isort,inub7,7)
NUB(isort,inub8,8)
NUB(isort,inub9,9)
NUB(isort,inub10,10)
NUB(isort,inub11,11)
NUB(isort,inub12,12)
NUB(isort,inub13,13)
NUB(isort,inub14,14)
NUB(isort,inub15,15)
NUB(isort,inub16,16)
NUB(isort,inub17,17)
NUB(isort,inub18,18)
NUB(isort,inub19,19)
NUB(isort,inub20,20)
NUB(isort,inub21,21)
NUB(isort,inub22,22)
NUB(isort,inub23,23)
NUB(isort,inub24,24)
NUB(isort,inub25,25)
NUB(isort,inub26,26)
NUB(isort,inub27,27)
NUB(isort,inub28,28)
NUB(isort,inub29,29)

UNQ(isort,iunq0,0)
UNQ(isort,iunq1,1)
UNQ(isort,iunq2,2)
UNQ(isort,iunq3,3)
UNQ(isort,iunq4,4)
UNQ(isort,iunq5,5)
UNQ(isort,iunq6,6)
UNQ(isort,iunq7,7)
UNQ(isort,iunq8,8)
UNQ(isort,iunq9,9)
UNQ(isort,iunq10,10)
UNQ(isort,iunq11,11)
UNQ(isort,iunq12,12)
UNQ(isort,iunq13,13)
UNQ(isort,iunq14,14)
UNQ(isort,iunq15,15)
UNQ(isort,iunq16,16)
UNQ(isort,iunq17,17)
UNQ(isort,iunq18,18)
UNQ(isort,iunq19,19)
UNQ(isort,iunq20,20)
UNQ(isort,iunq21,21)
UNQ(isort,iunq22,22)
UNQ(isort,iunq23,23)
UNQ(isort,iunq24,24)
UNQ(isort,iunq25,25)
UNQ(isort,iunq26,26)
UNQ(isort,iunq27,27)
UNQ(isort,iunq28,28)
UNQ(isort,iunq29,29)


-- prop_cancel2 xs ys zs =
--         msort xs === zs
--      /\ msort ys === zs
--      /\ False === length xs <= five
--     ==> msort xs === xs
--      \/ msort ys === ys
--      \/ xs === ys

-- prop_msort_ord_not xs = ord (msort xs) === False
--
-- prop_msort_permutation_wrong1 xs x = count x xs <= five === False ==> count x xs === count (S x) (msort xs)
-- prop_msort_permutation_wrong2 xs x = count x xs <= five === False ==> count (S x) xs === count x (msort xs)


-- prop_atotal     a b = a <= b === True \/ b <= a === True
-- prop_atotal_not a b = a <= b === True /\ b <= a === True ==> True === False
--
-- -- prop_merge_ord      xs ys = ord xs === True  ==> ord ys === True  ==> ord (merge xs ys) === True
-- prop_merge_ord_not1 xs ys = ord xs === True  ==> ord ys === True  ==> ord (merge xs ys) === False
-- prop_merge_ord_not2 xs ys = ord xs === False ==> ord ys === True  ==> ord (merge xs ys) === True
-- prop_merge_ord_not3 xs ys = ord xs === True  ==> ord ys === False ==> ord (merge xs ys) === True
