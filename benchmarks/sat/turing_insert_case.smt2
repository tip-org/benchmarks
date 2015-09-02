(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b c)
  ((Triple (Triple2 (Triple_0 a) (Triple_1 b) (Triple_2 c)))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes () ((Nat (Zero) (Succ (pred Nat)))))
(declare-datatypes (a b)
  ((Either (Left (Left_0 a)) (Right (Right_0 b)))))
(declare-datatypes ()
  ((Action (Lft (Lft_0 Nat)) (Rgt (Rgt_0 Nat)) (Stp))))
(declare-datatypes () ((A (O) (A2) (B))))
(define-fun
  split
    ((x (list A))) (Pair A (list A))
    (match x
      (case nil (Pair2 O (as nil (list A))))
      (case (cons y xs) (Pair2 y xs))))
(define-fun-rec
  rev
    ((x (list A)) (y (list A))) (list A)
    (match x
      (case nil y)
      (case (cons z xs)
        (match z
          (case default (rev xs (cons z y)))
          (case O y)))))
(define-fun
  eqA
    ((x A) (y A)) Bool
    (match x
      (case O
        (match y
          (case default false)
          (case O true)))
      (case A2
        (match y
          (case default false)
          (case A2 true)))
      (case B
        (match y
          (case default false)
          (case B true)))))
(define-fun-rec
  eqT
    ((x (Pair Nat A)) (y (Pair Nat A))) Bool
    (match x
      (case (Pair2 z c)
        (match z
          (case Zero
            (match y
              (case (Pair2 x2 b2)
                (match x2
                  (case Zero (eqA c b2))
                  (case (Succ x3) false)))))
          (case (Succ p)
            (match y
              (case (Pair2 x4 b3)
                (match x4
                  (case Zero false)
                  (case (Succ q) (eqT (Pair2 p c) (Pair2 q b3)))))))))))
(define-fun-rec
  apply
    ((x (list (Pair (Pair Nat A) (Pair A Action)))) (y (Pair Nat A)))
    (Pair A Action)
    (match x
      (case nil (Pair2 O Stp))
      (case (cons z q)
        (match z (case (Pair2 sa rhs) (ite (eqT sa y) rhs (apply q y)))))))
(define-fun
  act
    ((x Action) (y (list A)) (z A) (x2 (list A)))
    (Either (list A) (Triple Nat (list A) (list A)))
    (match x
      (case (Lft s)
        (match (split y)
          (case (Pair2 y2 lft)
            (as (Right (Triple2 s lft (cons y2 (cons z x2))))
              (Either (list A) (Triple Nat (list A) (list A)))))))
      (case (Rgt s2)
        (as (Right (Triple2 s2 (cons z y) x2))
          (Either (list A) (Triple Nat (list A) (list A)))))
      (case Stp
        (as (Left (rev y (cons z x2)))
          (Either (list A) (Triple Nat (list A) (list A)))))))
(define-fun
  step
    ((x (list (Pair (Pair Nat A) (Pair A Action))))
     (y (Triple Nat (list A) (list A))))
    (Either (list A) (Triple Nat (list A) (list A)))
    (match y
      (case (Triple2 s lft rgt)
        (match (match (split rgt) (case (Pair2 z rgt2) (Pair2 z rgt2)))
          (case (Pair2 x2 rgt3)
            (match (apply x (Pair2 s x2))
              (case (Pair2 x3 what) (act what lft x3 rgt3))))))))
(define-fun-rec
  steps
    ((x (list (Pair (Pair Nat A) (Pair A Action))))
     (y (Triple Nat (list A) (list A))))
    (list A)
    (match (step x y)
      (case (Left tape) tape)
      (case (Right st) (steps x st))))
(define-fun
  runt
    ((x (list (Pair (Pair Nat A) (Pair A Action)))) (y (list A)))
    (list A) (steps x (Triple2 Zero (as nil (list A)) y)))
(define-fun
  prog0
    ((x (list (Pair (Pair Nat A) (Pair A Action))))) Bool
    (match (runt x (cons A2 (as nil (list A))))
      (case nil false)
      (case (cons y z)
        (match y
          (case default false)
          (case A2
            (match z
              (case nil
                (match
                  (runt x
                    (cons B
                      (cons A2
                        (cons A2 (cons A2 (cons A2 (cons B (as nil (list A)))))))))
                  (case nil false)
                  (case (cons x2 x3)
                    (match x2
                      (case default false)
                      (case A2
                        (match x3
                          (case nil false)
                          (case (cons x4 x5)
                            (match x4
                              (case default false)
                              (case A2
                                (match x5
                                  (case nil false)
                                  (case (cons x6 x7)
                                    (match x6
                                      (case default false)
                                      (case A2
                                        (match x7
                                          (case nil false)
                                          (case (cons x8 x9)
                                            (match x8
                                              (case default false)
                                              (case A2
                                                (match x9
                                                  (case nil false)
                                                  (case (cons x10 x11)
                                                    (match x10
                                                      (case default false)
                                                      (case B
                                                        (match x11
                                                          (case nil false)
                                                          (case (cons x12 x13)
                                                            (match x12
                                                              (case default false)
                                                              (case B
                                                                (match x13
                                                                  (case nil true)
                                                                  (case (cons x14 x15)
                                                                    false)))))))))))))))))))))))))))
              (case (cons x16 x17) false)))))))
(assert-not
  (forall ((q (list (Pair (Pair Nat A) (Pair A Action)))))
    (not (prog0 q))))
(check-sat)
