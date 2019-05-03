; Tree sort
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((zero) (succ (p Nat))))
(declare-datatype
  Tree
  ((TNode (proj1-TNode Tree) (proj2-TNode Nat) (proj3-TNode Tree))
   (TNil)))
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
  elem
  (par (a) (((x a) (y (list a))) Bool))
  (match y
    ((nil false)
     ((cons z xs) (or (= z x) (elem x xs))))))
(define-fun-rec
  deleteBy
  (par (a) (((x (=> a (=> a Bool))) (y a) (z (list a))) (list a)))
  (match z
    ((nil (_ nil a))
     ((cons y2 ys)
      (ite (@ (@ x y) y2) ys (cons y2 (deleteBy x y ys)))))))
(define-fun-rec
  isPermutation
  (par (a) (((x (list a)) (y (list a))) Bool))
  (match x
    ((nil
      (match y
        ((nil true)
         ((cons z x2) false))))
     ((cons x3 xs)
      (and (elem x3 y)
        (isPermutation xs
          (deleteBy (lambda ((x4 a)) (lambda ((x5 a)) (= x4 x5))) x3 y)))))))
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
(prove (forall ((xs (list Nat))) (isPermutation (tsort xs) xs)))
