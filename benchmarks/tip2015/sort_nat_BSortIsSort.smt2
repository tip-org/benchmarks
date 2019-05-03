; Bitonic sort
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
(define-fun
  sort2
  ((x Nat) (y Nat)) (list Nat)
  (ite
    (leq x y) (cons x (cons y (_ nil Nat)))
    (cons y (cons x (_ nil Nat)))))
(define-fun-rec
  insert
  ((x Nat) (y (list Nat))) (list Nat)
  (match y
    ((nil (cons x (_ nil Nat)))
     ((cons z xs) (ite (leq x z) (cons x y) (cons z (insert x xs)))))))
(define-fun-rec
  isort
  ((x (list Nat))) (list Nat)
  (match x
    ((nil (_ nil Nat))
     ((cons y xs) (insert y (isort xs))))))
(define-funs-rec
  ((evens
    (par (a) (((x (list a))) (list a))))
   (odds
    (par (a) (((x (list a))) (list a)))))
  ((match x
     ((nil (_ nil a))
      ((cons y xs) (cons y (odds xs)))))
   (match x
     ((nil (_ nil a))
      ((cons y xs) (evens xs))))))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(define-fun-rec
  pairs
  ((x (list Nat)) (y (list Nat))) (list Nat)
  (match x
    ((nil y)
     ((cons z x2)
      (match y
        ((nil x)
         ((cons x3 x4) (++ (sort2 z x3) (pairs x2 x4)))))))))
(define-fun
  stitch
  ((x (list Nat)) (y (list Nat))) (list Nat)
  (match x
    ((nil y)
     ((cons z xs) (cons z (pairs xs y))))))
(define-fun-rec
  bmerge
  ((x (list Nat)) (y (list Nat))) (list Nat)
  (match x
    ((nil (_ nil Nat))
     ((cons z x2)
      (match y
        ((nil x)
         ((cons x3 x4)
          (let
            ((fail
                (stitch (bmerge (evens x) (evens y)) (bmerge (odds x) (odds y)))))
            (match x2
              ((nil
                (match x4
                  ((nil (sort2 z x3))
                   ((cons x5 x6) fail))))
               ((cons x7 x8) fail)))))))))))
(define-fun-rec
  bsort
  ((x (list Nat))) (list Nat)
  (match x
    ((nil (_ nil Nat))
     ((cons y z)
      (match z
        ((nil (cons y (_ nil Nat)))
         ((cons x2 x3) (bmerge (bsort (evens x)) (bsort (odds x))))))))))
(prove (forall ((xs (list Nat))) (= (bsort xs) (isort xs))))
