; Bubble sort
(declare-datatype
  pair (par (a b) ((pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((zero) (succ (p Nat))))
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
  ordered
  ((x (list Nat))) Bool
  (match x
    ((nil true)
     ((cons y z)
      (match z
        ((nil true)
         ((cons y2 xs) (and (leq y y2) (ordered z)))))))))
(define-fun-rec
  bubble
  ((x (list Nat))) (pair Bool (list Nat))
  (match x
    ((nil (pair2 false (_ nil Nat)))
     ((cons y z)
      (match z
        ((nil (pair2 false (cons y (_ nil Nat))))
         ((cons y2 xs)
          (ite
            (leq y y2)
            (match (bubble z) (((pair2 b12 ys12) (pair2 b12 (cons y ys12)))))
            (match (bubble (cons y xs))
              (((pair2 b1 ys1) (pair2 true (cons y2 ys1)))))))))))))
(define-fun-rec
  bubsort
  ((x (list Nat))) (list Nat)
  (match (bubble x) (((pair2 c ys1) (ite c (bubsort ys1) x)))))
(prove (forall ((xs (list Nat))) (ordered (bubsort xs))))
