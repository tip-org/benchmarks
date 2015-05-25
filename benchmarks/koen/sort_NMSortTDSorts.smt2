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
  ((and2 ((x Bool) (y Bool)) Bool)) ((ite x y false)))
(define-funs-rec
  ((ordered ((x (list Int))) Bool))
  ((match x
     (case nil true)
     (case (cons y z)
       (match z
         (case nil true)
         (case (cons y2 xs) (and2 (<= y y2) (ordered z))))))))
(assert-not (forall ((x (list Int))) (ordered (nmsorttd x))))
(check-sat)
