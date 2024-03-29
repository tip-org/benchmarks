; Weird functions over natural numbers
;
; Property about a trinary multiplication function, defined in terms of an
; accumulative trinary addition function
; mul3acc x y z = xyz + (xy + xz + yz) + (x + y + z) + 1
(declare-datatype Nat ((zero) (succ (p Nat))))
(define-fun-rec
  plus
  ((x Nat) (y Nat)) Nat
  (match x
    ((zero y)
     ((succ z) (succ (plus z y))))))
(define-fun-rec
  add3acc
  ((x Nat) (y Nat) (z Nat)) Nat
  (match x
    ((zero
      (match y
        ((zero z)
         ((succ x2) (add3acc zero x2 (succ z))))))
     ((succ x3) (add3acc x3 (succ y) z)))))
(define-fun-rec
  mul3acc
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
                      (add3acc (mul3acc x2 x3 x4)
                        (add3acc (mul3acc (succ zero) x3 x4)
                          (mul3acc x2 (succ zero) x4) (mul3acc x2 x3 (succ zero)))
                        (add3acc x y z)))))
                (match x2
                  ((zero
                    (match x3
                      ((zero
                        (match x4
                          ((zero (succ zero))
                           ((succ x5) fail))))
                       ((succ x6) fail))))
                   ((succ x7) fail))))))))))))))
(prove
  (forall ((x Nat) (y Nat) (z Nat))
    (= (mul3acc x y z) (mul3acc x z y))))
(assert
  (forall ((x Nat) (y Nat) (z Nat))
    (= (plus x (plus y z)) (plus (plus x y) z))))
(assert (forall ((x Nat) (y Nat)) (= (plus x y) (plus y x))))
(assert (forall ((x Nat)) (= (plus x zero) x)))
(assert (forall ((x Nat)) (= (plus zero x) x)))
