; Source: IsaPlanner test suite
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((last ((x (list Nat))) Nat))
  ((match x
     (case nil Z)
     (case (cons y z)
       (match z
         (case nil y)
         (case (cons x2 x3) (last z)))))))
(define-funs-rec
  ((lastOfTwo ((x (list Nat)) (y (list Nat))) Nat))
  ((match y
     (case nil (last x))
     (case (cons z x2) (last y)))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (as (append xs y) (list a)))))))
(assert-not
  (forall ((xs (list Nat)) (ys (list Nat)))
    (= (last (append xs ys)) (lastOfTwo xs ys))))
(check-sat)
