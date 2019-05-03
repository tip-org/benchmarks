(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((S (proj1-S Nat)) (Z)))
(define-fun-rec
  length
  (par (a) (((x (list a))) Nat))
  (match x
    ((nil Z)
     ((cons y xs) (S (length xs))))))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(define-fun-rec
  rotate
  (par (a) (((x Nat) (y (list a))) (list a)))
  (match x
    (((S z)
      (match y
        ((nil (_ nil a))
         ((cons x2 x3) (rotate z (++ x3 (cons x2 (_ nil a))))))))
     (Z y))))
(prove
  (forall ((xs (list Nat)) (ys (list Nat)))
    (=> (= (length xs) (length ys))
      (=> (= (rotate (length xs) (++ xs ys)) (++ xs ys)) (= xs ys)))))
