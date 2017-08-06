; Property from "Productive Use of Failure in Inductive Proof",
; Andrew Ireland and Alan Bundy, JAR 1996
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (++ :source Definitions.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  (par (a)
    (rev :source Definitions.rev
       ((x (list a))) (list a)
       (match x
         (case nil (_ nil a))
         (case (cons y xs) (++ (rev xs) (cons y (_ nil a))))))))
(define-fun-rec
  (par (a)
    (qrevflat :source Definitions.qrevflat
       ((x (list (list a))) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons xs xss) (qrevflat xss (++ (rev xs) y)))))))
(define-fun-rec
  (par (a)
    (revflat :source Definitions.revflat
       ((x (list (list a)))) (list a)
       (match x
         (case nil (_ nil a))
         (case (cons xs xss) (++ (revflat xss) (rev xs)))))))
(prove
  :source Properties.prop_T28
  (par (a)
    (forall ((x (list (list a))))
      (= (revflat x) (qrevflat x (_ nil a))))))
