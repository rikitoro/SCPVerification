import SCPModel.Types

namespace SCPModular.Sender

variable {α : Type}

/-- 送信側の状態 -/
structure State (α : Type) where
  pending : List α -- 送信バッファ(未送信のデータ列)
  bit : Bool
  deriving Repr, DecidableEq

/-- 初期状態 -/
def initial (input : List α) : State α := ⟨input, false⟩

/-- 送信・再送 : タイマー等で呼び出す。Sender 側の状態を進めない -/
def emit (s : State α) : Option (Packet α) :=
  match s.pending with
  | [] => none
  | x :: _ => some ⟨x, s.bit⟩

/-- Ack 受信 : Ack は Receiver が次に期待する bit。 異なるビットで Sender 側の状態を 1 件進める-/
def onAck (s : State α) (b : Bool) : State α :=
  match s.pending with
  | [] => s
  | _ :: xs =>
    if b = s.bit then s -- 状態を進めない
    else ⟨xs, b⟩        -- 異なるビットの時は状態を 1 件進める

end SCPModular.Sender
