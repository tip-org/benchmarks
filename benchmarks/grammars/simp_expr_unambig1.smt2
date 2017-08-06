; Show function for a simple expression language
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Tok :source SimpleExpr1.Tok (C :source SimpleExpr1.C)
     (D :source SimpleExpr1.D) (X :source SimpleExpr1.X)
     (Y :source SimpleExpr1.Y) (Pl :source SimpleExpr1.Pl))))
(declare-datatypes ()
  ((E :source SimpleExpr1.E
     (Plus :source SimpleExpr1.Plus (proj1-Plus E) (proj2-Plus E))
     (EX :source SimpleExpr1.EX) (EY :source SimpleExpr1.EY))))
(define-fun-rec
  (par (a)
    (++ :source Prelude.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  lin :source SimpleExpr1.lin
    ((x E)) (list Tok)
    (match x
      (case (Plus a b)
        (++ (cons C (as nil (list Tok)))
          (++ (lin a)
            (++ (cons Pl (as nil (list Tok)))
              (++ (lin b) (cons D (as nil (list Tok))))))))
      (case EX (cons X (as nil (list Tok))))
      (case EY (cons Y (as nil (list Tok))))))
(prove
  :source SimpleExpr1.prop_unambig1
  (forall ((u E) (v E)) (=> (= (lin u) (lin v)) (= u v))))
