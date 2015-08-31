(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  zdeleteAll
    ((x Int) (y (list Int))) (list Int)
    (match y
      (case nil (as nil (list Int)))
      (case (cons z xs)
        (ite (= x z) (zdeleteAll x xs) (cons z (zdeleteAll x xs))))))
(define-fun-rec
  znub
    ((x (list Int))) (list Int)
    (match x
      (case nil (as nil (list Int)))
      (case (cons y xs) (cons y (zdeleteAll y (znub xs))))))
(assert-not
  (forall ((xs (list Int))) (= (znub (znub xs)) (znub xs))))
(check-sat)
