; Skew heaps
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes
  () ((Heap (Node (Node_ Heap) (Node_2 Nat) (Node_3 Heap)) (Nil))))
(define-funs-rec
  ((plus
      ((x Nat) (x2 Nat)) Nat
      (match x
        (case Z x2)
        (case (S n) (S (plus n x2)))))))
(define-funs-rec
  ((le
      ((x11 Nat) (x12 Nat)) bool
      (match x11
        (case Z true)
        (case
          (S d15)
          (match x12
            (case Z false)
            (case (S d16) (le d15 d16))))))))
(define-funs-rec
  ((merge
      ((x8 Heap) (x9 Heap)) Heap
      (match x8
        (case
          (Node d9 d10 d11)
          (match x9
            (case
              (Node d12 d13 d14)
              (ite
                (le d10 d13) (Node (merge d11 x9) d10 d9)
                (Node (merge x8 d14) d13 d12)))
            (case Nil x8)))
        (case Nil x9)))))
(define-funs-rec
  ((toList
      ((x3 Nat) (x4 Heap)) (list Nat)
      (match x3
        (case Z (as nil (list Nat)))
        (case
          (S d)
          (match x4
            (case (Node d2 d3 d4) (cons d3 (toList d (merge d2 d4))))
            (case Nil (as nil (list Nat)))))))))
(define-funs-rec
  ((mergeLists
      ((x6 (list Nat)) (x7 (list Nat))) (list Nat)
      (match x6
        (case nil x7)
        (case
          (cons d5 d6)
          (match x7
            (case nil x6)
            (case
              (cons d7 d8)
              (ite
                (le d5 d7) (cons d5 (mergeLists d6 x7))
                (cons d7 (mergeLists x6 d8))))))))))
(define-funs-rec
  ((heapSize
      ((x10 Heap)) Nat
      (match x10
        (case (Node l ds r) (plus (heapSize l) (heapSize r)))
        (case Nil Z)))))
(define-funs-rec
  ((toList2 ((x5 Heap)) (list Nat) (toList (heapSize x5) x5))))
(assert
  (not
    (forall
      ((x13 Heap) (y Heap))
      (=
        (toList2 (merge x13 y)) (mergeLists (toList2 x13) (toList2 y))))))
(check-sat)
