; Tree sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(declare-datatypes ()
  ((Tree
     (TNode (proj1-TNode Tree) (proj2-TNode Nat) (proj3-TNode Tree))
     (TNil))))
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
  ordered
    ((x (list Nat))) Bool
    (match x
      (case nil true)
      (case (cons y z)
        (match z
          (case nil true)
          (case (cons y2 xs) (and (leq y y2) (ordered z)))))))
(define-fun-rec
  flatten
    ((x Tree) (y (list Nat))) (list Nat)
    (match x
      (case (TNode q z r) (flatten q (cons z (flatten r y))))
      (case TNil y)))
(define-fun-rec
  add
    ((x Nat) (y Tree)) Tree
    (match y
      (case (TNode q z r)
        (ite (leq x z) (TNode (add x q) z r) (TNode q z (add x r))))
      (case TNil (TNode TNil x TNil))))
(define-fun-rec
  toTree
    ((x (list Nat))) Tree
    (match x
      (case nil TNil)
      (case (cons y xs) (add y (toTree xs)))))
(define-fun
  tsort ((x (list Nat))) (list Nat) (flatten (toTree x) (_ nil Nat)))
(prove (forall ((xs (list Nat))) (ordered (tsort xs))))
