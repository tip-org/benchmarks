; | A simple grammar with ambiguity
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes ()
  ((Token (Butterfly) (I) (In) (Me) (Kaleidoscope) (Saw) (The))))
(declare-datatypes () ((N (N_Butterfly) (N_Kaleidoscope))))
(declare-datatypes ()
  ((NP (Pron1) (Det (Det_0 N)) (NP_In (NP_In_0 NP) (NP_In_1 NP)))))
(declare-datatypes ()
  ((VP (See (See_0 NP)) (VP_In (VP_In_0 VP) (VP_In_1 NP)))))
(declare-datatypes () ((S (S2 (p NP) (S_1 VP)))))
(declare-datatypes () ((Case (Subj) (Obj))))
(define-fun
  linN
    ((x N)) (list Token)
    (match x
      (case N_Butterfly (cons Butterfly (as nil (list Token))))
      (case N_Kaleidoscope (cons Kaleidoscope (as nil (list Token))))))
(define-fun-rec
  (par (a)
    (append
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (append xs y)))))))
(define-fun-rec
  linNP
    ((x Case) (y NP)) (list Token)
    (match y
      (case Pron1
        (match x
          (case Subj (cons I (as nil (list Token))))
          (case Obj (cons Me (as nil (list Token))))))
      (case (Det n) (append (cons The (as nil (list Token))) (linN n)))
      (case (NP_In np1 np2)
        (append (linNP x np1)
          (append (cons In (as nil (list Token))) (linNP x np2))))))
(define-fun-rec
  linVP
    ((x VP)) (list Token)
    (match x
      (case (See np)
        (append (cons Saw (as nil (list Token))) (linNP Obj np)))
      (case (VP_In vp np2)
        (append (linVP vp)
          (append (cons In (as nil (list Token))) (linNP Obj np2))))))
(define-fun
  linS
    ((x S)) (list Token)
    (match x (case (S2 np vp) (append (linNP Subj np) (linVP vp)))))
(assert-not
  (forall ((t1 S) (t2 S))
    (or
      (distinct (linS t1)
        (cons I
          (cons Saw
            (cons The
              (cons Butterfly
                (cons In (cons The (cons Kaleidoscope (as nil (list Token))))))))))
      (or
        (distinct (linS t2)
          (cons I
            (cons Saw
              (cons The
                (cons Butterfly
                  (cons In (cons The (cons Kaleidoscope (as nil (list Token))))))))))
        (= t1 t2)))))
(check-sat)
