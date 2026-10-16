# Euclidean Geometry in Lean 4

A formalization of planar Euclidean geometry from scratch in Lean 4 (~14,000 lines).

## Highlights
- Ceva's theorem (#61 on the Formalizing 100 Theorems list)
- Thales Theorem
- (Unique) Existence of circumcircle, orthocenter
- Power of point


## Approach

Unlike Mathlib, this formalisation approaches Euclidean geometry via complex numbers.
On the one hand, this approach doesn't let us generalize things very much, on the other hand, using Lean's compiler this approach makes calculations via complex numbers for geometry (i.e. Pythagorean theorem) feasible, allowing computational proofs otherwise out of reach.
