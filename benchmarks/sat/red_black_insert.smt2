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
           (let
             ((z (match (black a2) (case (Pair2 b0 n) (Pair2 b0 n))))
              (m (match z (case (Pair2 b02 o) o))))
             (match z
               (case (Pair2 b03 n2)
                 (match (black b2)
                   (case (Pair2 b1 m2)
                     (ite
                       (isRed col) (Pair2 (and b03 (and b1 (equal m m2))) (plus m Z))
                       (Pair2 (and b03 (and b1 (equal m m2))) (plus m (S Z))))))))))))))
(define-fun (par (t) (black2 ((x (Tree t))) Bool (fst (black x)))))
(define-fun
  (par (a)
    (balance
       ((x Colour) (y (Tree a)) (z a) (x2 (Tree a))) (Tree a)
       (match x
         (case R (T R y z x2))
         (case B
           (match y
             (case E
               (match x2
                 (case E (T B (as E (Tree a)) z (as E (Tree a))))
                 (case (T x3 x4 z2 d)
                   (match x3
                     (case R
                       (match x4
                         (case E
                           (match d
                             (case E
                               (T B (as E (Tree a)) z (T R (as E (Tree a)) z2 (as E (Tree a)))))
                             (case (T x5 c z3 d2)
                               (match x5
                                 (case R
                                   (T R (T B (as E (Tree a)) z (as E (Tree a))) z2 (T B c z3 d2)))
                                 (case B
                                   (T B
                                     (as E (Tree a)) z (T R (as E (Tree a)) z2 (T B c z3 d2))))))))
                         (case (T x6 c2 y2 b2)
                           (match x6
                             (case R (T R (T B (as E (Tree a)) z b2) y2 (T B c2 z2 d)))
                             (case B
                               (match d
                                 (case E
                                   (T B (as E (Tree a)) z (T R (T B c2 y2 b2) z2 (as E (Tree a)))))
                                 (case (T x7 c3 z4 d3)
                                   (match x7
                                     (case R
                                       (T R
                                         (T B (as E (Tree a)) z (T B c2 y2 b2)) z2 (T B c3 z4 d3)))
                                     (case B
                                       (T B
                                         (as E (Tree a)) z
                                         (T R (T B c2 y2 b2) z2 (T B c3 z4 d3))))))))))))
                     (case B (T B (as E (Tree a)) z (T B x4 z2 d)))))))
             (case (T x8 x9 y3 c4)
               (match x8
                 (case R
                   (match x9
                     (case E
                       (match c4
                         (case E
                           (match x2
                             (case E
                               (T B (T R (as E (Tree a)) y3 (as E (Tree a))) z (as E (Tree a))))
                             (case (T x10 x11 z5 d4)
                               (match x10
                                 (case R
                                   (match x11
                                     (case E
                                       (match d4
                                         (case E
                                           (T B
                                             (T R (as E (Tree a)) y3 (as E (Tree a))) z
                                             (T R (as E (Tree a)) z5 (as E (Tree a)))))
                                         (case (T x12 c5 z6 d5)
                                           (match x12
                                             (case R
                                               (T R
                                                 (T B
                                                   (T R (as E (Tree a)) y3 (as E (Tree a))) z
                                                   (as E (Tree a)))
                                                 z5 (T B c5 z6 d5)))
                                             (case B
                                               (T B
                                                 (T R (as E (Tree a)) y3 (as E (Tree a))) z
                                                 (T R (as E (Tree a)) z5 (T B c5 z6 d5))))))))
                                     (case (T x13 c6 y4 b3)
                                       (match x13
                                         (case R
                                           (T R
                                             (T B (T R (as E (Tree a)) y3 (as E (Tree a))) z b3) y4
                                             (T B c6 z5 d4)))
                                         (case B
                                           (match d4
                                             (case E
                                               (T B
                                                 (T R (as E (Tree a)) y3 (as E (Tree a))) z
                                                 (T R (T B c6 y4 b3) z5 (as E (Tree a)))))
                                             (case (T x14 c7 z7 d6)
                                               (match x14
                                                 (case R
                                                   (T R
                                                     (T B
                                                       (T R (as E (Tree a)) y3 (as E (Tree a))) z
                                                       (T B c6 y4 b3))
                                                     z5 (T B c7 z7 d6)))
                                                 (case B
                                                   (T B
                                                     (T R (as E (Tree a)) y3 (as E (Tree a))) z
                                                     (T R
                                                       (T B c6 y4 b3) z5 (T B c7 z7 d6))))))))))))
                                 (case B
                                   (T B
                                     (T R (as E (Tree a)) y3 (as E (Tree a))) z
                                     (T B x11 z5 d4)))))))
                         (case (T x15 b4 y5 c8)
                           (match x15
                             (case R (T R (T B (as E (Tree a)) y3 b4) y5 (T B c8 z x2)))
                             (case B
                               (match x2
                                 (case E
                                   (T B (T R (as E (Tree a)) y3 (T B b4 y5 c8)) z (as E (Tree a))))
                                 (case (T x16 x17 z8 d7)
                                   (match x16
                                     (case R
                                       (match x17
                                         (case E
                                           (match d7
                                             (case E
                                               (T B
                                                 (T R (as E (Tree a)) y3 (T B b4 y5 c8)) z
                                                 (T R (as E (Tree a)) z8 (as E (Tree a)))))
                                             (case (T x18 c9 z9 d8)
                                               (match x18
                                                 (case R
                                                   (T R
                                                     (T B
                                                       (T R (as E (Tree a)) y3 (T B b4 y5 c8)) z
                                                       (as E (Tree a)))
                                                     z8 (T B c9 z9 d8)))
                                                 (case B
                                                   (T B
                                                     (T R (as E (Tree a)) y3 (T B b4 y5 c8)) z
                                                     (T R (as E (Tree a)) z8 (T B c9 z9 d8))))))))
                                         (case (T x19 c10 y6 b5)
                                           (match x19
                                             (case R
                                               (T R
                                                 (T B (T R (as E (Tree a)) y3 (T B b4 y5 c8)) z b5)
                                                 y6 (T B c10 z8 d7)))
                                             (case B
                                               (match d7
                                                 (case E
                                                   (T B
                                                     (T R (as E (Tree a)) y3 (T B b4 y5 c8)) z
                                                     (T R (T B c10 y6 b5) z8 (as E (Tree a)))))
                                                 (case (T x20 c11 z10 d9)
                                                   (match x20
                                                     (case R
                                                       (T R
                                                         (T B
                                                           (T R (as E (Tree a)) y3 (T B b4 y5 c8)) z
                                                           (T B c10 y6 b5))
                                                         z8 (T B c11 z10 d9)))
                                                     (case B
                                                       (T B
                                                         (T R (as E (Tree a)) y3 (T B b4 y5 c8)) z
                                                         (T R
                                                           (T B c10 y6 b5) z8
                                                           (T B c11 z10 d9))))))))))))
                                     (case B
                                       (T B
                                         (T R (as E (Tree a)) y3 (T B b4 y5 c8)) z
                                         (T B x17 z8 d7)))))))))))
                     (case (T x21 a2 x22 b6)
                       (match x21
                         (case R (T R (T B a2 x22 b6) y3 (T B c4 z x2)))
                         (case B
                           (match c4
                             (case E
                               (match x2
                                 (case E
                                   (T B (T R (T B a2 x22 b6) y3 (as E (Tree a))) z (as E (Tree a))))
                                 (case (T x23 x24 z11 d10)
                                   (match x23
                                     (case R
                                       (match x24
                                         (case E
                                           (match d10
                                             (case E
                                               (T B
                                                 (T R (T B a2 x22 b6) y3 (as E (Tree a))) z
                                                 (T R (as E (Tree a)) z11 (as E (Tree a)))))
                                             (case (T x25 c12 z12 d11)
                                               (match x25
                                                 (case R
                                                   (T R
                                                     (T B
                                                       (T R (T B a2 x22 b6) y3 (as E (Tree a))) z
                                                       (as E (Tree a)))
                                                     z11 (T B c12 z12 d11)))
                                                 (case B
                                                   (T B
                                                     (T R (T B a2 x22 b6) y3 (as E (Tree a))) z
                                                     (T R
                                                       (as E (Tree a)) z11 (T B c12 z12 d11))))))))
                                         (case (T x26 c13 y7 b7)
                                           (match x26
                                             (case R
                                               (T R
                                                 (T B (T R (T B a2 x22 b6) y3 (as E (Tree a))) z b7)
                                                 y7 (T B c13 z11 d10)))
                                             (case B
                                               (match d10
                                                 (case E
                                                   (T B
                                                     (T R (T B a2 x22 b6) y3 (as E (Tree a))) z
                                                     (T R (T B c13 y7 b7) z11 (as E (Tree a)))))
                                                 (case (T x27 c14 z13 d12)
                                                   (match x27
                                                     (case R
                                                       (T R
                                                         (T B
                                                           (T R (T B a2 x22 b6) y3 (as E (Tree a)))
                                                           z (T B c13 y7 b7))
                                                         z11 (T B c14 z13 d12)))
                                                     (case B
                                                       (T B
                                                         (T R (T B a2 x22 b6) y3 (as E (Tree a))) z
                                                         (T R
                                                           (T B c13 y7 b7) z11
                                                           (T B c14 z13 d12))))))))))))
                                     (case B
                                       (T B
                                         (T R (T B a2 x22 b6) y3 (as E (Tree a))) z
                                         (T B x24 z11 d10)))))))
                             (case (T x28 b8 y8 c15)
                               (match x28
                                 (case R (T R (T B (T B a2 x22 b6) y3 b8) y8 (T B c15 z x2)))
                                 (case B
                                   (match x2
                                     (case E
                                       (T B
                                         (T R (T B a2 x22 b6) y3 (T B b8 y8 c15)) z
                                         (as E (Tree a))))
                                     (case (T x29 x30 z14 d13)
                                       (match x29
                                         (case R
                                           (match x30
                                             (case E
                                               (match d13
                                                 (case E
                                                   (T B
                                                     (T R (T B a2 x22 b6) y3 (T B b8 y8 c15)) z
                                                     (T R (as E (Tree a)) z14 (as E (Tree a)))))
                                                 (case (T x31 c16 z15 d14)
                                                   (match x31
                                                     (case R
                                                       (T R
                                                         (T B
                                                           (T R (T B a2 x22 b6) y3 (T B b8 y8 c15))
                                                           z (as E (Tree a)))
                                                         z14 (T B c16 z15 d14)))
                                                     (case B
                                                       (T B
                                                         (T R (T B a2 x22 b6) y3 (T B b8 y8 c15)) z
                                                         (T R
                                                           (as E (Tree a)) z14
                                                           (T B c16 z15 d14))))))))
                                             (case (T x32 c17 y9 b9)
                                               (match x32
                                                 (case R
                                                   (T R
                                                     (T B
                                                       (T R (T B a2 x22 b6) y3 (T B b8 y8 c15)) z
                                                       b9)
                                                     y9 (T B c17 z14 d13)))
                                                 (case B
                                                   (match d13
                                                     (case E
                                                       (T B
                                                         (T R (T B a2 x22 b6) y3 (T B b8 y8 c15)) z
                                                         (T R (T B c17 y9 b9) z14 (as E (Tree a)))))
                                                     (case (T x33 c18 z16 d15)
                                                       (match x33
                                                         (case R
                                                           (T R
                                                             (T B
                                                               (T R
                                                                 (T B a2 x22 b6) y3 (T B b8 y8 c15))
                                                               z (T B c17 y9 b9))
                                                             z14 (T B c18 z16 d15)))
                                                         (case B
                                                           (T B
                                                             (T R
                                                               (T B a2 x22 b6) y3 (T B b8 y8 c15))
                                                             z
                                                             (T R
                                                               (T B c17 y9 b9) z14
                                                               (T B c18 z16 d15))))))))))))
                                         (case B
                                           (T B
                                             (T R (T B a2 x22 b6) y3 (T B b8 y8 c15)) z
                                             (T B x30 z14 d13)))))))))))))))
                 (case B
                   (match x2
                     (case E (T B (T B x9 y3 c4) z (as E (Tree a))))
                     (case (T x34 x35 z17 d16)
                       (match x34
                         (case R
                           (match x35
                             (case E
                               (match d16
                                 (case E
                                   (T B (T B x9 y3 c4) z (T R (as E (Tree a)) z17 (as E (Tree a)))))
                                 (case (T x36 c19 z18 d17)
                                   (match x36
                                     (case R
                                       (T R
                                         (T B (T B x9 y3 c4) z (as E (Tree a))) z17
                                         (T B c19 z18 d17)))
                                     (case B
                                       (T B
                                         (T B x9 y3 c4) z
                                         (T R (as E (Tree a)) z17 (T B c19 z18 d17))))))))
                             (case (T x37 c20 y10 b10)
                               (match x37
                                 (case R (T R (T B (T B x9 y3 c4) z b10) y10 (T B c20 z17 d16)))
                                 (case B
                                   (match d16
                                     (case E
                                       (T B
                                         (T B x9 y3 c4) z
                                         (T R (T B c20 y10 b10) z17 (as E (Tree a)))))
                                     (case (T x38 c21 z19 d18)
                                       (match x38
                                         (case R
                                           (T R
                                             (T B (T B x9 y3 c4) z (T B c20 y10 b10)) z17
                                             (T B c21 z19 d18)))
                                         (case B
                                           (T B
                                             (T B x9 y3 c4) z
                                             (T R (T B c20 y10 b10) z17 (T B c21 z19 d18))))))))))))
                         (case B (T B (T B x9 y3 c4) z (T B x35 z17 d16)))))))))))))))
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
