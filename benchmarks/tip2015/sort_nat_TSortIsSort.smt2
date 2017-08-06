; Tree sort
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree :source Sort.Tree
     (TNode :source Sort.TNode (proj1-TNode (Tree a))
       (proj2-TNode a) (proj3-TNode (Tree a)))
     (TNil :source Sort.TNil))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  (par (a)
    (insert :source Sort.insert
       ((x a) (y (list a))) (list a)
       (match y
         (case nil (cons x (as nil (list a))))
         (case (cons z xs)
           (ite (<= x z) (cons x y) (cons z (insert x xs))))))))
(define-fun-rec
  (par (a)
    (isort :source Sort.sort
       ((x (list a))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y xs) (insert y (isort xs)))))))
(define-fun-rec
  (par (a)
    (flatten :source Sort.flatten
       ((x (Tree a)) (y (list a))) (list a)
       (match x
         (case (TNode q z r) (flatten q (cons z (flatten r y))))
         (case TNil y)))))
(define-fun-rec
  (par (a)
    (add :source Sort.add
       ((x a) (y (Tree a))) (Tree a)
       (match y
         (case (TNode q z r)
           (ite (<= x z) (TNode (add x q) z r) (TNode q z (add x r))))
         (case TNil (TNode (as TNil (Tree a)) x (as TNil (Tree a))))))))
(define-fun-rec
  (par (a)
    (toTree :source Sort.toTree
       ((x (list a))) (Tree a)
       (match x
         (case nil (as TNil (Tree a)))
         (case (cons y xs) (add y (toTree xs)))))))
(define-fun
  (par (a)
    (tsort :source Sort.tsort
       ((x (list a))) (list a) (flatten (toTree x) (as nil (list a))))))
(prove
  :source Sort.prop_TSortIsSort
  (forall ((x (list Nat))) (= (tsort x) (isort x))))
