; Property about rotate and mod, written structurally recursive
(declare-datatypes () ((Nat (S (p Nat)) (Z))))
(declare-datatypes (a)
  ((List2 (Cons (Cons_0 a) (Cons_1 (List2 a))) (Nil))))
(define-funs-rec
  ((par (a) (take ((x Nat) (y (List2 a))) (List2 a))))
  ((match x
     (case (S z)
       (match y
         (case (Cons x2 x3) (Cons x2 (take z x3)))
         (case Nil y)))
     (case Z (as Nil (List2 a))))))
(define-funs-rec
  ((minus ((x Nat) (y Nat)) Nat))
  ((match x
     (case (S z)
       (match y
         (case (S x2) (minus z x2))
         (case Z x)))
     (case Z x))))
(define-funs-rec
  ((mod2 ((x Nat) (y Nat) (z Nat)) Nat))
  ((match z
     (case (S x2)
       (match x
         (case (S n)
           (match y
             (case (S k) (mod2 n k z))
             (case Z (mod2 n x2 z))))
         (case Z
           (match y
             (case (S m) (minus z y))
             (case Z y)))))
     (case Z z))))
(define-funs-rec ((mod ((x Nat) (y Nat)) Nat)) ((mod2 x Z y)))
(define-funs-rec
  ((par (a) (length ((x (List2 a))) Nat)))
  ((match x
     (case (Cons y xs) (S (length xs)))
     (case Nil Z))))
(define-funs-rec
  ((par (a) (drop ((x Nat) (y (List2 a))) (List2 a))))
  ((match x
     (case (S z)
       (match y
         (case (Cons x2 x3) (drop z x3))
         (case Nil y)))
     (case Z y))))
(define-funs-rec
  ((par (a) (append ((x (List2 a)) (y (List2 a))) (List2 a))))
  ((match x
     (case (Cons z xs) (Cons z (append xs y)))
     (case Nil y))))
(define-funs-rec
  ((par (a) (rotate ((x Nat) (y (List2 a))) (List2 a))))
  ((match x
     (case (S z)
       (match y
         (case (Cons x2 x3)
           (rotate z (append x3 (Cons x2 (as Nil (List2 a))))))
         (case Nil y)))
     (case Z y))))
(assert-not
  (par (a)
    (forall ((n Nat) (xs (List2 a)))
      (= (rotate n xs)
        (append (drop (mod n (length xs)) xs)
          (take (mod n (length xs)) xs))))))
(check-sat)
