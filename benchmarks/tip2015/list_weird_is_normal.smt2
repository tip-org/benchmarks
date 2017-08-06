; List monad laws
;
; Here, weird_concat is a somewhat sensible concatenation function,
; and has a somewhat strange recursion pattern.
(declare-sort Any 0)
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (weird_concat :source ListMonad.weird_concat
       ((x (list (list a)))) (list a)
       (match x
         (case nil (_ nil a))
         (case (cons y xss)
           (match y
             (case nil (weird_concat xss))
             (case (cons z xs) (cons z (weird_concat (cons xs xss))))))))))
(define-fun-rec
  (par (a)
    (++ :source Prelude.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  (par (a)
    (concat :let :source Prelude.concat
       ((x (list (list a)))) (list a)
       (match x
         (case nil (_ nil a))
         (case (cons y xs) (++ y (concat xs)))))))
(prove
  :source ListMonad.prop_weird_is_normal
  (par (a)
    (forall ((x (list (list Any)))) (= (concat x) (weird_concat x)))))
