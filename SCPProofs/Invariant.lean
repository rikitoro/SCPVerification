import SCPModel.System

namespace SCPModular.System

variable {α : Type}

/-! ## 不変条件の構成要素 -/

/-- 送受信の進行状況
* ビットが同じときは受信済みの列とpendingを連結すると入力列になる
* ビットが異なるときは受信済みの列と pending の先頭を除いた残りを連結すると入力列になる
-/
@[grind]
def Progress (input : List α) (s : State α) : Prop :=
  (s.sender.bit = s.receiver.expected ∧ input = s.receiver.output ++ s.sender.pending) ∨ -- 受理されている状況
  (s.sender.bit ≠ s.receiver.expected ∧
    ∃ x rest, s.sender.pending = x :: rest ∧ input = s.receiver.output ++ rest) -- 破棄されている状況


/-- データスロットの整合性
格納されたパケットのビットが Receiver の期待ビット一致するなら
送受信のビットは同じで、payload は pending の先頭である
-/
@[grind]
def DataConsistent (s : State α) : Prop :=
  ∀ p : Packet α,
    s.network.dataCell = some p →
    p.bit = s.receiver.expected →
    s.sender.bit = s.receiver.expected ∧ ∃ rest, s.sender.pending = p.payload :: rest


/-- ACK スロットの整合性
格納された ACK が送信ビットと異なるなら、
その値は Receiver が次に期待するビットと一致する
-/
@[grind]
def AckConsistent (s : State α) : Prop :=
  ∀ b : Bool,
    s.network.ackCell = some b →
    b ≠ s.sender.bit →
    b = s.receiver.expected

/-- 進行状況と、Data, ACK 通信路の整合性をまとめたシステムの不変条件 -/
@[grind]
structure Invariant (input : List α) (s : State α) : Prop where
  progress  : Progress input s
  data      : DataConsistent s
  ack       : AckConsistent s


namespace Invariant

variable {input : List α} {s : State α}

/-! ## 不変条件から必要な情報を取り出す補題 -/

/-- ビットが同じ段階では、pending 全体が受信済みの列の残りとなる -/
@[grind .]
theorem progress_of_bit_eq
  (h : Invariant input s)
  (hbit : s.sender.bit = s.receiver.expected) :
  input = s.receiver.output ++ s.sender.pending := by
  have hp := h.progress
  grind only [Progress]

/-- ビットが異なる段階では、pending の先頭を除いた列が残りとなる -/
@[grind .]
theorem progress_of_bit_ne
  (h : Invariant input s)
  (hbit : s.sender.bit ≠ s.receiver.expected) :
  ∃ x rest,
    s.sender.pending = x :: rest ∧
    input = s.receiver.output ++ rest := by
    have hp := h.progress
    grind only [Progress]

/-- スロット内の受理可能なパケットについての送信側との対応 -/
@[grind .]
theorem data_spec
  (h : Invariant input s)
  {p : Packet α}
  (hpresent : s.network.dataCell = some p)
  (hbit : p.bit = s.receiver.expected) :
  s.sender.bit = s.receiver.expected ∧
  ∃ rest, s.sender.pending = p.payload :: rest := by
  grind [h.data]

/-- スロット内の ACK が送信ビットと異なる場合、その値は期待ビットと一致する -/
@[grind .]
theorem ack_spec
  (h : Invariant input s)
  {b : Bool}
  (hpresent : s.network.ackCell = some b)
  (hbit : b ≠ s.sender.bit) :
  b = s.receiver.expected := by
  grind [h.ack]


/-! ## 最終課題につながる補題 -/

/-- 不変条件を満たすとき、受理済みの列は入力列の prefix である -/
@[grind .]
theorem output_prefix
  (h : Invariant input s) :
  ∃ rest, input = s.receiver.output ++ rest := by
  by_cases hbit : s.sender.bit = s.receiver.expected
  · grind only [progress_of_bit_eq]
  · grind only [h.progress_of_bit_ne hbit]

/-- 不変条件を満たし pending が空なら、受信済みの列は入力列全体と一致する -/
@[grind .]
theorem output_eq_input_of_pending_nil
  (h : Invariant input s)
  (hempty : s.sender.pending = []) :
  s.receiver.output = input := by
  have hp := h.progress
  grind only [Progress]

end Invariant


end SCPModular.System
