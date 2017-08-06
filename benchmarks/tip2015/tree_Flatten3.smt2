(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree :source Tree.Tree
     (Node :source Tree.Node (proj1-Node (Tree a))
       (proj2-Node a) (proj3-Node (Tree a)))
     (Nil :source Tree.Nil))))
(define-fun-rec
  (par (a)
    (flatten3 :source Tree.flatten3
       ((x (Tree a))) (list a)
       (match x
         (case (Node y z r)
           (match y
             (case (Node p x2 q) (flatten3 (Node p x2 (Node q z r))))
             (case Nil (cons z (flatten3 r)))))
         (case Nil (as nil (list a)))))))
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
  :source Tree.prop_Flatten3
  (par (a) (forall ((p (Tree a))) (= (flatten3 p) (flatten0 p)))))
