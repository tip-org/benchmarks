; Show unambiguity of the following grammar:
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Tok :source Packrat.Tok (X :source Packrat.X)
     (Y :source Packrat.Y) (Z :source Packrat.Z))))
(declare-datatypes ()
  ((B2 :source Packrat.B (SB :source Packrat.SB (proj1-SB B2))
     (ZB :source Packrat.ZB))))
(declare-datatypes ()
  ((A2 :source Packrat.A (SA :source Packrat.SA (proj1-SA A2))
     (ZA :source Packrat.ZA))))
(declare-datatypes ()
  ((S :source Packrat.S (A :source Packrat.A (proj1-A A2))
     (B :source Packrat.B (proj1-B B2)))))
(define-fun-rec
  (par (a)
    (++ :source Prelude.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  linA :source Packrat.linA
    ((x A2)) (list Tok)
    (match x
      (case (SA a)
        (++ (cons X (as nil (list Tok)))
          (++ (linA a) (cons Y (as nil (list Tok))))))
      (case ZA (cons X (cons Z (cons Y (as nil (list Tok))))))))
(define-fun-rec
  linB :source Packrat.linB
    ((x B2)) (list Tok)
    (match x
      (case (SB b)
        (++ (cons X (as nil (list Tok)))
          (++ (linB b) (cons Y (cons Y (as nil (list Tok)))))))
      (case ZB (cons X (cons Z (cons Y (cons Y (as nil (list Tok)))))))))
(define-fun
  linS :source Packrat.linS
    ((x S)) (list Tok)
    (match x
      (case (A a) (linA a))
      (case (B b) (linB b))))
(prove
  :source Packrat.prop_unambigPackrat
  (forall ((u S) (v S)) (=> (= (linS u) (linS v)) (= u v))))
