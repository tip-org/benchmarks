; | Another simple property about rotate
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  (par (a)
    (++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  (par (a)
    (rotate
       ((x Nat) (y (list a))) (list a)
       (match x
         (case Z y)
         (case (S z)
           (match y
             (case nil (as nil (list a)))
             (case (cons z2 xs1)
               (rotate z (++ xs1 (cons z2 (as nil (list a))))))))))))
(assert-not
  (par (a)
    (forall ((n Nat) (xs (list a)))
      (= (rotate n (++ xs xs)) (++ (rotate n xs) (rotate n xs))))))
(check-sat)
