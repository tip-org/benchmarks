; Bitonic sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((sort2 ((x int) (y int)) (list int)))
  ((ite
     (<= x y) (cons x (cons y (as nil (list int))))
     (cons y (cons x (as nil (list int)))))))
(define-funs-rec
  ((par (a) (evens ((x (list a))) (list a)))
   (par (a) (odds ((x (list a))) (list a))))
  ((match x
     (case nil x)
     (case (cons y xs) (cons y (odds xs))))
   (match x
     (case nil x)
     (case (cons y xs) (evens xs)))))
(define-funs-rec
  ((count ((x int) (y (list int))) Nat))
  ((match y
     (case nil Z)
     (case (cons z xs) (ite (= x z) (S (count x xs)) (count x xs))))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (append xs y))))))
(define-funs-rec
  ((pairs ((x (list int)) (y (list int))) (list int)))
  ((match x
     (case nil y)
     (case (cons z x2)
       (match y
         (case nil x)
         (case (cons x3 x4) (append (sort2 z x3) (pairs x2 x4))))))))
(define-funs-rec
  ((stitch ((x (list int)) (y (list int))) (list int)))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (pairs xs y))))))
(define-funs-rec
  ((bmerge ((x (list int)) (y (list int))) (list int)))
  ((match x
     (case nil x)
     (case (cons z x2)
       (match y
         (case nil x)
         (case (cons x3 x4)
           (match x2
             (case nil
               (match x4
                 (case nil (sort2 z x3))
                 (case (cons x5 x6)
                   (stitch (bmerge (evens x) (evens y)) (bmerge (odds x) (odds y))))))
             (case (cons x7 x8)
               (stitch (bmerge (evens x) (evens y))
                 (bmerge (odds x) (odds y)))))))))))
(define-funs-rec
  ((bsort ((x (list int))) (list int)))
  ((match x
     (case nil x)
     (case (cons y z)
       (match z
         (case nil x)
         (case (cons x2 x3)
           (bmerge (bsort (evens x)) (bsort (odds x)))))))))
(assert-not
  (forall ((x int) (y (list int)))
    (= (count x (bsort y)) (count x y))))
(check-sat)