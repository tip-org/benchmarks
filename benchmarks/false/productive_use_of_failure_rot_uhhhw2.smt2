(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((S (proj1-S Nat)) (Z)))
(define-fun-rec
  length
  (par (a) (((x (list a))) Nat))
  (match x
    ((nil Z)
     ((cons y xs) (S (length xs))))))
(prove
  (forall ((xs (list Nat)) (ys (list Nat)))
    (=> (= (length xs) (length ys)) (= xs ys))))
