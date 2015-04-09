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
  ((le ((x24 Nat) (x25 Nat)) bool))
  ((match x24
     (case Z true)
     (case
       (S d12)
       (match x25
         (case Z false)
         (case (S d13) (le d12 d13)))))))
(define-funs-rec
  ((merge ((x11 Heap) (x12 Heap)) Heap))
  ((match x11
     (case
       (Node d5 d6 d7)
       (match x12
         (case
           (Node d8 d9 d10)
           (ite
             (le d6 d9) (Node (merge d7 x12) d6 d5)
             (Node (merge x11 d10) d9 d8)))
         (case Nil x11)))
     (case Nil x12))))
(define-funs-rec
  ((toList ((x6 Nat) (x7 Heap)) (list Nat)))
  ((match x6
     (case Z (as nil (list Nat)))
     (case
       (S d)
       (match x7
         (case (Node d2 d3 d4) (cons d3 (toList d (merge d2 d4))))
         (case Nil (as nil (list Nat))))))))
(define-funs-rec
  ((insert2 ((x13 Nat) (x14 Heap)) Heap))
  ((merge (Node Nil x13 Nil) x14)))
(define-funs-rec
  ((toHeap ((x9 (list Nat))) Heap))
  ((match x9
     (case nil Nil)
     (case (cons x10 xs) (insert2 x10 (toHeap xs))))))
(define-funs-rec
  ((heapSize ((x18 Heap)) Nat))
  ((match x18
     (case (Node l ds r) (plus (heapSize l) (heapSize r)))
     (case Nil Z))))
(define-funs-rec
  ((toList2 ((x8 Heap)) (list Nat))) ((toList (heapSize x8) x8)))
(define-funs-rec
  ((equal ((x21 Nat) (x22 Nat)) bool))
  ((match x21
     (case
       Z
       (match x22
         (case Z true)
         (case (S d11) false)))
     (case
       (S x23)
       (match x22
         (case Z false)
         (case (S y2) (equal x23 y2)))))))
(define-funs-rec
  ((par (b c a2) (dot ((x3 (=> b c)) (x4 (=> a2 b)) (x5 a2)) c)))
  ((@ x3 (@ x4 x5))))
(define-funs-rec
  ((hsort ((x15 (list Nat))) (list Nat)))
  ((dot
     (lambda ((x16 Heap)) (toList2 x16))
     (lambda ((x17 (list Nat))) (toHeap x17)) x15)))
(define-funs-rec
  ((count ((x19 Nat) (x20 (list Nat))) Nat))
  ((match x20
     (case nil Z)
     (case
       (cons y xs2)
       (ite (equal x19 y) (S (count x19 xs2)) (count x19 xs2))))))
(assert-not
  (forall
    ((x26 Nat) (ds2 (list Nat)))
    (= (count x26 (hsort ds2)) (count x26 ds2))))
(check-sat)
