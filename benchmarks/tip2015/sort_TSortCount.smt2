; Tree sort
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype
  Tree
  ((TNode (proj1-TNode Tree) (proj2-TNode Int) (proj3-TNode Tree))
   (TNil)))
(define-fun-rec
  flatten
  ((x Tree) (y (list Int))) (list Int)
  (match x
    (((TNode p z q) (flatten p (cons z (flatten q y))))
     (TNil y))))
(define-fun-rec
  count
  (par (a) (((x a) (y (list a))) Int))
  (match y
    ((nil 0)
     ((cons z ys) (ite (= x z) (+ 1 (count x ys)) (count x ys))))))
(define-fun-rec
  add
  ((x Int) (y Tree)) Tree
  (match y
    (((TNode p z q)
      (ite (<= x z) (TNode (add x p) z q) (TNode p z (add x q))))
     (TNil (TNode TNil x TNil)))))
(define-fun-rec
  toTree
  ((x (list Int))) Tree
  (match x
    ((nil TNil)
     ((cons y xs) (add y (toTree xs))))))
(define-fun
  tsort
  ((x (list Int))) (list Int) (flatten (toTree x) (_ nil Int)))
(prove
  (forall ((x Int) (xs (list Int)))
    (= (count x (tsort xs)) (count x xs))))
