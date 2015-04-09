; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
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
(define-funs-rec
  ((par
     (a5)
     (len
        ((x5 (list a5))) Nat
        (match x5
          (case nil Z)
          (case (cons ds xs2) (S (as (len xs2) Nat))))))))
(define-funs-rec
  ((par
     (a4)
     (append
        ((x6 (list a4)) (x7 (list a4))) (list a4)
        (match x6
          (case nil x7)
          (case (cons x8 xs3) (cons x8 (as (append xs3 x7) (list a4)))))))))
(define-funs-rec
  ((par
     (a3)
     (rev
        ((x3 (list a3))) (list a3)
        (match x3
          (case nil x3)
          (case
            (cons x4 xs)
            (append (as (rev xs) (list a3)) (cons x4 (as nil (list a3))))))))))
(declare-sort a6 0)
(declare-sort b3 0)
(assert
  (not
    (forall
      ((xs4 (list a6)) (ys (list b3)))
      (=>
        (= (len xs4) (len ys))
        (= (zip (rev xs4) (rev ys)) (rev (zip xs4 ys)))))))
(check-sat)
