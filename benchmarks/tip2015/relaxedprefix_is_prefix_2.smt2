; Relaxed prefix from VerifyThis: etaps2015.verifythis.org
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((It (A) (B) (C))))
(define-funs-rec
  ((eq ((x It) (y It)) bool))
  ((match x
     (case A
       (match y
         (case default false)
         (case A true)))
     (case B
       (match y
         (case default false)
         (case B true)))
     (case C
       (match y
         (case default false)
         (case C true))))))
(define-funs-rec
  ((isPrefix ((x (list It)) (y (list It))) bool))
  ((match x
     (case nil true)
     (case (cons z x2)
       (match y
         (case nil false)
         (case (cons x3 x4) (ite (eq z x3) (isPrefix x2 x4) false)))))))
(define-funs-rec
  ((isRelaxedPrefix ((x (list It)) (y (list It))) bool))
  ((match x
     (case nil true)
     (case (cons z x2)
       (match x2
         (case nil true)
         (case (cons x3 x4)
           (match y
             (case nil false)
             (case (cons x5 x6)
               (ite (eq z x5) (isRelaxedPrefix x2 x6) (isPrefix x2 y))))))))))
(define-funs-rec
  ((append ((x (list It)) (y (list It))) (list It)))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (append xs y))))))
(assert-not
  (forall ((x It) (xs (list It)) (ys (list It)) (zs (list It)))
    (isRelaxedPrefix
    (append (append xs (cons x (as nil (list It)))) ys)
      (append (append xs ys) zs))))
(check-sat)
