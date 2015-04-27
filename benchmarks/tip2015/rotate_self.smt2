; Another (simple) property about rotate
(declare-datatypes () ((Nat (S (p Nat)) (Z))))
(declare-datatypes (a)
  ((List2 (Cons (Cons_0 a) (Cons_1 (List2 a))) (Nil))))
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
      (= (rotate n (append xs xs))
        (append (rotate n xs) (rotate n xs))))))
(check-sat)
