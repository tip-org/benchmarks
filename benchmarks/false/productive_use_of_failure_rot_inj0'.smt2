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
  <2
  ((x Nat) (y Nat)) Bool
  (match x
    (((S z)
      (match y
        (((S y2) (<2 z y2))
         (Z false))))
     (Z
      (match y
        (((S x2) true)
         (Z false)))))))
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
  (forall ((n Nat) (m Nat) (ys (list Nat)) (xs (list Nat)))
    (=> (<2 n (length xs))
      (=> (<2 m (length ys))
        (=> (= xs ys)
          (=> (distinct (rotate (S Z) xs) xs)
            (=> (= (rotate n xs) (rotate m ys)) (= n m))))))))
