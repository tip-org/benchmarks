; Tree sort
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree :source Sort.Tree
     (TNode :source Sort.TNode (proj1-TNode (Tree a))
       (proj2-TNode a) (proj3-TNode (Tree a)))
     (TNil :source Sort.TNil))))
(define-fun-rec
  (par (a)
    (flatten :source Sort.flatten
       ((x (Tree a)) (y (list a))) (list a)
       (match x
         (case (TNode p z q) (flatten p (cons z (flatten q y))))
         (case TNil y)))))
(define-fun-rec
  (par (a)
    (count :source SortUtils.count
       ((x a) (y (list a))) Int
       (match y
         (case nil 0)
         (case (cons z ys)
           (ite (= x z) (+ 1 (count x ys)) (count x ys)))))))
(define-fun-rec
  (par (a)
    (add :source Sort.add
       ((x a) (y (Tree a))) (Tree a)
       (match y
         (case (TNode p z q)
           (ite (<= x z) (TNode (add x p) z q) (TNode p z (add x q))))
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
  :source Sort.prop_TSortCount
  (forall ((x Int) (y (list Int)))
    (= (count x (tsort y)) (count x y))))
