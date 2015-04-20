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
(define-funs-rec
  ((par (a) (qrevflat ((x (list (list a))) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons xs xss)
       (as (qrevflat xss (append (rev xs) y)) (list a))))))
(define-funs-rec
  ((par (a) (revflat ((x (list (list a)))) (list a))))
  ((match x
     (case nil (as nil (list a)))
     (case (cons xs xss) (append (as (revflat xss) (list a)) xs)))))
(assert-not
  (par (a)
    (forall ((x (list (list a))))
      (= (revflat x) (qrevflat x (as nil (list a)))))))
(check-sat)
