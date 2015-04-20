; List monad laws
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (a b) (fmap ((x (=> a b)) (y (list a))) (list b))))
  ((match y
     (case nil (as nil (list b)))
     (case (cons z xs) (cons (@ x z) (as (fmap x xs) (list b)))))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (as (append xs y) (list a)))))))
(define-funs-rec
  ((par (a b) (bind ((x (list a)) (y (=> a (list b)))) (list b))))
  ((match x
     (case nil (as nil (list b)))
     (case (cons z xs) (append (@ y z) (as (bind xs y) (list b)))))))
(define-funs-rec
  ((par (a) (concat2 ((x (list (list a)))) (list a))))
  ((match x
     (case nil (as nil (list a)))
     (case (cons xs xss) (append xs (as (concat2 xss) (list a)))))))
(assert-not
  (par (a b)
    (forall ((f (=> a (list b))) (xs (list a)))
      (= (concat2 (fmap f xs)) (bind xs f)))))
(check-sat)
