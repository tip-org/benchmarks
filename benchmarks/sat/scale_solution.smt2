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
(assert-not
  (forall
    ((d1 Object) (d2 Object) (d3 Object) (d4 Object) (e1 Object)
     (e2 Object) (e3 Object) (e4 Object) (dd1 Object) (dd2 Object)
     (dd3 Object) (dd4 Object) (dd5 Object) (dd6 Object) (ee1 Object)
     (ee2 Object) (ee3 Object) (ee4 Object) (ee5 Object) (ee6 Object)
     (aa1 Object) (aa4 Object) (aa2 Object) (aa5 Object) (aa3 Object)
     (aa6 Object) (ab1 Object) (ab4 Object) (ab2 Object) (ab5 Object)
     (ab3 Object) (ab6 Object) (ac1 Object) (ac4 Object) (ac2 Object)
     (ac5 Object) (ac3 Object) (ac6 Object) (ba1 Bool) (oa1 Object)
     (ba4 Bool) (oa4 Object) (ba7 Bool) (oa7 Object) (ba2 Bool)
     (oa2 Object) (ba5 Bool) (oa5 Object) (ba8 Bool) (oa8 Object)
     (ba3 Bool) (oa3 Object) (ba6 Bool) (oa6 Object) (ba9 Bool)
     (oa9 Object) (bb1 Bool) (ob1 Object) (bb4 Bool) (ob4 Object)
     (bb7 Bool) (ob7 Object) (bb2 Bool) (ob2 Object) (bb5 Bool)
     (ob5 Object) (bb8 Bool) (ob8 Object) (bb3 Bool) (ob3 Object)
     (bb6 Bool) (ob6 Object) (bb9 Bool) (ob9 Object) (bc1 Bool)
     (oc1 Object) (bc4 Bool) (oc4 Object) (bc7 Bool) (oc7 Object)
     (bc2 Bool) (oc2 Object) (bc5 Bool) (oc5 Object) (bc8 Bool)
     (oc8 Object) (bc3 Bool) (oc3 Object) (bc6 Bool) (oc6 Object)
     (bc9 Bool) (oc9 Object))
    (not
      (isSolution
        (Weigh
          (cons d1 (cons d2 (cons d3 (cons d4 (as nil (list Object))))))
          (cons e1 (cons e2 (cons e3 (cons e4 (as nil (list Object))))))
          (Weigh (cons dd1 (cons dd2 (as nil (list Object))))
            (cons ee1 (cons ee2 (as nil (list Object))))
            (Weigh (cons aa1 (as nil (list Object)))
              (cons aa4 (as nil (list Object))) (Answer ba1 oa1) (Answer ba4 oa4)
              (Answer ba7 oa7))
            (Weigh (cons aa2 (as nil (list Object)))
              (cons aa5 (as nil (list Object))) (Answer ba2 oa2) (Answer ba5 oa5)
              (Answer ba8 oa8))
            (Weigh (cons aa3 (as nil (list Object)))
              (cons aa6 (as nil (list Object))) (Answer ba3 oa3) (Answer ba6 oa6)
              (Answer ba9 oa9)))
          (Weigh (cons dd3 (cons dd4 (as nil (list Object))))
            (cons ee3 (cons ee4 (as nil (list Object))))
            (Weigh (cons ab1 (as nil (list Object)))
              (cons ab4 (as nil (list Object))) (Answer bb1 ob1) (Answer bb4 ob4)
              (Answer bb7 ob7))
            (Weigh (cons ab2 (as nil (list Object)))
              (cons ab5 (as nil (list Object))) (Answer bb2 ob2) (Answer bb5 ob5)
              (Answer bb8 ob8))
            (Weigh (cons ab3 (as nil (list Object)))
              (cons ab6 (as nil (list Object))) (Answer bb3 ob3) (Answer bb6 ob6)
              (Answer bb9 ob9)))
          (Weigh (cons dd5 (cons dd6 (as nil (list Object))))
            (cons ee5 (cons ee6 (as nil (list Object))))
            (Weigh (cons ac1 (as nil (list Object)))
              (cons ac4 (as nil (list Object))) (Answer bc1 oc1) (Answer bc4 oc4)
              (Answer bc7 oc7))
            (Weigh (cons ac2 (as nil (list Object)))
              (cons ac5 (as nil (list Object))) (Answer bc2 oc2) (Answer bc5 oc5)
              (Answer bc8 oc8))
            (Weigh (cons ac3 (as nil (list Object)))
              (cons ac6 (as nil (list Object))) (Answer bc3 oc3) (Answer bc6 oc6)
              (Answer bc9 oc9))))))))
(check-sat)
