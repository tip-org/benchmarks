; Selection sort, using a total minimum function
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((minimum ((x int) (y (list int))) int))
  ((match y
     (case nil x)
     (case (cons z ys) (ite (<= z x) (minimum z ys) (minimum x ys))))))
(define-funs-rec
  ((delete ((x int) (y (list int))) (list int)))
  ((match y
     (case nil y)
     (case (cons z ys) (ite (= x z) ys (cons z (delete x ys)))))))
(define-funs-rec
  ((ssort ((x (list int))) (list int)))
  ((match x
     (case nil x)
     (case (cons y ys)
       (cons (minimum y ys) (ssort (delete (minimum y ys) x)))))))
(define-funs-rec
  ((and2 ((x bool) (y bool)) bool)) ((ite x y false)))
(define-funs-rec
  ((ordered ((x (list int))) bool))
  ((match x
     (case nil true)
     (case (cons y z)
       (match z
         (case nil true)
         (case (cons y2 xs) (and2 (<= y y2) (ordered z))))))))
(assert-not (forall ((x (list int))) (ordered (ssort x))))
(check-sat)
