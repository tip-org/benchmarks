(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree :source Tree.Tree
     (Node :source Tree.Node (proj1-Node (Tree a))
       (proj2-Node a) (proj3-Node (Tree a)))
     (Nil :source Tree.Nil))))
(define-fun-rec
  swap :source Tree.swap
    ((x Int) (y Int) (z (Tree Int))) (Tree Int)
    (match z
      (case (Node p x2 q)
        (ite
          (= x2 x) (Node (swap x y p) y (swap x y q))
          (ite
            (= x2 y) (Node (swap x y p) x (swap x y q))
            (Node (swap x y p) x2 (swap x y q)))))
      (case Nil (as Nil (Tree Int)))))
(define-fun-rec
  (par (a)
    (elem :let :source Prelude.elem
       ((x a) (y (list a))) Bool
       (match y
         (case nil false)
         (case (cons z xs) (or (= z x) (elem x xs)))))))
(define-fun-rec
  (par (a)
    (++ :source Prelude.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  (par (a)
    (flatten0 :source Tree.flatten0
       ((x (Tree a))) (list a)
       (match x
         (case (Node p y q)
           (++ (flatten0 p) (++ (cons y (as nil (list a))) (flatten0 q))))
         (case Nil (as nil (list a)))))))
(prove
  :source Tree.prop_SwapAB
  (forall ((p (Tree Int)) (a Int) (b Int))
    (=> (elem a (flatten0 p))
      (=> (elem b (flatten0 p))
        (and (elem a (flatten0 (swap a b p)))
          (elem b (flatten0 (swap a b p))))))))
