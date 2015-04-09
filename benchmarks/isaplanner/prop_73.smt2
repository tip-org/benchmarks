; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (a4) (filter ((x3 (=> a4 bool)) (x4 (list a4))) (list a4))))
  ((match x4
     (case nil x4)
     (case
       (cons x5 xs2)
       (ite
         (@ x3 x5) (cons x5 (as (filter x3 xs2) (list a4)))
         (as (filter x3 xs2) (list a4)))))))
(define-funs-rec
  ((par (a3) (append ((x6 (list a3)) (x7 (list a3))) (list a3))))
  ((match x6
     (case nil x7)
     (case (cons x8 xs3) (cons x8 (as (append xs3 x7) (list a3)))))))
(define-funs-rec
  ((par (a2) (rev ((x (list a2))) (list a2))))
  ((match x
     (case nil x)
     (case
       (cons x2 xs)
       (append (as (rev xs) (list a2)) (cons x2 (as nil (list a2))))))))
(assert-not
  (par
    (a5)
    (forall
      ((p (=> a5 bool)) (xs4 (list a5)))
      (= (rev (filter p xs4)) (filter p (rev xs4))))))
(check-sat)
