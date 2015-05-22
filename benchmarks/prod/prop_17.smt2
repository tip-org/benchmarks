; Property from "Productive Use of Failure in Inductive Proof",
; Andrew Ireland and Alan Bundy, JAR 1996
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (append xs y))))))
(define-funs-rec
  ((par (a) (rev ((x (list a))) (list a))))
  ((match x
     (case nil (as nil (list a)))
     (case (cons y xs) (append (rev xs) (cons y (as nil (list a))))))))
(assert-not
  (par (a)
    (forall ((x (list a)) (y (list a)))
      (= (rev (rev (append x y)))
        (append (rev (rev x)) (rev (rev y)))))))
(check-sat)
