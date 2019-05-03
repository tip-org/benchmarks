; Relaxed prefix in VerifyThis 2015: etaps2015.verifythis.org
; Challenge 1, submitted by Thomas Genet
;
; A way to specify the relaxed prefix function
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype It ((A) (B) (C)))
(define-fun-rec
  isPrefix
  ((x (list It)) (y (list It))) Bool
  (match x
    ((nil true)
     ((cons z x2)
      (match y
        ((nil false)
         ((cons x3 x4) (and (= z x3) (isPrefix x2 x4)))))))))
(define-fun-rec
  isRelaxedPrefix
  ((x (list It)) (y (list It))) Bool
  (match x
    ((nil true)
     ((cons z x2)
      (match x2
        ((nil true)
         ((cons x3 x4)
          (match y
            ((nil false)
             ((cons x5 x6)
              (ite (= z x5) (isRelaxedPrefix x2 x6) (isPrefix x2 y))))))))))))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(prove
  (forall ((xs (list It)) (ys (list It)))
    (isRelaxedPrefix xs (++ xs ys))))
