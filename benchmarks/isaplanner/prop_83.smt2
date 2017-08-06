; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a b)
  ((pair :source |Prelude.(,)|
     (pair2 :source |Prelude.(,)| (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Nat :source Definitions.Nat (Z :source Definitions.Z)
     (S :source Definitions.S (proj1-S Nat)))))
(define-fun-rec
  (par (a b)
    (zip :source Definitions.zip
       ((x (list a)) (y (list b))) (list (pair a b))
       (match x
         (case nil (_ nil (pair a b)))
         (case (cons z x2)
           (match y
             (case nil (_ nil (pair a b)))
             (case (cons x3 x4) (cons (pair2 z x3) (zip x2 x4)))))))))
(define-fun-rec
  (par (a)
    (take :source Definitions.take
       ((x Nat) (y (list a))) (list a)
       (match x
         (case Z (_ nil a))
         (case (S z)
           (match y
             (case nil (_ nil a))
             (case (cons x2 x3) (cons x2 (take z x3)))))))))
(define-fun-rec
  (par (a)
    (len :source Definitions.len
       ((x (list a))) Nat
       (match x
         (case nil Z)
         (case (cons y xs) (S (len xs)))))))
(define-fun-rec
  (par (a)
    (drop :source Definitions.drop
       ((x Nat) (y (list a))) (list a)
       (match x
         (case Z y)
         (case (S z)
           (match y
             (case nil (_ nil a))
             (case (cons x2 x3) (drop z x3))))))))
(define-fun-rec
  (par (a)
    (++ :source Definitions.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(prove
  :source Properties.prop_83
  (par (b a)
    (forall ((xs (list a)) (ys (list a)) (zs (list b)))
      (= (zip (++ xs ys) zs)
        (++ (zip xs (take (len xs) zs)) (zip ys (drop (len xs) zs)))))))
