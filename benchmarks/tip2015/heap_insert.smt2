; Skew heaps
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes
  () ((Heap (Node (Node_ Heap) (Node_2 Nat) (Node_3 Heap)) (Nil))))
(define-funs-rec
  ((plus ((x Nat) (x2 Nat)) Nat))
  ((match x
     (case Z x2)
     (case (S n) (S (plus n x2))))))
(define-funs-rec
  ((le ((x13 Nat) (x14 Nat)) bool))
  ((match x13
     (case Z true)
     (case
       (S d11)
       (match x14
         (case Z false)
         (case (S d12) (le d11 d12)))))))
(define-funs-rec
  ((listInsert ((x8 Nat) (x9 (list Nat))) (list Nat)))
  ((match x9
     (case nil (cons x8 x9))
     (case
       (cons y ys)
       (ite (le x8 y) (cons x8 x9) (cons y (listInsert x8 ys)))))))
(define-funs-rec
  ((merge ((x6 Heap) (x7 Heap)) Heap))
  ((match x6
     (case
       (Node d5 d6 d7)
       (match x7
         (case
           (Node d8 d9 d10)
           (ite
             (le d6 d9) (Node (merge d7 x7) d6 d5) (Node (merge x6 d10) d9 d8)))
         (case Nil x6)))
     (case Nil x7))))
(define-funs-rec
  ((toList ((x3 Nat) (x4 Heap)) (list Nat)))
  ((match x3
     (case Z (as nil (list Nat)))
     (case
       (S d)
       (match x4
         (case (Node d2 d3 d4) (cons d3 (toList d (merge d2 d4))))
         (case Nil (as nil (list Nat))))))))
(define-funs-rec
  ((insert2 ((x10 Nat) (x11 Heap)) Heap))
  ((merge (Node Nil x10 Nil) x11)))
(define-funs-rec
  ((heapSize ((x12 Heap)) Nat))
  ((match x12
     (case (Node l ds r) (plus (heapSize l) (heapSize r)))
     (case Nil Z))))
(define-funs-rec
  ((toList2 ((x5 Heap)) (list Nat))) ((toList (heapSize x5) x5)))
(assert-not
  (forall
    ((x15 Nat) (h Heap))
    (= (toList2 (insert2 x15 h)) (listInsert x15 (toList2 h)))))
(check-sat)
