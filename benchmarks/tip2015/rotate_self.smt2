; | Another simple property about rotate
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
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
         (case zero y)
         (case (succ z)
           (match y
             (case nil (_ nil a))
             (case (cons z2 xs1) (rotate z (++ xs1 (cons z2 (_ nil a)))))))))))
(prove
  (par (a)
    (forall ((n Nat) (xs (list a)))
      (= (rotate n (++ xs xs)) (++ (rotate n xs) (rotate n xs))))))
