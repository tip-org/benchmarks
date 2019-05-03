; Property from "Productive Use of Failure in Inductive Proof",
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
(define-fun-rec
  qrevflat
  (par (a) (((x (list (list a))) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons xs xss) (qrevflat xss (++ (rev xs) y))))))
(define-fun-rec
  revflat
  (par (a) (((x (list (list a)))) (list a)))
  (match x
    ((nil (_ nil a))
     ((cons xs xss) (++ (revflat xss) (rev xs))))))
(prove
  (par (a)
    (forall ((x (list (list a))))
      (= (revflat x) (qrevflat x (_ nil a))))))
