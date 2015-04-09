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
  ((le ((x23 Nat) (x24 Nat)) bool))
  ((match x23
     (case Z true)
     (case
       (S d11)
       (match x24
         (case Z false)
         (case (S d12) (le d11 d12)))))))
(define-funs-rec
  ((merge ((x15 Heap) (x16 Heap)) Heap))
  ((match x15
     (case
       (Node d5 d6 d7)
       (match x16
         (case
           (Node d8 d9 d10)
           (ite
             (le d6 d9) (Node (merge d7 x16) d6 d5)
             (Node (merge x15 d10) d9 d8)))
         (case Nil x15)))
     (case Nil x16))))
(define-funs-rec
  ((toList ((x8 Nat) (x9 Heap)) (list Nat)))
  ((match x8
     (case Z (as nil (list Nat)))
     (case
       (S d)
       (match x9
         (case (Node d2 d3 d4) (cons d3 (toList d (merge d2 d4))))
         (case Nil (as nil (list Nat))))))))
(define-funs-rec
  ((insert2 ((x17 Nat) (x18 Heap)) Heap))
  ((merge (Node Nil x17 Nil) x18)))
(define-funs-rec
  ((toHeap ((x11 (list Nat))) Heap))
  ((match x11
     (case nil Nil)
     (case (cons x12 xs) (insert2 x12 (toHeap xs))))))
(define-funs-rec
  ((heapSize ((x22 Heap)) Nat))
  ((match x22
     (case (Node l ds2 r) (plus (heapSize l) (heapSize r)))
     (case Nil Z))))
(define-funs-rec
  ((toList2 ((x10 Heap)) (list Nat))) ((toList (heapSize x10) x10)))
(define-funs-rec
  ((par (b c a2) (dot ((x3 (=> b c)) (x4 (=> a2 b)) (x5 a2)) c)))
  ((@ x3 (@ x4 x5))))
(define-funs-rec
  ((hsort ((x19 (list Nat))) (list Nat)))
  ((dot
     (lambda ((x20 Heap)) (toList2 x20))
     (lambda ((x21 (list Nat))) (toHeap x21)) x19)))
(define-funs-rec
  ((and2 ((x6 bool) (x7 bool)) bool)) ((ite x6 x7 x6)))
(define-funs-rec
  ((ordered ((x13 (list Nat))) bool))
  ((match x13
     (case nil true)
     (case
       (cons x14 ds)
       (match ds
         (case nil true)
         (case (cons y xs2) (and2 (le x14 y) (ordered ds))))))))
(assert (not (forall ((ds3 (list Nat))) (ordered (hsort ds3)))))
(check-sat)
