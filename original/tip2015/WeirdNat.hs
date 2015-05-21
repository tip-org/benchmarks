-- Weird functions over natural numbers
module WeirdNat where

import Nat
import Tip

add3 :: Nat -> Nat -> Nat -> Nat
add3 Z Z     z = z
add3 Z (S y) z = S (add3 Z y z)
add3 (S x) y z = S (add3 x y z)

-- Property about trinary addition function
prop_add3_rot    x y z = add3 x y z === add3 y x z
prop_add3_rrot   x y z = add3 x y z === add3 z x y
prop_add3_comm12 x y z = add3 x y z === add3 y x z
prop_add3_comm23 x y z = add3 x y z === add3 x z y
prop_add3_comm13 x y z = add3 x y z === add3 z y x
prop_add3_assoc1 x1 x2 x3 x4 x5 = add3 (add3 x1 x2 x3) x4 x5 === add3 x1 x2 (add3 x3 x4 x5)
prop_add3_assoc2 x1 x2 x3 x4 x5 = add3 (add3 x1 x2 x3) x4 x5 === add3 x1 (add3 x2 x3 x4) x5
prop_add3_assoc3 x1 x2 x3 x4 x5 = add3 x1 (add3 x2 x3 x4) x5 === add3 x1 x2 (add3 x3 x4 x5)

add3acc :: Nat -> Nat -> Nat -> Nat
add3acc Z Z     z = z
add3acc Z (S y) z = add3acc Z y (S z)
add3acc (S x) y z = add3acc x (S y) z

-- Property about accumulative trinary addition function
prop_add3acc_rot    x y z = add3acc x y z === add3acc y x z
prop_add3acc_rrot   x y z = add3acc x y z === add3acc z x y
prop_add3acc_comm12 x y z = add3acc x y z === add3acc y x z
prop_add3acc_comm23 x y z = add3acc x y z === add3acc x z y
prop_add3acc_comm13 x y z = add3acc x y z === add3acc z y x
prop_add3acc_assoc1 x1 x2 x3 x4 x5 = add3acc (add3acc x1 x2 x3) x4 x5 === add3acc x1 x2 (add3acc x3 x4 x5)
prop_add3acc_assoc2 x1 x2 x3 x4 x5 = add3acc (add3acc x1 x2 x3) x4 x5 === add3acc x1 (add3acc x2 x3 x4) x5
prop_add3acc_assoc3 x1 x2 x3 x4 x5 = add3acc x1 (add3acc x2 x3 x4) x5 === add3acc x1 x2 (add3acc x3 x4 x5)
prop_add3_same x y z = add3 x y z === add3acc x y z

-- a * b + c + d
op :: Nat -> Nat -> Nat -> Nat -> Nat
op Z     b Z     d = d
op a     b (S c) d = op a b c (S d)
op (S a) b Z     d = op a b b d

-- Property about a 4-adic operation over natural numbers
-- op a b c d = a * b + c + d
prop_op_comm_comm a b c d = op a b c d === op b a d c
prop_op_assoc a b c d e = op (op a b Z Z) c d e === op a (op b c Z Z) d e
prop_op_assoc2 x a b c d = op (op x a a a) b c d === op a (op b x b b) c d

mul2 :: Nat -> Nat -> Nat
mul2 Z     y     = Z
mul2 x     Z     = Z
mul2 (S x) (S y) = S (add3acc x y (mul2 x y))

-- Binary multiplication function with an interesting recursion structure,
-- which calls an accumulative trinary addition function.
prop_mul2_comm x y = mul2 x y === mul2 y x
prop_mul2_assoc x y z = mul2 x (mul2 y z) === mul2 (mul2 x y) z

-- xyz + (xy + xz + yz) + (x + y + z) + 1
mul3 :: Nat -> Nat -> Nat -> Nat
mul3 Z y z = Z
mul3 x Z z = Z
mul3 x y Z = Z
mul3 (S Z) (S Z) (S Z) = S Z
mul3 (S x) (S y) (S z) =
    S (add3 (mul3 x y z)
      (add3 (mul3 (S Z) y z)
            (mul3 x (S Z) z)
            (mul3 x y (S Z)))
      (add3 x y z))

-- Property about a trinary multiplication function, defined in terms of an
-- trinary addition function
-- mul3 x y z = xyz + (xy + xz + yz) + (x + y + z) + 1
prop_mul3_rot    x y z = mul3 x y z === mul3 y x z
prop_mul3_rrot   x y z = mul3 x y z === mul3 z x y
prop_mul3_comm12 x y z = mul3 x y z === mul3 y x z
prop_mul3_comm23 x y z = mul3 x y z === mul3 x z y
prop_mul3_comm13 x y z = mul3 x y z === mul3 z y x
prop_mul3_assoc1 x1 x2 x3 x4 x5 = mul3 (mul3 x1 x2 x3) x4 x5 === mul3 x1 x2 (mul3 x3 x4 x5)
prop_mul3_assoc2 x1 x2 x3 x4 x5 = mul3 (mul3 x1 x2 x3) x4 x5 === mul3 x1 (mul3 x2 x3 x4) x5
prop_mul3_assoc3 x1 x2 x3 x4 x5 = mul3 x1 (mul3 x2 x3 x4) x5 === mul3 x1 x2 (mul3 x3 x4 x5)

mul3acc :: Nat -> Nat -> Nat -> Nat
mul3acc Z y z = Z
mul3acc x Z z = Z
mul3acc x y Z = Z
mul3acc (S Z) (S Z) (S Z) = S Z
mul3acc (S x) (S y) (S z) =
    S (add3acc (mul3acc x y z)
      (add3acc (mul3acc (S Z) y z)
            (mul3acc x (S Z) z)
            (mul3acc x y (S Z)))
      (add3acc x y z))

-- Property about a trinary multiplication function, defined in terms of an
-- accumulative trinary addition function
-- mul3acc x y z = xyz + (xy + xz + yz) + (x + y + z) + 1
prop_mul3acc_rot    x y z = mul3acc x y z === mul3acc y x z
prop_mul3acc_rrot   x y z = mul3acc x y z === mul3acc z x y
prop_mul3acc_comm12 x y z = mul3acc x y z === mul3acc y x z
prop_mul3acc_comm23 x y z = mul3acc x y z === mul3acc x z y
prop_mul3acc_comm13 x y z = mul3acc x y z === mul3acc z y x
prop_mul3acc_assoc1 x1 x2 x3acc x4 x5 = mul3acc (mul3acc x1 x2 x3acc) x4 x5 === mul3acc x1 x2 (mul3acc x3acc x4 x5)
prop_mul3acc_assoc2 x1 x2 x3acc x4 x5 = mul3acc (mul3acc x1 x2 x3acc) x4 x5 === mul3acc x1 (mul3acc x2 x3acc x4) x5
prop_mul3acc_assoc3 x1 x2 x3acc x4 x5 = mul3acc x1 (mul3acc x2 x3acc x4) x5 === mul3acc x1 x2 (mul3acc x3acc x4 x5)
prop_mul3_same  x y z = mul3 x y z === mul3acc x y z
