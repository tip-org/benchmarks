; Skew heaps
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes ()
  ((Heap (Node (Node_0 Heap) (Node_1 Nat) (Node_2 Heap)) (Nil))))
(define-funs-rec
  ((plus ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z y)
     (case (S n) (S (plus n y))))))
(define-funs-rec
  ((le ((x Nat) (y Nat)) bool))
  ((match x
     (case Z true)
     (case (S z)
       (match y
         (case Z false)
         (case (S x2) (le z x2)))))))
(define-funs-rec
  ((listInsert ((x Nat) (y (list Nat))) (list Nat)))
  ((match y
     (case nil (cons x y))
     (case (cons z ys)
       (ite (le x z) (cons x y) (cons z (listInsert x ys)))))))
(define-funs-rec
  ((merge ((x Heap) (y Heap)) Heap))
  ((match x
     (case (Node z x2 x3)
       (match y
         (case (Node x4 x5 x6)
           (ite
             (le x2 x5) (Node (merge x3 y) x2 z) (Node (merge x x6) x5 x4)))
         (case Nil x)))
     (case Nil y))))
(define-funs-rec
  ((toList ((x Nat) (y Heap)) (list Nat)))
  ((match x
     (case Z (as nil (list Nat)))
     (case (S z)
       (match y
         (case (Node x2 x3 x4) (cons x3 (toList z (merge x2 x4))))
         (case Nil (as nil (list Nat))))))))
(define-funs-rec
  ((insert2 ((x Nat) (y Heap)) Heap)) ((merge (Node Nil x Nil) y)))
(define-funs-rec
  ((heapSize ((x Heap)) Nat))
  ((match x
     (case (Node l y r) (S (plus (heapSize l) (heapSize r))))
     (case Nil Z))))
(define-funs-rec
  ((toList2 ((x Heap)) (list Nat))) ((toList (heapSize x) x)))
(assert-not
  (forall ((x Nat) (h Heap))
    (= (toList2 (insert2 x h)) (listInsert x (toList2 h)))))
(check-sat)
