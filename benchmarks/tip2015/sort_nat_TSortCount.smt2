; Tree sort
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((zero) (succ (p Nat))))
(declare-datatype
  Tree
  ((TNode (proj1-TNode Tree) (proj2-TNode Nat) (proj3-TNode Tree))
   (TNil)))
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
  flatten
  ((x Tree) (y (list Nat))) (list Nat)
  (match x
    (((TNode q z r) (flatten q (cons z (flatten r y))))
     (TNil y))))
(define-fun-rec
  count
  (par (a) (((x a) (y (list a))) Nat))
  (match y
    ((nil zero)
     ((cons z ys)
      (ite (= x z) (plus (succ zero) (count x ys)) (count x ys))))))
(define-fun-rec
  add
  ((x Nat) (y Tree)) Tree
  (match y
    (((TNode q z r)
      (ite (leq x z) (TNode (add x q) z r) (TNode q z (add x r))))
     (TNil (TNode TNil x TNil)))))
(define-fun-rec
  toTree
  ((x (list Nat))) Tree
  (match x
    ((nil TNil)
     ((cons y xs) (add y (toTree xs))))))
(define-fun
  tsort
  ((x (list Nat))) (list Nat) (flatten (toTree x) (_ nil Nat)))
(prove
  (forall ((x Nat) (xs (list Nat)))
    (= (count x (tsort xs)) (count x xs))))
(assert
  (forall ((x Nat) (y Nat) (z Nat))
    (= (plus x (plus y z)) (plus (plus x y) z))))
(assert (forall ((x Nat) (y Nat)) (= (plus x y) (plus y x))))
(assert (forall ((x Nat)) (= (plus x zero) x)))
(assert (forall ((x Nat)) (= (plus zero x) x)))
