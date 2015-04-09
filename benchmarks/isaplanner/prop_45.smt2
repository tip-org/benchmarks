; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(define-funs-rec
  ((par
     (a2 b2)
     (zip
        ((x (list a2)) (x2 (list b2))) (list (Pair a2 b2))
        (match x
          (case nil (as nil (list (Pair a2 b2))))
          (case
            (cons ipv ipv2)
            (match x2
              (case nil (as nil (list (Pair a2 b2))))
              (case
                (cons ipv3 ipv4)
                (cons
                  (Pair2 ipv ipv3) (as (zip ipv2 ipv4) (list (Pair a2 b2))))))))))))
(declare-sort a3 0)
(declare-sort b3 0)
(assert
  (not
    (forall
      ((x3 a3) (y b3) (xs (list a3)) (ys (list b3)))
      (=
        (zip (cons x3 xs) (cons y ys)) (cons (Pair2 x3 y) (zip xs ys))))))
(check-sat)
