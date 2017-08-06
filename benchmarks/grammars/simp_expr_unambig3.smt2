; Show function for a simple expression language
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Tok :source SimpleExpr3.Tok (C :source SimpleExpr3.C)
     (D :source SimpleExpr3.D) (X :source SimpleExpr3.X)
     (Y :source SimpleExpr3.Y) (Pl :source SimpleExpr3.Pl))))
(declare-datatypes ()
  ((E :source SimpleExpr3.E
     (Plus :source SimpleExpr3.Plus (proj1-Plus E) (proj2-Plus E))
     (EX :source SimpleExpr3.EX) (EY :source SimpleExpr3.EY))))
(define-fun-rec
  (par (a)
    (++ :source Prelude.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  lin :source SimpleExpr3.lin
    ((x E)) (list Tok)
    (match x
      (case (Plus a b)
        (++ (cons C (as nil (list Tok)))
          (++ (lin a) (++ (cons D (cons Pl (as nil (list Tok)))) (lin b)))))
      (case EX (cons X (as nil (list Tok))))
      (case EY (cons Y (as nil (list Tok))))))
(prove
  :source SimpleExpr3.prop_unambig3
  (forall ((u E) (v E)) (=> (= (lin u) (lin v)) (= u v))))
