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
(define-funs-rec
  ((par
     (a3)
     (dropWhile
        ((x4 (=> a3 bool)) (x5 (list a3))) (list a3)
        (match x5
          (case nil x5)
          (case
            (cons x6 xs2)
            (ite (@ x4 x6) (as (dropWhile x4 xs2) (list a3)) x5)))))))
(define-funs-rec
  ((par
     (a4)
     (append
        ((x7 (list a4)) (x8 (list a4))) (list a4)
        (match x7
          (case nil x8)
          (case (cons x9 xs3) (cons x9 (as (append xs3 x8) (list a4)))))))))
(declare-sort a5 0)
(assert
  (not
    (forall
      ((p (=> a5 bool)) (xs4 (list a5)))
      (= (append (takeWhile p xs4) (dropWhile p xs4)) xs4))))
(check-sat)
