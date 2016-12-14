; Rotate expressed using a snoc instead of append
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  (par (a)
    (snoc
       ((x a) (y (list a))) (list a)
       (match y
         (case nil (cons x (as nil (list a))))
         (case (cons z ys) (cons z (snoc x ys)))))))
(define-fun-rec
  (par (a)
    (rotate
       ((x Nat) (y (list a))) (list a)
       (match x
         (case Z y)
         (case (S z)
           (match y
             (case nil (as nil (list a)))
             (case (cons z2 xs1) (rotate z (snoc z2 xs1)))))))))
(define-fun-rec
  (par (a)
    (++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(assert-not
  (par (a)
    (forall ((n Nat) (xs (list a)))
      (= (rotate n (++ xs xs)) (++ (rotate n xs) (rotate n xs))))))
(check-sat)
