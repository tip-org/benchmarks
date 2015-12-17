{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE ImplicitParams #-}
{-# LANGUAGE RankNTypes #-}
module Main where
import qualified Text.Show.Functions
import qualified Data.Typeable as T
import qualified Prelude as P
import qualified System.Environment as Env
import qualified Test.LazySmallCheck as L
data List a = Nil | Cons a (List a)
  deriving (P.Eq, P.Ord, P.Show, T.Typeable)
instance (L.Serial a) => L.Serial (List a) where
  series =
    (L.cons Nil) L.\/ (((L.cons Cons) L.>< L.series) L.>< L.series)
data Pair b c = Pair2 b c
  deriving (P.Eq, P.Ord, P.Show, T.Typeable)
instance (L.Serial b, L.Serial c) => L.Serial (Pair b c) where
  series = ((L.cons Pair2) L.>< L.series) L.>< L.series
data Object =
  O1 | O2 | O3 | O4 | O5 | O6 | O7 | O8 | O9 | O10 | O11 | O12
  deriving (P.Eq, P.Ord, P.Show, T.Typeable)
instance L.Serial Object where
  series =
    (L.cons O1) L.\/
      ((L.cons O2) L.\/
         ((L.cons O3) L.\/
            ((L.cons O4) L.\/
               ((L.cons O5) L.\/
                  ((L.cons O6) L.\/
                     ((L.cons O7) L.\/
                        ((L.cons O8) L.\/
                           ((L.cons O9) L.\/
                              ((L.cons O10) L.\/ ((L.cons O11) L.\/ (L.cons O12)))))))))))
data Schema =
  Answer P.Bool Object |
  Weigh (List Object) (List Object) Schema Schema Schema
  deriving (P.Eq, P.Ord, P.Show, T.Typeable)
instance L.Serial Schema where
  series =
    (((L.cons Answer) L.>< L.series) L.>< L.series) L.\/
      ((((((L.cons Weigh) L.>< L.series) L.>< L.series) L.><
           L.series) L.><
          L.series) L.><
         L.series)
data Nat = Z | S Nat deriving (P.Eq, P.Ord, P.Show, T.Typeable)
instance L.Serial Nat where
  series = (L.cons Z) L.\/ ((L.cons S) L.>< L.series)
(~~) :: Object -> Object -> P.Bool
O1 ~~ y =
  case y of
    O1 -> P.True
    _ -> P.False
O2 ~~ y =
  case y of
    O2 -> P.True
    _ -> P.False
O3 ~~ y =
  case y of
    O3 -> P.True
    _ -> P.False
O4 ~~ y =
  case y of
    O4 -> P.True
    _ -> P.False
O5 ~~ y =
  case y of
    O5 -> P.True
    _ -> P.False
O6 ~~ y =
  case y of
    O6 -> P.True
    _ -> P.False
O7 ~~ y =
  case y of
    O7 -> P.True
    _ -> P.False
O8 ~~ y =
  case y of
    O8 -> P.True
    _ -> P.False
O9 ~~ y =
  case y of
    O9 -> P.True
    _ -> P.False
O10 ~~ y =
  case y of
    O10 -> P.True
    _ -> P.False
O11 ~~ y =
  case y of
    O11 -> P.True
    _ -> P.False
O12 ~~ y =
  case y of
    O12 -> P.True
    _ -> P.False
property O1 y =
  case y of
    O1 -> L.lift P.True
    _ -> L.lift P.False
property O2 y =
  case y of
    O2 -> L.lift P.True
    _ -> L.lift P.False
property O3 y =
  case y of
    O3 -> L.lift P.True
    _ -> L.lift P.False
property O4 y =
  case y of
    O4 -> L.lift P.True
    _ -> L.lift P.False
property O5 y =
  case y of
    O5 -> L.lift P.True
    _ -> L.lift P.False
property O6 y =
  case y of
    O6 -> L.lift P.True
    _ -> L.lift P.False
property O7 y =
  case y of
    O7 -> L.lift P.True
    _ -> L.lift P.False
property O8 y =
  case y of
    O8 -> L.lift P.True
    _ -> L.lift P.False
property O9 y =
  case y of
    O9 -> L.lift P.True
    _ -> L.lift P.False
property O10 y =
  case y of
    O10 -> L.lift P.True
    _ -> L.lift P.False
property O11 y =
  case y of
    O11 -> L.lift P.True
    _ -> L.lift P.False
property O12 y =
  case y of
    O12 -> L.lift P.True
    _ -> L.lift P.False
weigh ::
  P.Bool ->
    Object ->
      List Object -> List Object -> Schema -> Schema -> Schema -> Schema
weigh x z Nil x2 x3 x4 x5 = x4
weigh x z (Cons b2 as2) Nil x3 x4 x5 = x4
weigh x z (Cons b2 as2) (Cons c2 bs) x3 x4 x5 =
  case z ~~ b2 of
    P.True ->
      case x of
        P.True -> x3
        P.False -> x5
    P.False ->
      case z ~~ c2 of
        P.True ->
          case x of
            P.True -> x5
            P.False -> x3
        P.False -> weigh x z as2 bs x3 x4 x5
sameSize :: List a2 -> List a2 -> P.Bool
sameSize Nil Nil = P.True
sameSize Nil (Cons z2 x22) = P.False
sameSize (Cons x32 xs) Nil = P.False
sameSize (Cons x32 xs) (Cons x42 ys) = sameSize xs ys
propertysameSize Nil Nil = L.lift P.True
propertysameSize Nil (Cons z2 x22) = L.lift P.False
propertysameSize (Cons x32 xs) Nil = L.lift P.False
propertysameSize (Cons x32 xs) (Cons x42 ys) =
  propertysameSize xs ys
len :: List a3 -> Nat -> P.Bool
len Nil y2 = P.True
len (Cons z3 zs) Z = P.False
len (Cons z3 zs) (S n) = len zs n
propertylen Nil y2 = L.lift P.True
propertylen (Cons z3 zs) Z = L.lift P.False
propertylen (Cons z3 zs) (S n) = propertylen zs n
le :: Object -> Object -> P.Bool
le x6 y3 =
  case x6 of
    O1 -> P.True
    _ ->
      case y3 of
        O1 -> P.False
        _ ->
          case x6 of
            O2 -> P.True
            _ ->
              case y3 of
                O2 -> P.False
                _ ->
                  case x6 of
                    O3 -> P.True
                    _ ->
                      case y3 of
                        O3 -> P.False
                        _ ->
                          case x6 of
                            O4 -> P.True
                            _ ->
                              case y3 of
                                O4 -> P.False
                                _ ->
                                  case x6 of
                                    O5 -> P.True
                                    _ ->
                                      case y3 of
                                        O5 -> P.False
                                        _ ->
                                          case x6 of
                                            O6 -> P.True
                                            _ ->
                                              case y3 of
                                                O6 -> P.False
                                                _ ->
                                                  case x6 of
                                                    O7 -> P.True
                                                    _ ->
                                                      case y3 of
                                                        O7 -> P.False
                                                        _ ->
                                                          case x6 of
                                                            O8 -> P.True
                                                            _ ->
                                                              case y3 of
                                                                O8 -> P.False
                                                                _ ->
                                                                  case x6 of
                                                                    O9 -> P.True
                                                                    _ ->
                                                                      case y3 of
                                                                        O9 -> P.False
                                                                        _ ->
                                                                          case x6 of
                                                                            O10 -> P.True
                                                                            _ ->
                                                                              case y3 of
                                                                                O10 -> P.False
                                                                                _ ->
                                                                                  case x6 of
                                                                                    O11 -> P.True
                                                                                    _ ->
                                                                                      case y3 of
                                                                                        O11 ->
                                                                                          P.False
                                                                                        _ -> P.True
propertyle x6 y3 =
  case x6 of
    O1 -> L.lift P.True
    _ ->
      case y3 of
        O1 -> L.lift P.False
        _ ->
          case x6 of
            O2 -> L.lift P.True
            _ ->
              case y3 of
                O2 -> L.lift P.False
                _ ->
                  case x6 of
                    O3 -> L.lift P.True
                    _ ->
                      case y3 of
                        O3 -> L.lift P.False
                        _ ->
                          case x6 of
                            O4 -> L.lift P.True
                            _ ->
                              case y3 of
                                O4 -> L.lift P.False
                                _ ->
                                  case x6 of
                                    O5 -> L.lift P.True
                                    _ ->
                                      case y3 of
                                        O5 -> L.lift P.False
                                        _ ->
                                          case x6 of
                                            O6 -> L.lift P.True
                                            _ ->
                                              case y3 of
                                                O6 -> L.lift P.False
                                                _ ->
                                                  case x6 of
                                                    O7 -> L.lift P.True
                                                    _ ->
                                                      case y3 of
                                                        O7 -> L.lift P.False
                                                        _ ->
                                                          case x6 of
                                                            O8 -> L.lift P.True
                                                            _ ->
                                                              case y3 of
                                                                O8 -> L.lift P.False
                                                                _ ->
                                                                  case x6 of
                                                                    O9 -> L.lift P.True
                                                                    _ ->
                                                                      case y3 of
                                                                        O9 -> L.lift P.False
                                                                        _ ->
                                                                          case x6 of
                                                                            O10 -> L.lift P.True
                                                                            _ ->
                                                                              case y3 of
                                                                                O10 ->
                                                                                  L.lift P.False
                                                                                _ ->
                                                                                  case x6 of
                                                                                    O11 ->
                                                                                      L.lift P.True
                                                                                    _ ->
                                                                                      case y3 of
                                                                                        O11 ->
                                                                                          L.lift
                                                                                            P.False
                                                                                        _ ->
                                                                                          L.lift
                                                                                            P.True
lt :: Object -> Object -> P.Bool
lt x7 y4 = P.not (le y4 x7)
propertylt x7 y4 = L.neg (propertyle y4 x7)
usorted :: List Object -> P.Bool
usorted Nil = P.True
usorted (Cons y5 Nil) = P.True
usorted (Cons y5 (Cons y22 xs2)) =
  (lt y5 y22) P.&& (usorted (Cons y22 xs2))
propertyusorted Nil = L.lift P.True
propertyusorted (Cons y5 Nil) = L.lift P.True
propertyusorted (Cons y5 (Cons y22 xs2)) =
  (propertylt y5 y22) L.*&* (propertyusorted (Cons y22 xs2))
disjoint :: List Object -> List Object -> P.Bool
disjoint Nil y6 = P.True
disjoint (Cons z4 xs3) Nil = P.True
disjoint (Cons z4 xs3) (Cons y23 ys2) =
  case le z4 y23 of
    P.True -> (P.not (le y23 z4)) P.&& (disjoint xs3 (Cons y23 ys2))
    P.False -> disjoint (Cons z4 xs3) ys2
propertydisjoint Nil y6 = L.lift P.True
propertydisjoint (Cons z4 xs3) Nil = L.lift P.True
propertydisjoint (Cons z4 xs3) (Cons y23 ys2) =
  case le z4 y23 of
    P.True ->
      (L.neg (propertyle y23 z4)) L.*&*
        (propertydisjoint xs3 (Cons y23 ys2))
    P.False -> propertydisjoint (Cons z4 xs3) ys2
isFine :: Schema -> P.Bool
isFine (Answer y7 z5) = P.True
isFine (Weigh xs4 ys3 q q2 r) =
  (len xs4 (S (S (S (S Z))))) P.&&
    ((len ys3 (S (S (S (S Z))))) P.&&
       ((usorted xs4) P.&&
          ((usorted ys3) P.&&
             ((disjoint xs4 ys3) P.&&
                ((sameSize xs4 ys3) P.&&
                   ((isFine q) P.&& ((isFine q2) P.&& (isFine r))))))))
propertyisFine (Answer y7 z5) = L.lift P.True
propertyisFine (Weigh xs4 ys3 q q2 r) =
  (propertylen xs4 (S (S (S (S Z))))) L.*&*
    ((propertylen ys3 (S (S (S (S Z))))) L.*&*
       ((propertyusorted xs4) L.*&*
          ((propertyusorted ys3) L.*&*
             ((propertydisjoint xs4 ys3) L.*&*
                ((propertysameSize xs4 ys3) L.*&*
                   ((propertyisFine q) L.*&*
                      ((propertyisFine q2) L.*&* (propertyisFine r))))))))
depth :: Nat -> Schema -> P.Bool
depth Z (Answer z6 x23) = P.True
depth Z (Weigh x33 x43 x52 x62 x72) = P.False
depth (S m) (Answer x8 x9) = P.False
depth (S m) (Weigh x10 x11 p q22 r2) =
  (depth m p) P.&& ((depth m q22) P.&& (depth m r2))
propertydepth Z (Answer z6 x23) = L.lift P.True
propertydepth Z (Weigh x33 x43 x52 x62 x72) = L.lift P.False
propertydepth (S m) (Answer x8 x9) = L.lift P.False
propertydepth (S m) (Weigh x10 x11 p q22 r2) =
  (propertydepth m p) L.*&*
    ((propertydepth m q22) L.*&* (propertydepth m r2))
allCases :: List (Pair P.Bool Object)
allCases =
  Cons
    (Pair2 P.False O1)
    (Cons
       (Pair2 P.False O2)
       (Cons
          (Pair2 P.False O3)
          (Cons
             (Pair2 P.False O4)
             (Cons
                (Pair2 P.False O5)
                (Cons
                   (Pair2 P.False O6)
                   (Cons
                      (Pair2 P.False O7)
                      (Cons
                         (Pair2 P.False O8)
                         (Cons
                            (Pair2 P.False O9)
                            (Cons
                               (Pair2 P.False O10)
                               (Cons
                                  (Pair2 P.False O11)
                                  (Cons
                                     (Pair2 P.False O12)
                                     (Cons
                                        (Pair2 P.True O1)
                                        (Cons
                                           (Pair2 P.True O2)
                                           (Cons
                                              (Pair2 P.True O3)
                                              (Cons
                                                 (Pair2 P.True O4)
                                                 (Cons
                                                    (Pair2 P.True O5)
                                                    (Cons
                                                       (Pair2 P.True O6)
                                                       (Cons
                                                          (Pair2 P.True O7)
                                                          (Cons
                                                             (Pair2 P.True O8)
                                                             (Cons
                                                                (Pair2 P.True O9)
                                                                (Cons
                                                                   (Pair2 P.True O10)
                                                                   (Cons
                                                                      (Pair2 P.True O11)
                                                                      (Cons
                                                                         (Pair2 P.True O12)
                                                                         (Nil ::
                                                                            List
                                                                              (Pair
                                                                                 P.Bool
                                                                                 Object)))))))))))))))))))))))))
(=~) :: P.Bool -> P.Bool -> P.Bool
P.True =~ y8 = y8
P.False =~ y8 = P.not y8
property2 P.True y8 = L.lift y8
property2 P.False y8 = L.neg (L.lift y8)
solves :: Schema -> P.Bool -> Object -> P.Bool
solves (Answer hx x24) y9 z7 = (hx =~ y9) P.&& (x24 ~~ z7)
solves (Weigh xs5 ys4 q3 q23 r3) y9 z7 =
  solves (weigh y9 z7 xs5 ys4 q3 q23 r3) y9 z7
propertysolves (Answer hx x24) y9 z7 =
  (property2 hx y9) L.*&* (property x24 z7)
propertysolves (Weigh xs5 ys4 q3 q23 r3) y9 z7 =
  propertysolves (weigh y9 z7 xs5 ys4 q3 q23 r3) y9 z7
solvesAll :: Schema -> List (Pair P.Bool Object) -> P.Bool
solvesAll x12 Nil = P.True
solvesAll x12 (Cons (Pair2 h o) css) =
  (solves x12 h o) P.&& (solvesAll x12 css)
propertysolvesAll x12 Nil = L.lift P.True
propertysolvesAll x12 (Cons (Pair2 h o) css) =
  (propertysolves x12 h o) L.*&* (propertysolvesAll x12 css)
isSolution :: Schema -> P.Bool
isSolution x13 = (isFine x13) P.&& (solvesAll x13 allCases)
propertyisSolution x13 =
  (propertyisFine x13) L.*&* (propertysolvesAll x13 allCases)
prop :: Schema -> L.Property
prop s =
  (L.neg (propertydepth (S (S (S Z))) s)) L.*|*
    (L.neg (propertyisSolution s))
main =
  do args <- Env.getArgs
     L.test prop
