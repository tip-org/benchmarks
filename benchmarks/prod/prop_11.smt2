; Source: Productive use of failure
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (as (append xs y) (list a)))))))
(define-funs-rec
  ((par (a) (rev ((x (list a))) (list a))))
  ((match x
     (case nil x)
     (case (cons y xs)
       (append (as (rev xs) (list a)) (cons y (as nil (list a))))))))
(assert-not
  (par (a)
    (forall ((x (list a)) (y (list a)))
      (= (rev (append (rev x) (rev y))) (append y x)))))
(check-sat)
