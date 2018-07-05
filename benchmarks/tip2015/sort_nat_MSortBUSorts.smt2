; Bottom-up merge sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(define-fun-rec
  (par (a b)
    (map
       ((f (=> a b)) (x (list a))) (list b)
       (match x
         (case nil (_ nil b))
         (case (cons y xs) (cons (@ f y) (map f xs)))))))
(define-fun-rec
  leq
    ((x Nat) (y Nat)) Bool
    (match x
      (case zero true)
      (case (succ z)
        (match y
          (case zero false)
          (case (succ x2) (leq z x2))))))
(define-fun-rec
  lmerge
    ((x (list Nat)) (y (list Nat))) (list Nat)
    (match x
      (case nil y)
      (case (cons z x2)
        (match y
          (case nil x)
          (case (cons x3 x4)
            (ite
              (leq z x3) (cons z (lmerge x2 y)) (cons x3 (lmerge x x4))))))))
(define-fun-rec
  pairwise
    ((x (list (list Nat)))) (list (list Nat))
    (match x
      (case nil (_ nil (list Nat)))
      (case (cons xs y)
        (match y
          (case nil (cons xs (_ nil (list Nat))))
          (case (cons ys xss) (cons (lmerge xs ys) (pairwise xss)))))))
(define-fun-rec
  mergingbu
    ((x (list (list Nat)))) (list Nat)
    (match x
      (case nil (_ nil Nat))
      (case (cons xs y)
        (match y
          (case nil xs)
          (case (cons z x2) (mergingbu (pairwise x)))))))
(define-fun
  msortbu
    ((x (list Nat))) (list Nat)
    (mergingbu (map (lambda ((y Nat)) (cons y (_ nil Nat))) x)))
(define-fun-rec
  ordered
    ((x (list Nat))) Bool
    (match x
      (case nil true)
      (case (cons y z)
        (match z
          (case nil true)
          (case (cons y2 xs) (and (leq y y2) (ordered z)))))))
(prove (forall ((xs (list Nat))) (ordered (msortbu xs))))
