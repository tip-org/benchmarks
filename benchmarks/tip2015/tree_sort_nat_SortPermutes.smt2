; Tree sort
;
; The sort function permutes the input list.
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
    (flatten :source Sort_TreeSort.flatten
       ((x (Tree a)) (y (list a))) (list a)
       (match x
         (case (Node q z r) (flatten q (cons z (flatten r y))))
         (case Nil y)))))
(define-fun-rec
  (par (a)
    (count :source SortUtils.count
       ((x a) (y (list a))) Nat
       (match y
         (case nil Z)
         (case (cons z ys)
           (ite (= x z) (plus (S Z) (count x ys)) (count x ys)))))))
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
  :source Sort_TreeSort.prop_SortPermutes
  (forall ((x Nat) (y (list Nat)))
    (= (count x (tsort y)) (count x y))))
