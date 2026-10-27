import SCPProofs.Sender
import SCPProofs.Receiver
import SCPProofs.Invariant

namespace SCPModular.System

--attribute [local grind] initial

variable {α : Type}

/-! ## 初期状態 -/

/-- 初期状態では不変条件が成立する -/
@[local grind .]
theorem invariant_initial (input : List α) :
  Invariant input (initial input) := by
  constructor
  · left
    constructor <;> rfl
  · grind [DataConsistent, initial]
  · grind [AckConsistent, initial]

/-! ## 通信路の更新 -/

variable {input : List α} {s : State α}

/-- Data 消失でも不変条件が保たれる -/
@[local grind .]
theorem invariant_dropData
  (h : Invariant input s) :
  Invariant input (dropData s) := by
  grind [dropData]

/-- ACK 消失でも不変条件が保たれる -/
@[local grind .]
theorem invariant_dropAck
  (h : Invariant input s) :
  Invariant input (dropAck s) := by
  grind [dropAck]

/-- Sender からの送信が行われも不変条件が保たれる -/
@[local grind .]
theorem invariant_sendData
  (h : Invariant input s)
  {p : Packet α}
  (hproduced : Sender.emit s.sender = some p) :
  Invariant input (sendData s p) := by
  grind [sendData]

/-- Receiver から ACK を送っても不変状態が保たれる -/
@[local grind .]
theorem invariant_sendAck
  (h : Invariant input s) :
  Invariant input (sendAck s) := by
  grind [sendAck]

/-! ## データ受信 -/

/-- スロット内のパケットを受信しても不変条件が保たれる -/
@[local grind .]
theorem invariant_recvData
  (h : Invariant input s)
  {p : Packet α}
  (hpresent : s.network.dataCell = some p) :
  Invariant input (recvData s p) := by
  by_cases hbit : p.bit = s.receiver.expected <;> grind [recvData]

/-! ## ACK 受信 -/

/-- スロット内の ACK を受信しても不変条件が保たれる -/
@[local grind .]
theorem invariant_recvAck
  (h : Invariant input s)
  {b : Bool}
  (hpresent : s.network.ackCell = some b) :
  Invariant input (recvAck s b) := by
  by_cases hbit : b = s.sender.bit
  · grind [recvAck]
  · have hbexpected : b = s.receiver.expected := by grind
    have hbits : s.sender.bit ≠ s.receiver.expected := by grind
    obtain ⟨x, rest, hpending, hinput⟩ := h.progress_of_bit_ne hbits
    have hsender : Sender.onAck s.sender b = ⟨rest, b⟩ := by grind
    grind [recvAck]

/-! ## 遷移と到達可能性 -/

/-- どの Step でも、不変条件が保たれる -/
@[local grind .]
theorem invariant_step {t : State α}
  (h : Invariant input s)
  (hstep : Step s t) :
  Invariant input t := by
  cases hstep with grind

/-- 初期状態から到達可能なすべての状態で不変条件が成り立つ -/
theorem reachable_invariant
  (h : Reachable input s) :
  Invariant input s := by
  induction h with grind

end SCPModular.System
