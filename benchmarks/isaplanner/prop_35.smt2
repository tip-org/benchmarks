; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par
     (a2) (dropWhile ((x (=> a2 bool)) (x2 (list a2))) (list a2))))
  ((match x2
     (case nil x2)
     (case
       (cons x3 xs) (ite (@ x x3) (as (dropWhile x xs) (list a2)) x2)))))
(define-funs-rec ((par (t) (constFalse ((x4 t)) bool))) (false))
(assert-not
  (par
    (a3)
    (forall
      ((xs2 (list a3)))
      (= (dropWhile (lambda ((x5 a3)) (constFalse x5)) xs2) xs2))))
(check-sat)
