; List monad laws
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (a) (weird_concat ((x (list (list a)))) (list a))))
  ((match x
     (case nil (as nil (list a)))
     (case (cons y xss)
       (match y
         (case nil (as (weird_concat xss) (list a)))
         (case (cons z xs)
           (cons z (as (weird_concat (cons xs xss)) (list a)))))))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (as (append xs y) (list a)))))))
(define-funs-rec
  ((par (a) (concat2 ((x (list (list a)))) (list a))))
  ((match x
     (case nil (as nil (list a)))
     (case (cons xs xss) (append xs (as (concat2 xss) (list a)))))))
(assert-not
  (par (a)
    (forall ((x (list (list a)))) (= (concat2 x) (weird_concat x)))))
(check-sat)
