; Top-down merge sort, using division by two on natural numbers
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (a) (take ((x Nat) (y (list a))) (list a))))
  ((match x
     (case Z (as nil (list a)))
     (case (S z)
       (match y
         (case nil (as nil (list a)))
         (case (cons x2 x3) (cons x2 (take z x3))))))))
(define-funs-rec
  ((par (t) (null ((x (list t))) Bool)))
  ((match x
     (case nil true)
     (case (cons y z) false))))
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
  ((par (t) (length ((x (list t))) Nat)))
  ((match x
     (case nil Z)
     (case (cons y xs) (S (length xs))))))
(define-funs-rec
  ((half ((x Nat)) Nat))
  ((match x
     (case Z Z)
     (case (S y)
       (match y
         (case Z Z)
         (case (S n) (S (half n))))))))
(define-funs-rec
  ((elem ((x Int) (y (list Int))) Bool))
  ((match y
     (case nil false)
     (case (cons z ys) (or (= x z) (elem x ys))))))
(define-funs-rec
  ((par (a) (drop ((x Nat) (y (list a))) (list a))))
  ((match x
     (case Z y)
     (case (S z)
       (match y
         (case nil (as nil (list a)))
         (case (cons x2 x3) (drop z x3)))))))
(define-funs-rec
  ((nmsorttd ((x (list Int))) (list Int)))
  ((match x
     (case nil (as nil (list Int)))
     (case (cons y z)
       (match z
         (case nil (cons y (as nil (list Int))))
         (case (cons x2 x3)
           (let (((k Nat) (half (length x))))
             (lmerge (nmsorttd (take k x)) (nmsorttd (drop k x))))))))))
(define-funs-rec
  ((delete ((x Int) (y (list Int))) (list Int)))
  ((match y
     (case nil (as nil (list Int)))
     (case (cons z ys) (ite (= x z) ys (cons z (delete x ys)))))))
(define-funs-rec
  ((isPermutation ((x (list Int)) (y (list Int))) Bool))
  ((match x
     (case nil (null y))
     (case (cons z xs)
       (and (elem z y) (isPermutation xs (delete z y)))))))
(assert-not
  (forall ((x (list Int))) (isPermutation (nmsorttd x) x)))
(check-sat)
