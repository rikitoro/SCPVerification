import SCPModel.Sender

namespace SCPModular.Sender

variable {α : Type}

attribute [local grind] Packet
attribute [local grind] emit onAck

/-! ## 初期状態 -/

@[simp]
theorem initial_pending (input : List α) :
  (initial input).pending = input := by
  rfl

@[simp, grind =]
theorem inital_bit (input : List α) :
  (initial input).bit = false := by
  rfl

/-! ## データ送信 -/

/-- 送信するパケットがないのは pending が空の場合に限る -/
@[simp, grind =]
theorem emit_eq_none_iff (s : State α) :
  emit s = none ↔ s.pending = [] := by
  grind

/-- pending の先頭を現在の送信ビットと組にして送信する -/
@[grind .]
theorem emit_of_pending_cons {s : State α} {x : α} {xs : List α}
  (hpending : s.pending = x :: xs) :
  emit s = some ⟨x, s.bit⟩ := by
  grind

/-- 送信されたパケットの payload は peding の先頭で bit は送信ビット -/
@[grind .]
theorem emit_spec {s : State α} { p : Packet α}
  (h : emit s = some p) :
  ∃ xs, s.pending = p.payload :: xs ∧ p.bit = s.bit := by
  grind

@[grind =]
theorem emit_eq_some_iff {s : State α} {p : Packet α} :
  emit s = some p ↔
  ∃ xs, s.pending = p.payload :: xs ∧ p.bit = s.bit := by
  grind


end SCPModular.Sender
