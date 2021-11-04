; Lemmas from "Productive Use of Failure in Inductive Proof",
; Andrew Ireland and Alan Bundy, JAR 1996
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(define-fun-rec
  rev
  (par (a) (((x (list a))) (list a)))
  (match x
    ((nil (_ nil a))
     ((cons y xs) (++ (rev xs) (cons y (_ nil a)))))))
(prove
  (par (a)
    (forall ((x (list a)) (y a))
      (= (rev (++ x (cons y (_ nil a)))) (cons y (rev x))))))
