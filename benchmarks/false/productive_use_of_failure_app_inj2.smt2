(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((S (proj1-S Nat)) (Z)))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(prove
  (forall ((xs (list Nat)) (ys (list Nat)) (zs (list Nat)))
    (=> (= (++ xs ys) (++ zs ys)) (= xs zs))))
