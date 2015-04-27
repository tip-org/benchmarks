(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (t t2) (x ((f (=> t2 t)) (y (list t2))) (list t))))
  ((match y
     (case nil (as nil (list t)))
     (case (cons z x2) (cons (@ f z) (x f x2))))))
(define-funs-rec
  ((lmerge ((y (list int)) (z (list int))) (list int)))
  ((match y
     (case nil z)
     (case (cons x2 x3)
       (match z
         (case nil y)
         (case (cons x4 x5)
           (ite
             (<= x2 x4) (cons x2 (lmerge x3 z)) (cons x4 (lmerge y x5)))))))))
(define-funs-rec
  ((pairwise ((y (list (list int)))) (list (list int))))
  ((match y
     (case nil y)
     (case (cons xs z)
       (match z
         (case nil y)
         (case (cons ys xss) (cons (lmerge xs ys) (pairwise xss))))))))
(define-funs-rec
  ((mergingbu ((y (list (list int)))) (list int)))
  ((match y
     (case nil (as nil (list int)))
     (case (cons xs z)
       (match z
         (case nil xs)
         (case (cons x2 x3) (mergingbu (pairwise y))))))))
(define-funs-rec
  ((insert2 ((y int) (z (list int))) (list int)))
  ((match z
     (case nil (cons y z))
     (case (cons y2 xs)
       (ite (<= y y2) (cons y z) (cons y2 (insert2 y xs)))))))
(define-funs-rec
  ((isort ((y (list int))) (list int)))
  ((match y
     (case nil y)
     (case (cons z xs) (insert2 z (isort xs))))))
(define-funs-rec
  ((par (b c a) (dot ((y (=> b c)) (z (=> a b)) (x2 a)) c)))
  ((@ y (@ z x2))))
(define-funs-rec
  ((msortbu ((y (list int))) (list int)))
  ((dot (lambda ((z (list (list int)))) (mergingbu z))
     (lambda ((x2 (list int)))
       (x (lambda ((x3 int)) (cons x3 (as nil (list int)))) x2))
     y)))
(assert-not (forall ((y (list int))) (= (msortbu y) (isort y))))
(check-sat)
