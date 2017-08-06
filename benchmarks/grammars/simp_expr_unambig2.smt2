; Show function for a simple expression language
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Tok :source SimpleExpr2.Tok (C :source SimpleExpr2.C)
     (D :source SimpleExpr2.D) (X :source SimpleExpr2.X)
     (Y :source SimpleExpr2.Y) (Pl :source SimpleExpr2.Pl))))
(declare-datatypes ()
  ((E :source SimpleExpr2.E
     (Plus :source SimpleExpr2.Plus (proj1-Plus E) (proj2-Plus E))
     (EX :source SimpleExpr2.EX) (EY :source SimpleExpr2.EY))))
(define-fun-rec
  (par (a)
    (++ :source Prelude.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  lin :source SimpleExpr2.lin
    ((x E)) (list Tok)
    (match x
      (case (Plus a b)
        (++ (cons C (_ nil Tok))
          (++ (lin a)
            (++ (cons D (cons Pl (cons C (_ nil Tok))))
              (++ (lin b) (cons D (_ nil Tok)))))))
      (case EX (cons X (_ nil Tok)))
      (case EY (cons Y (_ nil Tok)))))
(prove
  :source SimpleExpr2.prop_unambig2
  (forall ((u E) (v E)) (=> (= (lin u) (lin v)) (= u v))))
