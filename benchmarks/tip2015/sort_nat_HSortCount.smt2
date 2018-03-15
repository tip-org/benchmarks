; Heap sort (using skew heaps, efficient list-to-heap conversion)
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(declare-datatypes ()
  ((Heap :source Sort.Heap
     (Node :source Sort.Node (proj1-Node Heap)
       (proj2-Node Nat) (proj3-Node Heap))
     (Nil :source Sort.Nil))))
(define-fun-rec
  toHeap :let
    ((x (list Nat))) (list Heap)
    (match x
      (case nil (_ nil Heap))
      (case (cons y z) (cons (Node Nil y Nil) (toHeap z)))))
(define-fun-rec
  plus :definition :source |+|
    ((x Nat) (y Nat)) Nat
    (match x
      (case zero y)
      (case (succ z) (succ (plus z y)))))
(define-fun-rec
  leq :definition :source |<=|
    ((x Nat) (y Nat)) Bool
    (match x
      (case zero true)
      (case (succ z)
        (match y
          (case zero false)
          (case (succ x2) (leq z x2))))))
(define-fun-rec
  hmerge :source Sort.hmerge
    ((x Heap) (y Heap)) Heap
    (match x
      (case (Node z x2 x3)
        (match y
          (case (Node x4 x5 x6)
            (ite
              (leq x2 x5) (Node (hmerge x3 y) x2 z) (Node (hmerge x x6) x5 x4)))
          (case Nil x)))
      (case Nil y)))
(define-fun-rec
  hpairwise :source Sort.hpairwise
    ((x (list Heap))) (list Heap)
    (match x
      (case nil (_ nil Heap))
      (case (cons q y)
        (match y
          (case nil (cons q (_ nil Heap)))
          (case (cons r qs) (cons (hmerge q r) (hpairwise qs)))))))
(define-fun-rec
  hmerging :source Sort.hmerging
    ((x (list Heap))) Heap
    (match x
      (case nil Nil)
      (case (cons q y)
        (match y
          (case nil q)
          (case (cons z x2) (hmerging (hpairwise x)))))))
(define-fun
  toHeap2 :source Sort.toHeap
    ((x (list Nat))) Heap (hmerging (toHeap x)))
(define-fun-rec
  toList :source Sort.toList
    ((x Heap)) (list Nat)
    (match x
      (case (Node q y r) (cons y (toList (hmerge q r))))
      (case Nil (_ nil Nat))))
(define-fun
  hsort :source Sort.hsort
    ((x (list Nat))) (list Nat) (toList (toHeap2 x)))
(define-fun-rec
  (par (a)
    (count :source SortUtils.count
       ((x a) (y (list a))) Nat
       (match y
         (case nil zero)
         (case (cons z ys)
           (ite (= x z) (plus (succ zero) (count x ys)) (count x ys)))))))
(prove
  :source Sort.prop_HSortCount
  (forall ((x Nat) (xs (list Nat)))
    (= (count x (hsort xs)) (count x xs))))
(assert
  :axiom |associativity of +|
  (forall ((x Nat) (y Nat) (z Nat))
    (= (plus x (plus y z)) (plus (plus x y) z))))
(assert
  :axiom |commutativity of +|
  (forall ((x Nat) (y Nat)) (= (plus x y) (plus y x))))
(assert
  :axiom |identity for +|
  (forall ((x Nat)) (= (plus x zero) x)))
(assert
  :axiom |identity for +|
  (forall ((x Nat)) (= (plus zero x) x)))
