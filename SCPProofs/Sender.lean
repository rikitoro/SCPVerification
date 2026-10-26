import SCPModel.Sender

namespace SCPModular.Sender

variable {α : Type}

attribute [local grind] Packet
attribute [local grind] emit onAck

/-! ## 初期状態 -/

theorem initial_pending (input : List α) :
  (initial input).pending = input := by
  rfl

theorem inital_bit (input : List α) :
  (initial input).bit = false := by
  rfl

/-! ## データ送信 -/

/-- 送信するパケットがないのは pending が空の場合に限る -/
theorem emit_eq_none_iff (s : State α) :
  emit s = none ↔ s.pending = [] := by
  grind

/-- pending の先頭を現在の送信ビットと組にして送信する -/
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


/-! ## Ack 受信 -/

/-- penging が空なら、どの Ack を受け取っても状態は変わらない -/
theorem onAck_of_pending_nil {s : State α} (b : Bool)
  (hpending : s.pending = []) :
  onAck s b = s := by
  grind

/-- 現在の送信ビットと同じ Ack では、状態を進めない -/
@[simp, grind =]
theorem onAck_of_bit_eq {s : State α} {b : Bool}
  (hbit : b = s.bit) :
  onAck s b = s := by
  grind

/-- pending が空でなく ACK が異なるなら、pending から先頭を除き、送信ビットを ACK に更新する -/
@[simp, grind .]
theorem onAck_of_pending_cons_of_bit_ne {s : State α} {x : α} {xs : List α} {b : Bool}
  (hpending : s.pending = x :: xs) (hbit : b ≠ s.bit) :
  onAck s b = ⟨xs, b⟩ := by
  grind

end SCPModular.Sender
