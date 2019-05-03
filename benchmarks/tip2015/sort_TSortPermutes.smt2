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
(prove (forall ((xs (list Int))) (isPermutation (tsort xs) xs)))
