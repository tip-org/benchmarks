; Bottom-up merge sort, using a total risers function
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((zero) (succ (p Nat))))
(define-fun-rec
  plus
  ((x Nat) (y Nat)) Nat
  (match x
    ((zero y)
     ((succ z) (succ (plus z y))))))
(define-fun-rec
  leq
  ((x Nat) (y Nat)) Bool
  (match x
    ((zero true)
     ((succ z)
      (match y
        ((zero false)
         ((succ x2) (leq z x2))))))))
(define-fun-rec
  lmerge
  ((x (list Nat)) (y (list Nat))) (list Nat)
  (match x
    ((nil y)
     ((cons z x2)
      (match y
        ((nil x)
         ((cons x3 x4)
          (ite
            (leq z x3) (cons z (lmerge x2 y)) (cons x3 (lmerge x x4))))))))))
(define-fun-rec
  pairwise
  ((x (list (list Nat)))) (list (list Nat))
  (match x
    ((nil (_ nil (list Nat)))
     ((cons xs y)
      (match y
        ((nil (cons xs (_ nil (list Nat))))
         ((cons ys xss) (cons (lmerge xs ys) (pairwise xss)))))))))
(define-fun-rec
  mergingbu2
  ((x (list (list Nat)))) (list Nat)
  (match x
    ((nil (_ nil Nat))
     ((cons xs y)
      (match y
        ((nil xs)
         ((cons z x2) (mergingbu2 (pairwise x)))))))))
(define-fun-rec
  risers
  ((x (list Nat))) (list (list Nat))
  (match x
    ((nil (_ nil (list Nat)))
     ((cons y z)
      (match z
        ((nil (cons (cons y (_ nil Nat)) (_ nil (list Nat))))
         ((cons y2 xs)
          (ite
            (leq y y2)
            (match (risers z)
              ((nil (_ nil (list Nat)))
               ((cons ys yss) (cons (cons y ys) yss))))
            (cons (cons y (_ nil Nat)) (risers z))))))))))
(define-fun
  msortbu2
  ((x (list Nat))) (list Nat) (mergingbu2 (risers x)))
(define-fun-rec
  count
  (par (a) (((x a) (y (list a))) Nat))
  (match y
    ((nil zero)
     ((cons z ys)
      (ite (= x z) (plus (succ zero) (count x ys)) (count x ys))))))
(prove
  (forall ((x Nat) (xs (list Nat)))
    (= (count x (msortbu2 xs)) (count x xs))))
(assert
  (forall ((x Nat) (y Nat) (z Nat))
    (= (plus x (plus y z)) (plus (plus x y) z))))
(assert (forall ((x Nat) (y Nat)) (= (plus x y) (plus y x))))
(assert (forall ((x Nat)) (= (plus x zero) x)))
(assert (forall ((x Nat)) (= (plus zero x) x)))
