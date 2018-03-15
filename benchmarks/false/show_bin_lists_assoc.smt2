(declare-datatypes (a b)
  ((pair :source |Prelude.(,)|
     (pair2 :source |Prelude.(,)| (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((B :source ShowBinLists.B (I :source ShowBinLists.I)
     (O :source ShowBinLists.O))))
(define-fun half :source ShowBinLists.half ((x Int)) Int (div x 2))
(define-fun-rec
  shw :source ShowBinLists.shw
    ((x Int)) (list B)
    (ite
      (= x 0) (_ nil B)
      (let ((md (mod x 2)))
        (ite
          (=
            (ite
              (and
                (= (ite (= x 0) 0 (ite (<= x 0) (- 0 1) 1))
                  (ite (<= 2 0) (- 0 (- 0 1)) (- 0 1)))
                (distinct md 0))
              (- md 2) md)
            0)
          (cons O (shw (half x))) (cons I (shw (half x)))))))
(define-fun
  double :source ShowBinLists.double ((x Int)) Int (+ x x))
(define-fun-rec
  rd :source ShowBinLists.rd
    ((x (list B))) Int
    (match x
      (case nil 0)
      (case (cons y xs)
        (match y
          (case I (+ 1 (double (rd xs))))
          (case O (double (rd xs)))))))
(define-fun-rec
  (par (a)
    (++ :source Prelude.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun
  |#| :source |ShowBinLists.#|
    ((x Int) (y Int)) Int (rd (++ (shw x) (shw y))))
(prove
  :source ShowBinLists.prop_assoc
  (forall ((x Int) (y Int) (z Int))
    (= (|#| x (|#| y z)) (|#| (|#| x y) z))))
