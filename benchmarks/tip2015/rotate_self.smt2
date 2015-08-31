; | Another simple property about rotate
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
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
      (= (rotate n (append xs xs))
        (append (rotate n xs) (rotate n xs))))))
(check-sat)
