; Show unambiguity of the following grammar:
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Tok (X) (Y) (Z))))
(declare-datatypes () ((B2 (SB (SB_0 B2)) (ZB))))
(declare-datatypes () ((A2 (SA (SA_0 A2)) (ZA))))
(declare-datatypes () ((S (A (A_0 A2)) (B (B_0 B2)))))
(define-fun-rec
  (par (a)
    (append
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (append xs y)))))))
(define-fun-rec
  linA
    ((x A2)) (list Tok)
    (match x
      (case (SA a)
        (append (append (cons X (as nil (list Tok))) (linA a))
          (cons Y (as nil (list Tok)))))
      (case ZA (cons X (cons Z (cons Y (as nil (list Tok))))))))
(define-fun-rec
  linB
    ((x B2)) (list Tok)
    (match x
      (case (SB b)
        (append (append (cons X (as nil (list Tok))) (linB b))
          (cons Y (cons Y (as nil (list Tok))))))
      (case ZB (cons X (cons Z (cons Y (cons Y (as nil (list Tok)))))))))
(define-fun
  linS
    ((x S)) (list Tok)
    (match x
      (case (A a) (linA a))
      (case (B b) (linB b))))
(assert-not
  (forall ((u S) (v S)) (=> (= (linS u) (linS v)) (= u v))))
(check-sat)
