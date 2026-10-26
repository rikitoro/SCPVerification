import SCPModel.Types

namespace SCPModular.Receiver

/-- 受信側の状態 -/
structure State (α : Type) where
  expected : Bool -- 期待する bit
  output : List α -- これまでに受理したデータ列
  deriving Repr, DecidableEq

/-- 初期状態 -/
def initial {α : Type} : State α := ⟨false, []⟩

/-- データ受信 : 期待ビットと一致するデータを受理し、期待ビットを反転 -/
def onData {α : Type} (s : State α) (p : Packet α) : State α :=
  if p.bit = s.expected then ⟨!s.expected, s.output ++ [p.payload]⟩ -- 期待ビットと一致する場合は受理
  else s

/-- Ack 送信 : 期待ビットを送信 -/
def emitAck {α : Type} (s : State α) : Bool := s.expected


end SCPModular.Receiver
