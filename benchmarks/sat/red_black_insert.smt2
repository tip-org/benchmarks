; Red-Black trees in a functional setting, by Okasaki.
; (With invariants coded, and a fault injected to `balance`.)
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes () ((Colour (R) (B))))
(declare-datatypes (a)
  ((Tree (E)
     (T (T_0 Colour) (T_1 (Tree a)) (T_2 a) (T_3 (Tree a))))))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S n) (S (plus n y)))))
(define-fun
  (par (a)
    (makeBlack
       ((x (Tree a))) (Tree a)
       (match x
         (case E (as E (Tree a)))
         (case (T y c z b2) (T B c z b2))))))
(define-fun-rec
  lt
    ((x Nat) (y Nat)) Bool
    (match y
      (case Z false)
      (case (S z)
        (match x
          (case Z true)
          (case (S n) (lt n z))))))
(define-fun-rec
  le
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z true)
      (case (S z)
        (match y
          (case Z false)
          (case (S x2) (le z x2))))))
(define-fun
  isRed
    ((x Colour)) Bool
    (match x
      (case R true)
      (case B false)))
(define-fun-rec
  gt
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z false)
      (case (S z)
        (match y
          (case Z true)
          (case (S x2) (gt z x2))))))
(define-fun-rec
  ge
    ((x Nat) (y Nat)) Bool
    (match y
      (case Z true)
      (case (S z)
        (match x
          (case Z false)
          (case (S x2) (ge x2 z))))))
(define-fun
  (par (a b)
    (fst ((x (Pair a b))) a (match x (case (Pair2 y z) y)))))
(define-fun-rec
  equal
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z
        (match y
          (case Z true)
          (case (S z) false)))
      (case (S x2)
        (match y
          (case Z false)
          (case (S y2) (equal x2 y2))))))
(define-fun
  (par (t)
    (blackRoot
       ((x (Tree t))) Bool
       (match x
         (case E true)
         (case (T col b y c) (not (isRed col)))))))
(define-fun-rec
  (par (t)
    (red
       ((x (Tree t))) Bool
       (match x
         (case E true)
         (case (T col b y c)
           (ite
             (isRed col)
             (and (and (blackRoot b) (blackRoot c)) (and (red b) (red c)))
             (and (red b) (red c))))))))
(define-fun-rec
  (par (t)
    (black
       ((x (Tree t))) (Pair Bool Nat)
       (match x
         (case E (Pair2 true (S Z)))
         (case (T col a2 y b2)
           (match (black a2)
             (case (Pair2 b0 n)
               (match (black b2)
                 (case (Pair2 b1 m)
                   (ite
                     (isRed col) (Pair2 (and b0 (and b1 (equal n m))) (plus n Z))
                     (Pair2 (and b0 (and b1 (equal n m))) (plus n (S Z)))))))))))))
(define-fun (par (t) (black2 ((x (Tree t))) Bool (fst (black x)))))
(define-fun
  (par (a)
    (balance
       ((x Colour) (y (Tree a)) (z a) (x2 (Tree a))) (Tree a)
       (let ((x3 (T x y z x2)))
         (match x
           (case R x3)
           (case B
             (let
               ((x4
                   (match x2
                     (case E x3)
                     (case (T x5 x6 z2 d)
                       (match x5
                         (case R
                           (let
                             ((x7
                                 (match d
                                   (case E x3)
                                   (case (T x8 c z3 d2)
                                     (match x8
                                       (case R (T R (T B y z x6) z2 (T B c z3 d2)))
                                       (case B x3))))))
                             (match x6
                               (case E x7)
                               (case (T x9 c2 y2 b2)
                                 (match x9
                                   (case R (T R (T B y z b2) y2 (T B c2 z2 d)))
                                   (case B x7))))))
                         (case B x3))))))
               (match y
                 (case E x4)
                 (case (T x10 x11 y3 c3)
                   (match x10
                     (case R
                       (let
                         ((x12
                             (match c3
                               (case E x4)
                               (case (T x13 b3 y4 c4)
                                 (match x13
                                   (case R (T R (T B x11 y3 b3) y4 (T B c4 z x2)))
                                   (case B x4))))))
                         (match x11
                           (case E x12)
                           (case (T x14 a2 x15 b4)
                             (match x14
                               (case R (T R (T B a2 x15 b4) y3 (T B c3 z x2)))
                               (case B x12))))))
                     (case B x4)))))))))))
(define-fun-rec
  ins
    ((x Nat) (y (Tree Nat))) (Tree Nat)
    (match y
      (case E (T R (as E (Tree Nat)) x (as E (Tree Nat))))
      (case (T col b z c)
        (ite
          (lt x z) (balance col (ins x b) z c)
          (ite (gt x z) (balance col b z (ins x c)) y)))))
(define-fun
  insert2 ((x Nat) (y (Tree Nat))) (Tree Nat) (makeBlack (ins x y)))
(define-fun-rec
  allLe
    ((x Nat) (y (Tree Nat))) Bool
    (match y
      (case E true)
      (case (T z t0 b t1)
        (and (le b x) (and (allLe x t0) (allLe x t1))))))
(define-fun-rec
  allGe
    ((x Nat) (y (Tree Nat))) Bool
    (match y
      (case E true)
      (case (T z t0 b t1)
        (and (ge b x) (and (allGe x t0) (allGe x t1))))))
(define-fun-rec
  ord
    ((x (Tree Nat))) Bool
    (match x
      (case E true)
      (case (T y t0 b t1)
        (and (allLe b t0) (and (allGe b t1) (and (ord t0) (ord t1)))))))
(define-fun
  redBlack
    ((x (Tree Nat))) Bool (and (red x) (and (black2 x) (ord x))))
(assert-not
  (forall ((x Nat) (t (Tree Nat)))
    (=> (redBlack t) (redBlack (insert2 x t)))))
(check-sat)
