(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes ()
  ((Object (O1)
     (O2) (O3) (O4) (O5) (O6) (O7) (O8) (O9) (O10) (O11) (O12))))
(declare-datatypes ()
  ((Schema (Answer (Answer_0 Bool) (Answer_1 Object))
     (Weigh (Weigh_0 (list Object))
       (Weigh_1 (list Object)) (Weigh_2 Schema) (Weigh_3 Schema)
       (Weigh_4 Schema)))))
(define-fun
  ~~
    ((x Object) (y Object)) Bool
    (match x
      (case O1
        (match y
          (case default false)
          (case O1 true)))
      (case O2
        (match y
          (case default false)
          (case O2 true)))
      (case O3
        (match y
          (case default false)
          (case O3 true)))
      (case O4
        (match y
          (case default false)
          (case O4 true)))
      (case O5
        (match y
          (case default false)
          (case O5 true)))
      (case O6
        (match y
          (case default false)
          (case O6 true)))
      (case O7
        (match y
          (case default false)
          (case O7 true)))
      (case O8
        (match y
          (case default false)
          (case O8 true)))
      (case O9
        (match y
          (case default false)
          (case O9 true)))
      (case O10
        (match y
          (case default false)
          (case O10 true)))
      (case O11
        (match y
          (case default false)
          (case O11 true)))
      (case O12
        (match y
          (case default false)
          (case O12 true)))))
(define-fun-rec
  weigh
    ((x Bool) (y Object) (z (list Object)) (x2 (list Object))
     (x3 Schema) (x4 Schema) (x5 Schema))
    Schema
    (match z
      (case nil x4)
      (case (cons b bs)
        (match x2
          (case nil x4)
          (case (cons c cs)
            (ite
              (~~ y b) (ite x x3 x5)
              (ite (~~ y c) (ite x x5 x3) (weigh x y bs cs x3 x4 x5))))))))
(define-fun
  le
    ((x Object) (y Object)) Bool
    (match x
      (case default
        (match y
          (case default
            (match x
              (case default
                (match y
                  (case default
                    (match x
                      (case default
                        (match y
                          (case default
                            (match x
                              (case default
                                (match y
                                  (case default
                                    (match x
                                      (case default
                                        (match y
                                          (case default
                                            (match x
                                              (case default
                                                (match y
                                                  (case default
                                                    (match x
                                                      (case default
                                                        (match y
                                                          (case default
                                                            (match x
                                                              (case default
                                                                (match y
                                                                  (case default
                                                                    (match x
                                                                      (case default
                                                                        (match y
                                                                          (case default
                                                                            (match x
                                                                              (case default
                                                                                (match y
                                                                                  (case default
                                                                                    (match x
                                                                                      (case default
                                                                                        (match y
                                                                                          (case
                                                                                            default
                                                                                            true)
                                                                                          (case O11
                                                                                            false)))
                                                                                      (case O11
                                                                                        true)))
                                                                                  (case O10 false)))
                                                                              (case O10 true)))
                                                                          (case O9 false)))
                                                                      (case O9 true)))
                                                                  (case O8 false)))
                                                              (case O8 true)))
                                                          (case O7 false)))
                                                      (case O7 true)))
                                                  (case O6 false)))
                                              (case O6 true)))
                                          (case O5 false)))
                                      (case O5 true)))
                                  (case O4 false)))
                              (case O4 true)))
                          (case O3 false)))
                      (case O3 true)))
                  (case O2 false)))
              (case O2 true)))
          (case O1 false)))
      (case O1 true)))
(define-fun lt ((x Object) (y Object)) Bool (not (le y x)))
(define-fun-rec
  usorted
    ((x (list Object))) Bool
    (match x
      (case nil true)
      (case (cons y z)
        (match z
          (case nil true)
          (case (cons y2 xs) (and (lt y y2) (usorted z)))))))
(define-fun-rec
  disjoint
    ((x (list Object)) (y (list Object))) Bool
    (match x
      (case nil true)
      (case (cons z xs)
        (match y
          (case nil true)
          (case (cons y2 ys)
            (ite
              (le z y2) (and (not (le y2 z)) (disjoint xs y))
              (disjoint x ys)))))))
(define-fun-rec
  isFine
    ((x Schema)) Bool
    (match x
      (case (Answer y z) true)
      (case (Weigh xs ys p q r)
        (and (usorted xs)
          (and (usorted ys)
            (and (disjoint xs ys)
              (and (isFine p) (and (isFine q) (isFine r)))))))))
(define-fun
  allCases
    () (list (Pair Bool Object))
    (cons (Pair2 false O1)
      (cons (Pair2 false O2)
        (cons (Pair2 false O3)
          (cons (Pair2 false O4)
            (cons (Pair2 false O5)
              (cons (Pair2 false O6)
                (cons (Pair2 false O7)
                  (cons (Pair2 false O8)
                    (cons (Pair2 false O9)
                      (cons (Pair2 false O10)
                        (cons (Pair2 false O11)
                          (cons (Pair2 false O12)
                            (cons (Pair2 true O1)
                              (cons (Pair2 true O2)
                                (cons (Pair2 true O3)
                                  (cons (Pair2 true O4)
                                    (cons (Pair2 true O5)
                                      (cons (Pair2 true O6)
                                        (cons (Pair2 true O7)
                                          (cons (Pair2 true O8)
                                            (cons (Pair2 true O9)
                                              (cons (Pair2 true O10)
                                                (cons (Pair2 true O11)
                                                  (cons (Pair2 true O12)
                                                    (as nil
                                                      (list
                                                        (Pair
                                                          Bool Object))))))))))))))))))))))))))))
(define-fun =~ ((x Bool) (y Bool)) Bool (ite x y (not y)))
(define-fun-rec
  solves
    ((x Schema) (y Bool) (z Object)) Bool
    (match x
      (case (Answer hx x2) (and (=~ hx y) (~~ x2 z)))
      (case (Weigh xs ys p q r) (solves (weigh y z xs ys p q r) y z))))
(define-fun-rec
  solvesAll
    ((x Schema) (y (list (Pair Bool Object)))) Bool
    (match y
      (case nil true)
      (case (cons z css)
        (match z
          (case (Pair2 h o) (and (solves x h o) (solvesAll x css)))))))
(define-fun
  isSolution
    ((x Schema)) Bool (and (isFine x) (solvesAll x allCases)))
(assert-not (forall ((t Schema)) (not (isSolution t))))
(check-sat)
