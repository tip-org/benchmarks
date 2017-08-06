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
(define-fun-rec
  (par (a)
    (flatten :source Sort_TreeSort.flatten
       ((x (Tree a)) (y (list a))) (list a)
       (match x
         (case (Node p z q) (flatten p (cons z (flatten q y))))
         (case Nil y)))))
(define-fun-rec
  (par (a)
    (count :source SortUtils.count
       ((x a) (y (list a))) Int
       (match y
         (case nil 0)
         (case (cons z ys)
           (ite (= x z) (+ 1 (count x ys)) (count x ys)))))))
(define-fun-rec
  add :source Sort_TreeSort.add
    ((x Int) (y (Tree Int))) (Tree Int)
    (match y
      (case (Node p z q)
        (ite (<= x z) (Node (add x p) z q) (Node p z (add x q))))
      (case Nil (Node (_ Nil Int) x (_ Nil Int)))))
(define-fun-rec
  toTree :source Sort_TreeSort.toTree
    ((x (list Int))) (Tree Int)
    (match x
      (case nil (_ Nil Int))
      (case (cons y xs) (add y (toTree xs)))))
(define-fun
  tsort :source Sort_TreeSort.tsort
    ((x (list Int))) (list Int) (flatten (toTree x) (_ nil Int)))
(prove
  :source Sort_TreeSort.prop_SortPermutes
  (forall ((x Int) (y (list Int)))
    (= (count x (tsort y)) (count x y))))
