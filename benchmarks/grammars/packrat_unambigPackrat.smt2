; Show unambiguity of the following grammar:
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Tok (X) (Y) (Z))))
(declare-datatypes () ((B (SB (SB_0 B)) (ZB))))
(declare-datatypes () ((A (SA (SA_0 A)) (ZA))))
(declare-datatypes () ((S (A2 (A_0 A)) (B2 (B_0 B)))))
(define-fun-rec
  (par (a)
    (append
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (append xs y)))))))
(define-fun-rec
  linA
    ((x A)) (list Tok)
    (match x
      (case (SA a)
        (append (append (cons X (as nil (list Tok))) (linA a))
          (cons Y (as nil (list Tok)))))
      (case ZA (cons X (cons Z (cons Y (as nil (list Tok))))))))
(define-fun-rec
  linB
    ((x B)) (list Tok)
    (match x
      (case (SB b)
        (append (append (cons X (as nil (list Tok))) (linB b))
          (cons Y (cons Y (as nil (list Tok))))))
      (case ZB (cons X (cons Z (cons Y (cons Y (as nil (list Tok)))))))))
(define-fun
  linS
    ((x S)) (list Tok)
    (match x
      (case (A2 a) (linA a))
      (case (B2 b) (linB b))))
(assert-not
  (forall ((u S) (v S)) (=> (= (linS u) (linS v)) (= u v))))
(check-sat)
