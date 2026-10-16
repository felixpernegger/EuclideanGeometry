# Euclidean Geometry in Lean 4

A formalization of planar Euclidean geometry from scratch in Lean 4 (~14,000 lines).

## Highlights
- Ceva's theorem (#61 on the Formalizing 100 Theorems list)
- Thales Theorem
- (Unique) Existence of circumcircle, orthocenter
- Power of point


## Approach

Unlike Mathlib, this formalization works with points as complex numbers.
This makes the results less general, but it turns many geometric statements
(e.g. the Pythagorean theorem) into algebraic calculations that Lean's tactics
can carry out, enabling computational proofs that would otherwise be out of reach.
