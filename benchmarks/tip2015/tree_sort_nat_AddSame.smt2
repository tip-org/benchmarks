; Tree sort
;
; Inserting an element adds one to the count of that element.
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree
     (Node (proj1-Node (Tree a)) (proj2-Node a) (proj3-Node (Tree a)))
     (Nil))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (plus z y)))))
(define-fun-rec
  le
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z true)
      (case (S z)
        (match y
          (case Z false)
          (case (S x2) (le z x2))))))
(define-fun-rec
  (par (a)
    (flatten
       ((x (Tree a)) (y (list a))) (list a)
       (match x
         (case (Node q z r) (flatten q (cons z (flatten r y))))
         (case Nil y)))))
(define-fun-rec
  (par (a)
    (count
       ((x a) (y (list a))) Nat
       (match y
         (case nil Z)
         (case (cons z ys)
           (ite (= x z) (plus (S Z) (count x ys)) (count x ys)))))))
(define-fun-rec
  add
    ((x Nat) (y (Tree Nat))) (Tree Nat)
    (match y
      (case (Node q z r)
        (ite (le x z) (Node (add x q) z r) (Node q z (add x r))))
      (case Nil (Node (as Nil (Tree Nat)) x (as Nil (Tree Nat))))))
(assert-not
  (forall ((x Nat) (t (Tree Nat)))
    (= (count x (flatten (add x t) (as nil (list Nat))))
      (plus (S Z) (count x (flatten t (as nil (list Nat))))))))
(check-sat)
