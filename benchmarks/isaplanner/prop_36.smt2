; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par
     (a2)
     (takeWhile
        ((x (=> a2 bool)) (x2 (list a2))) (list a2)
        (match x2
          (case nil x2)
          (case
            (cons x3 xs)
            (ite
              (@ x x3) (cons x3 (as (takeWhile x xs) (list a2)))
              (as nil (list a2)))))))))
(define-funs-rec ((par (t) (constTrue ((x4 t)) bool true))))
(declare-sort a3 0)
(assert
  (not
    (forall
      ((xs2 (list a3)))
      (= (takeWhile (lambda ((x5 a3)) (constTrue x5)) xs2) xs2))))
(check-sat)
