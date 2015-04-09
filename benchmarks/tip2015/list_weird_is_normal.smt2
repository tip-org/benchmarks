; List monad laws
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (a2) (weird_concat ((x (list (list a2)))) (list a2))))
  ((match x
     (case nil (as nil (list a2)))
     (case
       (cons ds xss)
       (match ds
         (case nil (as (weird_concat xss) (list a2)))
         (case
           (cons x2 xs)
           (cons x2 (as (weird_concat (cons xs xss)) (list a2)))))))))
(define-funs-rec
  ((par (a4) (append ((x4 (list a4)) (x5 (list a4))) (list a4))))
  ((match x4
     (case nil x5)
     (case (cons x6 xs3) (cons x6 (as (append xs3 x5) (list a4)))))))
(define-funs-rec
  ((par (a3) (concat2 ((x3 (list (list a3)))) (list a3))))
  ((match x3
     (case nil (as nil (list a3)))
     (case
       (cons xs2 xss2) (append xs2 (as (concat2 xss2) (list a3)))))))
(declare-sort a5 0)
(assert
  (not
    (forall
      ((x7 (list (list a5)))) (= (concat2 x7) (weird_concat x7)))))
(check-sat)
