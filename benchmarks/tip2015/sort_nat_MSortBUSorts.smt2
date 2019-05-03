; Bottom-up merge sort
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((zero) (succ (p Nat))))
(define-fun-rec
  map
  (par (a b) (((f (=> a b)) (x (list a))) (list b)))
  (match x
    ((nil (_ nil b))
     ((cons y xs) (cons (@ f y) (map f xs))))))
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
  mergingbu
  ((x (list (list Nat)))) (list Nat)
  (match x
    ((nil (_ nil Nat))
     ((cons xs y)
      (match y
        ((nil xs)
         ((cons z x2) (mergingbu (pairwise x)))))))))
(define-fun
  msortbu
  ((x (list Nat))) (list Nat)
  (mergingbu (map (lambda ((y Nat)) (cons y (_ nil Nat))) x)))
(define-fun-rec
  ordered
  ((x (list Nat))) Bool
  (match x
    ((nil true)
     ((cons y z)
      (match z
        ((nil true)
         ((cons y2 xs) (and (leq y y2) (ordered z)))))))))
(prove (forall ((xs (list Nat))) (ordered (msortbu xs))))
