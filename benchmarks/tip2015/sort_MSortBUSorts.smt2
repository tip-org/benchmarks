; Bottom-up merge sort
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  ordered
  ((x (list Int))) Bool
  (match x
    ((nil true)
     ((cons y z)
      (match z
        ((nil true)
         ((cons y2 xs) (and (<= y y2) (ordered z)))))))))
(define-fun-rec
  map
  (par (a b) (((f (=> a b)) (x (list a))) (list b)))
  (match x
    ((nil (_ nil b))
     ((cons y xs) (cons (@ f y) (map f xs))))))
(define-fun-rec
  lmerge
  ((x (list Int)) (y (list Int))) (list Int)
  (match x
    ((nil y)
     ((cons z x2)
      (match y
        ((nil x)
         ((cons x3 x4)
          (ite
            (<= z x3) (cons z (lmerge x2 y)) (cons x3 (lmerge x x4))))))))))
(define-fun-rec
  pairwise
  ((x (list (list Int)))) (list (list Int))
  (match x
    ((nil (_ nil (list Int)))
     ((cons xs y)
      (match y
        ((nil (cons xs (_ nil (list Int))))
         ((cons ys xss) (cons (lmerge xs ys) (pairwise xss)))))))))
(define-fun-rec
  mergingbu
  ((x (list (list Int)))) (list Int)
  (match x
    ((nil (_ nil Int))
     ((cons xs y)
      (match y
        ((nil xs)
         ((cons z x2) (mergingbu (pairwise x)))))))))
(define-fun
  msortbu
  ((x (list Int))) (list Int)
  (mergingbu (map (lambda ((y Int)) (cons y (_ nil Int))) x)))
(prove (forall ((xs (list Int))) (ordered (msortbu xs))))
