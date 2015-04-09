; List monad laws
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (a3) (weird_concat ((x4 (list (list a3)))) (list a3))))
  ((match x4
     (case nil (as nil (list a3)))
     (case
       (cons ds xss)
       (match ds
         (case nil (as (weird_concat xss) (list a3)))
         (case
           (cons x5 xs2)
           (cons x5 (as (weird_concat (cons xs2 xss)) (list a3)))))))))
(define-funs-rec
  ((par (a2) (append ((x (list a2)) (x2 (list a2))) (list a2))))
  ((match x
     (case nil x2)
     (case (cons x3 xs) (cons x3 (as (append xs x2) (list a2)))))))
(define-funs-rec
  ((par (a4) (concat2 ((x6 (list (list a4)))) (list a4))))
  ((match x6
     (case nil (as nil (list a4)))
     (case
       (cons xs3 xss2) (append xs3 (as (concat2 xss2) (list a4)))))))
(assert-not
  (par
    (a5)
    (forall
      ((x7 (list (list a5)))) (= (concat2 x7) (weird_concat x7)))))
(check-sat)
