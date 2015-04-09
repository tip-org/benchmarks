; Source: Productive use of failure
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (a3) (append ((x3 (list a3)) (x4 (list a3))) (list a3))))
  ((match x3
     (case nil x4)
     (case (cons x5 xs2) (cons x5 (as (append xs2 x4) (list a3)))))))
(define-funs-rec
  ((par (a2) (rev ((x (list a2))) (list a2))))
  ((match x
     (case nil x)
     (case
       (cons x2 xs)
       (append (as (rev xs) (list a2)) (cons x2 (as nil (list a2))))))))
(assert-not
  (par
    (a4)
    (forall
      ((x6 (list a4)) (y (list a4)))
      (= (rev (append (rev x6) y)) (append (rev y) x6)))))
(check-sat)
