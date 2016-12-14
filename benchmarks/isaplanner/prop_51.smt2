; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (butlast
       ((x (list a))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y z)
           (match z
             (case nil (as nil (list a)))
             (case (cons x2 x3) (cons y (butlast z)))))))))
(define-fun-rec
  (par (a)
    (++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(assert-not
  (par (a)
    (forall ((xs (list a)) (x a))
      (= (butlast (++ xs (cons x (as nil (list a))))) xs))))
(check-sat)
