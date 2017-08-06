; Tree sort
;
; The sort function permutes the input list, version 2.
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree :source Sort_TreeSort.Tree
     (Node :source Sort_TreeSort.Node (proj1-Node (Tree a))
       (proj2-Node a) (proj3-Node (Tree a)))
     (Nil :source Sort_TreeSort.Nil))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
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
    (flatten :source Sort_TreeSort.flatten
       ((x (Tree a)) (y (list a))) (list a)
       (match x
         (case (Node q z r) (flatten q (cons z (flatten r y))))
         (case Nil y)))))
(define-fun-rec
  (par (a)
    (elem :let :source Prelude.elem
       ((x a) (y (list a))) Bool
       (match y
         (case nil false)
         (case (cons z xs) (or (= z x) (elem x xs)))))))
(define-fun-rec
  (par (a)
    (deleteBy :source Data.List.deleteBy
       ((x (=> a (=> a Bool))) (y a) (z (list a))) (list a)
       (match z
         (case nil (_ nil a))
         (case (cons y2 ys)
           (ite (@ (@ x y) y2) ys (cons y2 (deleteBy x y ys))))))))
(define-fun-rec
  (par (a)
    (isPermutation :source SortUtils.isPermutation
       ((x (list a)) (y (list a))) Bool
       (match x
         (case nil
           (match y
             (case nil true)
             (case (cons z x2) false)))
         (case (cons x3 xs)
           (and (elem x3 y)
             (isPermutation xs
               (deleteBy (lambda ((x4 a)) (lambda ((x5 a)) (= x4 x5)))
                 x3 y))))))))
(define-fun-rec
  add :source Sort_TreeSort.add
    ((x Nat) (y (Tree Nat))) (Tree Nat)
    (match y
      (case (Node q z r)
        (ite (le x z) (Node (add x q) z r) (Node q z (add x r))))
      (case Nil (Node (_ Nil Nat) x (_ Nil Nat)))))
(define-fun-rec
  toTree :source Sort_TreeSort.toTree
    ((x (list Nat))) (Tree Nat)
    (match x
      (case nil (_ Nil Nat))
      (case (cons y xs) (add y (toTree xs)))))
(define-fun
  tsort :source Sort_TreeSort.tsort
    ((x (list Nat))) (list Nat) (flatten (toTree x) (_ nil Nat)))
(prove
  :source |Sort_TreeSort.prop_SortPermutes'|
  (forall ((x (list Nat))) (isPermutation (tsort x) x)))
