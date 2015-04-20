; Source: IsaPlanner test suite
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
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
  (par (a)
    (forall ((xs (list a)) (x a))
      (= (butlast (append xs (cons x (as nil (list a))))) xs))))
(check-sat)
