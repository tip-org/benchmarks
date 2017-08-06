; Show function for a simple expression language
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Tok :source SimpleExpr4.Tok (C :source SimpleExpr4.C)
     (D :source SimpleExpr4.D) (X :source SimpleExpr4.X)
     (Y :source SimpleExpr4.Y) (Pl :source SimpleExpr4.Pl))))
(declare-datatypes ()
  ((E :source SimpleExpr4.E
     (Plus :source SimpleExpr4.Plus (proj1-Plus E) (proj2-Plus E))
     (EX :source SimpleExpr4.EX) (EY :source SimpleExpr4.EY))))
(define-fun-rec
  (par (a)
    (++ :source Prelude.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-funs-rec
  ((linTerm :source SimpleExpr4.linTerm ((x E)) (list Tok))
   (lin :source SimpleExpr4.lin ((x E)) (list Tok)))
  ((match x
     (case (Plus y z)
       (++ (cons C (_ nil Tok)) (++ (lin x) (cons D (_ nil Tok)))))
     (case EX (cons X (_ nil Tok)))
     (case EY (cons Y (_ nil Tok))))
   (match x
     (case (Plus a b)
       (++ (linTerm a) (++ (cons Pl (_ nil Tok)) (linTerm b))))
     (case EX (cons X (_ nil Tok)))
     (case EY (cons Y (_ nil Tok))))))
(prove
  :source SimpleExpr4.prop_unambig4
  (forall ((u E) (v E)) (=> (= (lin u) (lin v)) (= u v))))
