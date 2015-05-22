; Property about rotate and mod
(declare-datatypes () ((Nat (S (p Nat)) (Z))))
(declare-datatypes (a)
  ((List2 (Cons (Cons_0 a) (Cons_1 (List2 a))) (Nil))))
(define-funs-rec
  ((par (a) (take ((x Nat) (y (List2 a))) (List2 a))))
  ((match x
     (case (S z)
       (match y
         (case (Cons x2 x3) (Cons x2 (take z x3)))
         (case Nil (as Nil (List2 a)))))
     (case Z (as Nil (List2 a))))))
(define-funs-rec
  ((minus ((x Nat) (y Nat)) Nat))
  ((match x
     (case (S z)
       (match y
         (case (S x2) (minus z x2))
         (case Z x)))
     (case Z Z))))
(define-funs-rec
  ((lt ((x Nat) (y Nat)) Bool))
  ((match y
     (case (S z)
       (match x
         (case (S x2) (lt x2 z))
         (case Z true)))
     (case Z false))))
(define-funs-rec
  ((mod2 ((x Nat) (y Nat)) Nat))
  ((match y
     (case (S z) (ite (lt x y) x (mod2 (minus x y) y)))
     (case Z Z))))
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
         (case Nil (as Nil (List2 a)))))
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
         (case Nil (as Nil (List2 a)))))
     (case Z y))))
(assert-not
  (par (a)
    (forall ((n Nat) (xs (List2 a)))
      (= (rotate n xs)
        (append (drop (mod2 n (length xs)) xs)
          (take (mod2 n (length xs)) xs))))))
(check-sat)
