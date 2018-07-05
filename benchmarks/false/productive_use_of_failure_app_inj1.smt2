(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (S (proj1-S Nat)) (Z))))
(define-fun-rec
  (par (a)
    (++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(prove
  (forall ((xs (list Nat)) (ys (list Nat)) (zs (list Nat)))
    (=> (= (++ xs ys) (++ xs zs)) (= ys zs))))
