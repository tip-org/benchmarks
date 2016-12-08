-- Weird functions over natural numbers
module WeirdInt where

import Tip

add3 :: Int -> Int -> Int -> Int
add3 0 0 z = z
add3 0 y z = 1 + add3 0 (y-1) z
add3 x y z = 1 + add3 (x-1) y z

-- Property about trinary addition function
prop_add3_spec   x y z = add3 x y z === x + (y + z)
prop_add3_rot    x y z = add3 x y z === add3 y x z
prop_add3_rrot   x y z = add3 x y z === add3 z x y
prop_add3_comm12 x y z = add3 x y z === add3 y x z
prop_add3_comm23 x y z = add3 x y z === add3 x z y
prop_add3_comm13 x y z = add3 x y z === add3 z y x
prop_add3_assoc1 x1 x2 x3 x4 x5 = add3 (add3 x1 x2 x3) x4 x5 === add3 x1 x2 (add3 x3 x4 x5)
prop_add3_assoc2 x1 x2 x3 x4 x5 = add3 (add3 x1 x2 x3) x4 x5 === add3 x1 (add3 x2 x3 x4) x5
prop_add3_assoc3 x1 x2 x3 x4 x5 = add3 x1 (add3 x2 x3 x4) x5 === add3 x1 x2 (add3 x3 x4 x5)

add3acc :: Int -> Int -> Int -> Int
add3acc 0 0 z = z
add3acc 0 y z = add3acc 0 (y-1) (z+1)
add3acc x y z = add3acc (x-1) (y+1) z

-- Property about accumulative trinary addition function
prop_add3acc_spec   x y z = add3acc x y z === x + (y + z)
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
op :: Int -> Int -> Int -> Int -> Int
op 0 b 0 d = d
op a b 0 d = op (a-1) b b d
op a b c d = op a b (c-1) (d+1)

-- Property about a 4-adic operation over natural numbers
-- op a b c d = a * b + c + d
prop_op_spec a b c d = op a b c d === a * b + c + d
prop_op_comm_comm a b c d = op a b c d === op b a d c
prop_op_assoc a b c d e = op (op a b 0 0) c d e === op a (op b c 0 0) d e
prop_op_assoc2 x a b c d = op (op x a a a) b c d === op a (op b x b b) c d

mul2 :: Int -> Int -> Int
mul2 0 y = 0
mul2 x 0 = 0
mul2 x y = 1 + add3acc (x-1) (y-1) (mul2 (x-1) (y-1))

-- Binary multiplication function with an interesting recursion structure,
-- which calls an accumulative trinary addition function.
prop_mul2_comm x y = mul2 x y === mul2 y x
prop_mul2_assoc x y z = mul2 x (mul2 y z) === mul2 (mul2 x y) z

-- xyz + (xy + xz + yz) + (x + y + z) + 1
mul3 :: Int -> Int -> Int -> Int
mul3 0 y z = 0
mul3 x 0 z = 0
mul3 x y 0 = 0
mul3 1 1 1 = 1
mul3 x y z =
    1 + (add3 (mul3 x' y' z')
       (add3 (mul3 1 y' z')
             (mul3 x' 1 z')
             (mul3 x' y' 1))
       (add3 x' y' z'))
  where
    x' = x-1
    y' = y-1
    z' = z-1

-- Property about a trinary multiplication function, defined in terms of an
-- trinary addition function
-- mul3 x y z = xyz + (xy + xz + yz) + (x + y + z) + 1
prop_mul3_spec   x y z = mul3 x y z === x * y * z
prop_mul3_rot    x y z = mul3 x y z === mul3 y x z
prop_mul3_rrot   x y z = mul3 x y z === mul3 z x y
prop_mul3_comm12 x y z = mul3 x y z === mul3 y x z
prop_mul3_comm23 x y z = mul3 x y z === mul3 x z y
prop_mul3_comm13 x y z = mul3 x y z === mul3 z y x
prop_mul3_assoc1 x1 x2 x3 x4 x5 = mul3 (mul3 x1 x2 x3) x4 x5 === mul3 x1 x2 (mul3 x3 x4 x5)
prop_mul3_assoc2 x1 x2 x3 x4 x5 = mul3 (mul3 x1 x2 x3) x4 x5 === mul3 x1 (mul3 x2 x3 x4) x5
prop_mul3_assoc3 x1 x2 x3 x4 x5 = mul3 x1 (mul3 x2 x3 x4) x5 === mul3 x1 x2 (mul3 x3 x4 x5)

mul3acc :: Int -> Int -> Int -> Int
mul3acc 0 y z = 0
mul3acc x 0 z = 0
mul3acc x y 0 = 0
mul3acc 1 1 1 = 1
mul3acc x y z =
    1 + (add3acc (mul3acc x' y' z')
        (add3acc (mul3acc 1 y' z')
              (mul3acc x' 1 z')
              (mul3acc x' y' 1))
        (add3acc x y z))
  where
    x' = x-1
    y' = y-1
    z' = z-1

-- Property about a trinary multiplication function, defined in terms of an
-- accumulative trinary addition function
-- mul3acc x y z = xyz + (xy + xz + yz) + (x + y + z) + 1
prop_mul3acc_spec   x y z = mul3acc x y z === x * y * z
prop_mul3acc_rot    x y z = mul3acc x y z === mul3acc y x z
prop_mul3acc_rrot   x y z = mul3acc x y z === mul3acc z x y
prop_mul3acc_comm12 x y z = mul3acc x y z === mul3acc y x z
prop_mul3acc_comm23 x y z = mul3acc x y z === mul3acc x z y
prop_mul3acc_comm13 x y z = mul3acc x y z === mul3acc z y x
prop_mul3acc_assoc1 x1 x2 x3acc x4 x5 = mul3acc (mul3acc x1 x2 x3acc) x4 x5 === mul3acc x1 x2 (mul3acc x3acc x4 x5)
prop_mul3acc_assoc2 x1 x2 x3acc x4 x5 = mul3acc (mul3acc x1 x2 x3acc) x4 x5 === mul3acc x1 (mul3acc x2 x3acc x4) x5
prop_mul3acc_assoc3 x1 x2 x3acc x4 x5 = mul3acc x1 (mul3acc x2 x3acc x4) x5 === mul3acc x1 x2 (mul3acc x3acc x4 x5)
prop_mul3_same  x y z = mul3 x y z === mul3acc x y z
