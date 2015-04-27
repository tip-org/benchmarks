; Bottom-up merge sort, using a total risers function
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((risers ((x (list int))) (list (list int))))
  ((match x
     (case nil (as nil (list (list int))))
     (case (cons y z)
       (match z
         (case nil (cons x (as nil (list (list int)))))
         (case (cons y2 xs)
           (ite
             (<= y y2)
             (match (risers z)
               (case nil (risers z))
               (case (cons ys yss) (cons (cons y ys) yss)))
             (cons (cons y (as nil (list int))) (risers z)))))))))
(define-funs-rec
  ((lmerge ((x (list int)) (y (list int))) (list int)))
  ((match x
     (case nil y)
     (case (cons z x2)
       (match y
         (case nil x)
         (case (cons x3 x4)
           (ite
             (<= z x3) (cons z (lmerge x2 y)) (cons x3 (lmerge x x4)))))))))
(define-funs-rec
  ((pairwise ((x (list (list int)))) (list (list int))))
  ((match x
     (case nil x)
     (case (cons xs y)
       (match y
         (case nil x)
         (case (cons ys xss) (cons (lmerge xs ys) (pairwise xss))))))))
(define-funs-rec
  ((mergingbu2 ((x (list (list int)))) (list int)))
  ((match x
     (case nil (as nil (list int)))
     (case (cons xs y)
       (match y
         (case nil xs)
         (case (cons z x2) (mergingbu2 (pairwise x))))))))
(define-funs-rec
  ((par (b c a) (dot ((x (=> b c)) (y (=> a b)) (z a)) c)))
  ((@ x (@ y z))))
(define-funs-rec
  ((msortbu2 ((x (list int))) (list int)))
  ((dot (lambda ((y (list (list int)))) (mergingbu2 y))
     (lambda ((z (list int))) (risers z)) x)))
(define-funs-rec
  ((count ((x int) (y (list int))) Nat))
  ((match y
     (case nil Z)
     (case (cons z xs) (ite (= x z) (S (count x xs)) (count x xs))))))
(assert-not
  (forall ((x int) (y (list int)))
    (= (count x (msortbu2 y)) (count x y))))
(check-sat)
