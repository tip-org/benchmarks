; Property about rotate and mod
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  (par (a)
    (take
       ((x Nat) (y (list a))) (list a)
       (match x
         (case Z (as nil (list a)))
         (case (S z)
           (match y
             (case nil (as nil (list a)))
             (case (cons x2 x3) (cons x2 (take z x3)))))))))
(define-fun-rec
  minus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S n)
        (match y
          (case Z x)
          (case (S m) (minus n m))))))
(define-fun-rec
  (par (a)
    (length
       ((x (list a))) Nat
       (match x
         (case nil Z)
         (case (cons y xs) (S (length xs)))))))
(define-fun-rec
  go
    ((x Nat) (y Nat) (z Nat)) Nat
    (match z
      (case Z Z)
      (case (S x2)
        (match x
          (case Z
            (match y
              (case Z Z)
              (case (S n) (minus z y))))
          (case (S m)
            (match y
              (case Z (go m x2 z))
              (case (S k) (go m k z))))))))
(define-fun mod_structural ((x Nat) (y Nat)) Nat (go x Z y))
(define-fun-rec
  (par (a)
    (drop
       ((x Nat) (y (list a))) (list a)
       (match x
         (case Z y)
         (case (S z)
           (match y
             (case nil (as nil (list a)))
             (case (cons x2 x3) (drop z x3))))))))
(define-fun-rec
  (par (a)
    (append
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (append xs y)))))))
(define-fun-rec
  (par (a)
    (rotate
       ((x Nat) (y (list a))) (list a)
       (match x
         (case Z y)
         (case (S z)
           (match y
             (case nil (as nil (list a)))
             (case (cons x2 x3)
               (rotate z (append x3 (cons x2 (as nil (list a))))))))))))
(assert-not
  (par (a)
    (forall ((n Nat) (xs (list a)))
      (= (rotate n xs)
        (append (drop (mod_structural n (length xs)) xs)
          (take (mod_structural n (length xs)) xs))))))
(check-sat)
