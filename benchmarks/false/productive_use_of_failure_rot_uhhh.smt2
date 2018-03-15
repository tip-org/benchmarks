(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Nat :source Definitions.Nat
     (S :source Definitions.S (proj1-S Nat))
     (Z :source Definitions.Z))))
(define-fun-rec
  (par (a)
    (length :source Definitions.length
       ((x (list a))) Nat
       (match x
         (case nil Z)
         (case (cons y xs) (S (length xs)))))))
(define-fun-rec
  (par (a)
    (++ :source Definitions.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  (par (a)
    (rotate :source Definitions.rotate
       ((x Nat) (y (list a))) (list a)
       (match x
         (case (S z)
           (match y
             (case nil (_ nil a))
             (case (cons x2 x3) (rotate z (++ x3 (cons x2 (_ nil a)))))))
         (case Z y)))))
(prove
  :source Definitions.prop_rot_uhhh
  (forall ((xs (list Nat)) (ys (list Nat)))
    (=> (= (length xs) (length ys))
      (=> (= (rotate (length xs) (++ xs ys)) (++ xs ys)) (= xs ys)))))
