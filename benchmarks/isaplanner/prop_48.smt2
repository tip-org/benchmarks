; Source: IsaPlanner test suite
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (a) (null ((x (list a))) bool)))
  ((match x
     (case nil true)
     (case (cons y z) false))))
(define-funs-rec
  ((last ((x (list Nat))) Nat))
  ((match x
     (case nil Z)
     (case (cons y z)
       (match z
         (case nil y)
         (case (cons x2 x3) (last z)))))))
(define-funs-rec
  ((par (a) (butlast ((x (list a))) (list a))))
  ((match x
     (case nil x)
     (case (cons y z)
       (match z
         (case nil z)
         (case (cons x2 x3) (cons y (as (butlast z) (list a)))))))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (as (append xs y) (list a)))))))
(assert-not
  (forall ((xs (list Nat)))
    (=> (not (null xs))
      (= (append (butlast xs) (cons (last xs) (as nil (list Nat))))
        xs))))
(check-sat)
