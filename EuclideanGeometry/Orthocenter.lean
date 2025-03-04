import EuclideanGeometry.Thales
import Mathlib

open Function Set Classical

noncomputable section

/-in this section we prove the existance of the orthocenter!-/
/-First as usual a point version:-/

/-the central lemma is that the foots of the altitudes lie on the thales circles as stated here:-/
lemma thales_foot_lies_on(a b : Point)(L : Line)(h : Lies_on a L): Lies_on_circle (foot b L) (Thales_circle a b) := by{
  apply thales_inverse
  apply perp_points_perm_front
  apply perp_points_perm_back
  exact perp_points_foot a b h
}

/-or in the slightly nicer manner for triangles:-/
lemma thales_foot_lies_on_noncolinear{a b c : Point}(h : noncolinear a b c): Lies_on_circle (foot a (qLine_through b c)) (Thales_circle a b) := by{
  have t: Lies_on b (qLine_through b c) := by{exact qline_through_mem_left b c}
  rw[thales_symm]
  exact thales_foot_lies_on b a (qLine_through b c) t
}

/-The thales circle of a triangle are nonconenctric:-/
lemma thales_not_concentric{a b c : Point}(h : noncolinear a b c): ¬Concentric (Thales_circle a b) (Thales_circle a c) := by{
  unfold Concentric
  rw[thales_center, thales_center]
  contrapose h
  have : b = c := by{
    unfold pmidpoint at h
    field_simp at h
    ext
    assumption
  }
  unfold noncolinear
  simp
  apply colinear_self
  tauto
}

/-And in triangles the foots arent the same as the corners:-/
lemma noncolinear_not_on_line{a b c : Point}(h : noncolinear a b c): ¬Lies_on a (qLine_through b c) := by{
  contrapose h
  unfold noncolinear at *
  simp at *
  by_cases bc: b = c
  · apply colinear_self
    tauto
  simp [*] at h
  unfold Line_through Lies_on at h
  simp at h
  apply colinear_perm12
  apply colinear_perm23
  assumption
}

lemma noncolinear_foot_neq_point{a b c : Point}(h : noncolinear a b c): foot a (qLine_through b c) ≠ a := by{
  apply foot_point_not_on_line
  exact noncolinear_not_on_line h
}


/-the altidues of 3 noncolinear points are not parallel:-/

lemma altitudes_not_paralllel_points{a b c : Point}(h : noncolinear a b c): ¬Parallel (perp_through (qLine_through a b) c) (perp_through (qLine_through a c) b) := by{
  by_contra h0
  have g: Parallel (qLine_through a b) (qLine_through a c) := by{
    apply perp_perp (perp_through (qLine_through a b) c)
    · apply perp_symm
      exact perp_through_is_perp (qLine_through a b) c
    apply parallel_perp (perp_through (qLine_through a c) b)
    · apply parallel_symm
      assumption
    apply perp_symm
    exact perp_through_is_perp (qLine_through a c) b
  }
  contrapose g
  clear g h0
  have : pairwise_different_point3 a b c := by{exact noncolinear_imp_pairwise_different h}
  have t: pairwise_different_point3 a b c := by{exact noncolinear_imp_pairwise_different h}
  unfold pairwise_different_point3 at this
  have : a ≠ c := by{tauto}
  simp [*]
  exact noncolinear_not_parallel1 h
}

/-Because now the altidues are just the powlines of the thales circles:-/
theorem altitude_powline{a b c : Point}(h : noncolinear a b c): perp_through (qLine_through b c) a = PowLine (thales_not_concentric h) := by{
  rw[← foot_line_through (noncolinear_not_on_line h)]
  apply powline_intersection3
  constructor
  · exact thales_foot_lies_on_noncolinear h
  rw[qline_through_symm]
  apply noncolinear_perm23 at h
  exact thales_foot_lies_on_noncolinear h

  constructor
  · exact thales_mem_left a b
  exact thales_mem_left a c
}

