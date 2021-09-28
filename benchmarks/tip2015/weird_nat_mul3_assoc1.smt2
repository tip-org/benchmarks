; Weird functions over natural numbers
;
; Property about a trinary multiplication function, defined in terms of an
; trinary addition function
; mul3 x y z = xyz + (xy + xz + yz) + (x + y + z) + 1
(declare-datatype Nat ((zero) (succ (p Nat))))
(define-fun-rec
  plus
  ((x Nat) (y Nat)) Nat
  (match x
    ((zero y)
     ((succ z) (succ (plus z y))))))
(define-fun-rec
  add3
  ((x Nat) (y Nat) (z Nat)) Nat
  (match x
    ((zero
      (match y
        ((zero z)
         ((succ x2) (plus (succ zero) (add3 zero x2 z))))))
     ((succ x3) (plus (succ zero) (add3 x3 y z))))))
(define-fun-rec
  mul3
  ((x Nat) (y Nat) (z Nat)) Nat
  (match x
    ((zero zero)
     ((succ x2)
      (match y
        ((zero zero)
         ((succ x3)
          (match z
            ((zero zero)
             ((succ x4)
              (let
                ((fail
                    (plus (succ zero)
                      (add3 (mul3 x2 x3 x4)
                        (add3 (mul3 (succ zero) x3 x4)
                          (mul3 x2 (succ zero) x4) (mul3 x2 x3 (succ zero)))
                        (add3 x2 x3 x4)))))
                (ite
                  (= x2 zero)
                  (ite (= x3 zero) (ite (= x4 zero) (succ zero) fail) fail)
                  fail))))))))))))
(prove
  (forall ((x1 Nat) (x2 Nat) (x3 Nat) (x4 Nat) (x5 Nat))
    (= (mul3 (mul3 x1 x2 x3) x4 x5) (mul3 x1 x2 (mul3 x3 x4 x5)))))
(assert
  (forall ((x Nat) (y Nat) (z Nat))
    (= (plus x (plus y z)) (plus (plus x y) z))))
(assert (forall ((x Nat) (y Nat)) (= (plus x y) (plus y x))))
(assert (forall ((x Nat)) (= (plus x zero) x)))
(assert (forall ((x Nat)) (= (plus zero x) x)))
