(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  (par (a)
    (elem :let :source Prelude.elem
       ((x a) (y (list a))) Bool
       (match y
         (case nil false)
         (case (cons z xs) (or (= z x) (elem x xs)))))))
(define-fun-rec
  (par (a)
    (!! :source Prelude.!!
       ((x (list a)) (y Nat)) a
       (match x
         (case (cons z x2)
           (match y
             (case Z z)
             (case (S x3) (!! x2 x3))))))))
(prove
  :source List.prop_elem
  (par (a)
    (forall ((x a) (xs (list a)))
      (=> (elem x xs) (exists ((y Nat)) (= x (!! xs y)))))))
