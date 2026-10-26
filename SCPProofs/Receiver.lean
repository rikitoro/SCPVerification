import SCPModel.Receiver

namespace SCPModular.Receiver

variable {α : Type}

attribute [local grind] onData emitAck

/-! ## 初期状態 -/
@[simp]
theorem initial_expected :
  (@initial α).expected = false := by
  rfl

@[simp]
theorem initial_output :
  (@initial α).output = [] := by
  rfl

/-! ## ACK 送信 -/

/-- ACK は Receiver が次に期待するビットである -/
@[simp, grind =]
theorem emitAck_eq_expected (s : State α) :
  emitAck s = s.expected := by
  rfl

/-! ## データ受信 : 状態全体の更新 -/

/-- ビットが一致すれば受理 (期待ビット反転 & payloadを追加 ) -/
@[simp, grind =]
theorem onData_of_bit_eq {s : State α} {p : Packet α}
  (hbit : p.bit = s.expected) :
  onData s p = ⟨!s.expected, s.output ++ [p.payload]⟩ := by
  grind

/-- ビットが一致しないときは破棄し Receiver の状態は変わらない-/
@[simp, grind =]
theorem onData_of_bit_ne {s : State α} {p : Packet α}
  (hbit : p.bit ≠ s.expected) :
  onData s p = s := by
  grind

/-! ## データ受信 : 各フィールドの更新 -/

/-- 受理した場合、期待ビットが反転する -/
@[simp, grind =]
theorem onData_expected_of_bit_eq {s : State α} {p : Packet α}
  (hbit : p.bit = s.expected) :
  (onData s p).expected = !s.expected := by
  grind only [onData_of_bit_eq]

/-- 受理した場合、受信済み列の末尾に payload を 1 件追加する -/
@[simp, grind =]
theorem onData_output_of_bit_eq {s : State α} {p : Packet α}
  (hbit : p.bit = s.expected) :
  (onData s p).output = s.output ++ [p.payload] := by
  grind only [onData_of_bit_eq]

/-- 破棄した場合、期待ビットは変わらない -/
@[simp, grind =]
theorem onData_expected_of_bit_ne {s : State α} {p : Packet α}
  (hbit : p.bit ≠ s.expected) :
  (onData s p).expected = s.expected := by
  grind only [onData_of_bit_ne]

/-- 破棄した場合、受信済み列は変わらない -/
@[simp, grind =]
theorem onData_output_of_bit_ne {s : State α} {p : Packet α}
  (hbit : p.bit ≠ s.expected) :
  (onData s p).output = s.output := by
  grind only [onData_of_bit_ne]


end SCPModular.Receiver
