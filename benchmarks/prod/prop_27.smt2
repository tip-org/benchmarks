; Source: Productive use of failure
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (a4) (qrev ((x3 (list a4)) (x4 (list a4))) (list a4))))
  ((match x3
     (case nil x4)
     (case (cons x5 xs2) (as (qrev xs2 (cons x5 x4)) (list a4))))))
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
      ((x9 (list a5))) (= (rev x9) (qrev x9 (as nil (list a5)))))))
(check-sat)
