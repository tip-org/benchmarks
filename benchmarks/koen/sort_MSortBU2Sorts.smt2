; Bottom-up merge sort, using a total risers function
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((risers ((x (list Int))) (list (list Int))))
  ((match x
     (case nil (as nil (list (list Int))))
     (case (cons y z)
       (match z
         (case nil (cons x (as nil (list (list Int)))))
         (case (cons y2 xs)
           (ite
             (<= y y2)
             (match (risers z)
               (case nil (risers z))
               (case (cons ys yss) (cons (cons y ys) yss)))
             (cons (cons y (as nil (list Int))) (risers z)))))))))
(define-funs-rec
  ((lmerge ((x (list Int)) (y (list Int))) (list Int)))
  ((match x
     (case nil y)
     (case (cons z x2)
       (match y
         (case nil x)
         (case (cons x3 x4)
           (ite
             (<= z x3) (cons z (lmerge x2 y)) (cons x3 (lmerge x x4)))))))))
(define-funs-rec
  ((pairwise ((x (list (list Int)))) (list (list Int))))
  ((match x
     (case nil x)
     (case (cons xs y)
       (match y
         (case nil x)
         (case (cons ys xss) (cons (lmerge xs ys) (pairwise xss))))))))
(define-funs-rec
  ((mergingbu2 ((x (list (list Int)))) (list Int)))
  ((match x
     (case nil (as nil (list Int)))
     (case (cons xs y)
       (match y
         (case nil xs)
         (case (cons z x2) (mergingbu2 (pairwise x))))))))
(define-funs-rec
  ((par (b c a) (dot ((x (=> b c)) (y (=> a b)) (z a)) c)))
  ((@ x (@ y z))))
(define-funs-rec
  ((msortbu2 ((x (list Int))) (list Int)))
  ((dot (lambda ((y (list (list Int)))) (mergingbu2 y))
     (lambda ((z (list Int))) (risers z)) x)))
(define-funs-rec
  ((and2 ((x Bool) (y Bool)) Bool)) ((ite x y false)))
(define-funs-rec
  ((ordered ((x (list Int))) Bool))
  ((match x
     (case nil true)
     (case (cons y z)
       (match z
         (case nil true)
         (case (cons y2 xs) (and2 (<= y y2) (ordered z))))))))
(assert-not (forall ((x (list Int))) (ordered (msortbu2 x))))
(check-sat)
