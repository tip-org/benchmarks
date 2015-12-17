(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree (TNode (TNode_0 (Tree a)) (TNode_1 a) (TNode_2 (Tree a)))
     (TNil))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  zelem
    ((x Int) (y (list Int))) Bool
    (match y
      (case nil false)
      (case (cons z ys) (or (= x z) (zelem x ys)))))
(define-fun-rec
  zunique
    ((x (list Int))) Bool
    (match x
      (case nil true)
      (case (cons y xs) (and (not (zelem y xs)) (zunique xs)))))
(define-fun-rec
  (par (a)
    (length
       ((x (list a))) Nat
       (match x
         (case nil Z)
         (case (cons y xs) (S (length xs)))))))
(define-fun-rec
  (par (a)
    (flatten
       ((x (Tree a)) (y (list a))) (list a)
       (match x
         (case (TNode q z r) (flatten q (cons z (flatten r y))))
         (case TNil y)))))
(define-fun-rec
  add
    ((x Int) (y (Tree Int))) (Tree Int)
    (match y
      (case (TNode q z r)
        (ite (<= x z) (TNode (add x q) z r) (TNode q z (add x r))))
      (case TNil (TNode (as TNil (Tree Int)) x (as TNil (Tree Int))))))
(define-fun-rec
  toTree
    ((x (list Int))) (Tree Int)
    (match x
      (case nil (as TNil (Tree Int)))
      (case (cons y xs) (add y (toTree xs)))))
(define-fun
  tsort
    ((x (list Int))) (list Int)
    (flatten (toTree x) (as nil (list Int))))
(assert-not
  (forall ((xs (list Int)) (ys (list Int)))
    (or (distinct (tsort xs) (tsort ys))
      (or (= xs ys)
        (or (not (zunique xs))
          (or
            (distinct (length xs) (S (S (S (S (S (S (S (S (S (S Z)))))))))))
            (distinct (length ys)
              (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))))
(check-sat)