/-The respective thales circle are cnoncolinear:-/
lemma thales_cnoncolinear{a b c : Point}(h : noncolinear a b c): cnoncolinear (Thales_circle b c) (Thales_circle c a) (Thales_circle a b) := by{
  unfold cnoncolinear
  repeat
    rw[thales_center]

  exact midtriangle_noncolinear_point h
}

theorem altitudes_copunctal_point{a b c : Point}(h : noncolinear a b c): Copunctal (perp_through (qLine_through b c) a) (perp_through (qLine_through c a) b) (perp_through (qLine_through b a) c) := by{
  have acbc: ¬Concentric (Thales_circle a c) (Thales_circle c b) := by{
    apply noncolinear_perm13 at h
    apply noncolinear_perm23 at h
    rw[thales_symm c a]
    exact thales_not_concentric h
  }
  have bcab: ¬Concentric (Thales_circle c b) (Thales_circle b a) := by{
    rw[thales_symm b c]
    apply noncolinear_perm12 at h
    apply noncolinear_perm23 at h
    exact thales_not_concentric h
  }
  rw[altitude_powline]
  apply noncolinear_perm12 at h
  rw[altitude_powline]
  have : PowLine (not_concentric_symm (thales_not_concentric h)) = PowLine bcab := by{
    rw[← qpowline_simp, ← qpowline_simp, thales_symm b c]
  }
  rw[this]
  apply noncolinear_perm23 at h
  apply noncolinear_perm12 at h
  rw[altitude_powline]
  have : PowLine (thales_not_concentric h) = PowLine acbc := by{
    rw[← qpowline_simp, ← qpowline_simp, qpowline_symm, thales_symm]
  }
  rw[this]
  apply copunctal_perm23
  repeat
    rw[← qpowline_simp]

  rw[thales_symm]
  exact powline_copunctal (thales_cnoncolinear h)

  assumption

  apply noncolinear_perm23
  assumption

  assumption
}

/-Therefore we can define the Orthocenter of a triangle:-/
/-(First a point version)-/

def Ortc_point{a b c : Point}(h : noncolinear a b c): Point :=
  Line_center (altitudes_copunctal_point h)

def Altitude_A : Triangle → Line :=
  fun T ↦ perp_through (tri_bc T) T.a

def Altitude_B : Triangle → Line :=
  fun T ↦ perp_through (tri_ca T) T.b

def Altitude_C : Triangle → Line :=
  fun T ↦ perp_through (tri_ab T) T.c

--maybe show the usual stuff here but eh

theorem altitudes_copunctal(T : Triangle): Copunctal (Altitude_A T) (Altitude_B T) (Altitude_C T) := by{
  unfold Altitude_A Altitude_B Altitude_C tri_ab tri_bc tri_ca
  obtain ⟨a,b,c,h⟩ := T
  simp
  repeat
    rw[← qline_through_line_through]
  rw[qline_through_symm a b]
  exact altitudes_copunctal_point h
}

/-And now finally:-/

def Orthocenter: Triangle → Point :=
  fun T ↦ Line_center (altitudes_copunctal T)

lemma orthocenter_lies_on_altA(T : Triangle): Lies_on (Orthocenter T) (Altitude_A T) := by{
  unfold Orthocenter
  exact line_center_on_line1 (altitudes_copunctal T)
}

lemma orthocenter_lies_on_altB(T : Triangle): Lies_on (Orthocenter T) (Altitude_B T) := by{
  unfold Orthocenter
  exact line_center_on_line2 (altitudes_copunctal T)
}

lemma orthocenter_lies_on_altC(T : Triangle): Lies_on (Orthocenter T) (Altitude_C T) := by{
  unfold Orthocenter
  exact line_center_on_line3 (altitudes_copunctal T)
}

--theorem orthocenter_unique(T : Triangle)

/-The euler line of a triangle is the line through orthocenter and circumcentre (among others!)-/

def Euler_line: Triangle → Line :=
  fun T ↦ qLine_through (Orthocenter T) (Circumcenter T)
