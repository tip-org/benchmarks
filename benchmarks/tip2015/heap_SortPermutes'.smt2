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
  ((or2 ((x6 bool) (x7 bool)) bool)) ((ite x6 x6 x7)))
(define-funs-rec
  ((par (a3) (null ((x10 (list a3))) bool)))
  ((match x10
     (case nil true)
     (case (cons ds ds2) false))))
(define-funs-rec
  ((le ((x34 Nat) (x35 Nat)) bool))
  ((match x34
     (case Z true)
     (case
       (S d12)
       (match x35
         (case Z false)
         (case (S d13) (le d12 d13)))))))
(define-funs-rec
  ((merge ((x16 Heap) (x17 Heap)) Heap))
  ((match x16
     (case
       (Node d5 d6 d7)
       (match x17
         (case
           (Node d8 d9 d10)
           (ite
             (le d6 d9) (Node (merge d7 x17) d6 d5)
             (Node (merge x16 d10) d9 d8)))
         (case Nil x16)))
     (case Nil x17))))
(define-funs-rec
  ((toList ((x11 Nat) (x12 Heap)) (list Nat)))
  ((match x11
     (case Z (as nil (list Nat)))
     (case
       (S d)
       (match x12
         (case (Node d2 d3 d4) (cons d3 (toList d (merge d2 d4))))
         (case Nil (as nil (list Nat))))))))
(define-funs-rec
  ((insert2 ((x21 Nat) (x22 Heap)) Heap))
  ((merge (Node Nil x21 Nil) x22)))
(define-funs-rec
  ((toHeap ((x14 (list Nat))) Heap))
  ((match x14
     (case nil Nil)
     (case (cons x15 xs) (insert2 x15 (toHeap xs))))))
(define-funs-rec
  ((heapSize ((x26 Heap)) Nat))
  ((match x26
     (case (Node l ds3 r) (plus (heapSize l) (heapSize r)))
     (case Nil Z))))
(define-funs-rec
  ((toList2 ((x13 Heap)) (list Nat))) ((toList (heapSize x13) x13)))
(define-funs-rec
  ((equal ((x31 Nat) (x32 Nat)) bool))
  ((match x31
     (case
       Z
       (match x32
         (case Z true)
         (case (S d11) false)))
     (case
       (S x33)
       (match x32
         (case Z false)
         (case (S y3) (equal x33 y3)))))))
(define-funs-rec
  ((elem ((x27 Nat) (x28 (list Nat))) bool))
  ((match x28
     (case nil false)
     (case (cons y ys) (or2 (equal x27 y) (elem x27 ys))))))
(define-funs-rec
  ((par (b c a2) (dot ((x3 (=> b c)) (x4 (=> a2 b)) (x5 a2)) c)))
  ((@ x3 (@ x4 x5))))
(define-funs-rec
  ((hsort ((x23 (list Nat))) (list Nat)))
  ((dot
     (lambda ((x24 Heap)) (toList2 x24))
     (lambda ((x25 (list Nat))) (toHeap x25)) x23)))
(define-funs-rec
  ((delete ((x29 Nat) (x30 (list Nat))) (list Nat)))
  ((match x30
     (case nil x30)
     (case
       (cons y2 ys2)
       (ite (equal x29 y2) ys2 (cons y2 (delete x29 ys2)))))))
(define-funs-rec
  ((and2 ((x8 bool) (x9 bool)) bool)) ((ite x8 x9 x8)))
(define-funs-rec
  ((isPermutation ((x18 (list Nat)) (x19 (list Nat))) bool))
  ((match x18
     (case nil (null x19))
     (case
       (cons x20 xs2)
       (and2 (elem x20 x19) (isPermutation xs2 (delete x20 x19)))))))
(assert-not
  (forall ((ds4 (list Nat))) (isPermutation (hsort ds4) ds4)))
(check-sat)
