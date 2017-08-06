(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (interleave :source List.interleave
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (interleave y xs)))))))
(define-funs-rec
  ((par (a) (evens :source List.evens ((x (list a))) (list a)))
   (par (a) (odds :source List.odds ((x (list a))) (list a))))
  ((match x
     (case nil (as nil (list a)))
     (case (cons y xs) (cons y (odds xs))))
   (match x
     (case nil (as nil (list a)))
     (case (cons y xs) (evens xs)))))
(prove
  :source List.prop_Interleave
  (par (a)
    (forall ((xs (list a))) (= (interleave (evens xs) (odds xs)) xs))))
