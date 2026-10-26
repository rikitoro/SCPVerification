import SCPModel.Sender
import SCPModel.Receiver

namespace SCPModular.System

variable {α : Type}

/-- 通信路の状態 -/
structure Network (α : Type) where
  dataCell : Option (Packet α)  -- Sender → Receiver
  ackCell  : Option Bool        -- Receiver → Sender
  deriving Repr, DecidableEq

/-- システム全体の状態(Sender, Receiver, Network) -/
structure State (α : Type) where
  sender    : Sender.State α
  receiver  : Receiver.State α
  network   : Network α
  deriving Repr, DecidableEq


/-- 初期状態 -/
def initial (input : List α) : State α := {
  sender    := Sender.initial input
  receiver  := Receiver.initial
  network   := ⟨none, none⟩ -- dataCell, ackDell 両方空
}

/-- データ送信 -/
def sendData (s : State α) (p : Packet α) : State α :=
  { s with network := {s.network with dataCell := some p }}

/-- データ受信 -/
def recvData (s : State α) (p : Packet α) : State α :=
  { s with
    receiver := Receiver.onData s.receiver p
    network  := { s.network with dataCell := none } }

/-- Ack 送信 -/
def sendAck (s : State α) : State α :=
  { s with network :=
    { s.network with ackCell := some $ Receiver.emitAck s.receiver} }

/-- Ack 受信 -/
def recvAck (s : State α) (b : Bool) : State α :=
  { s with
    sender := Sender.onAck s.sender b
    network := { s.network with ackCell := none } }

/-- データ損失 -/
def dropData (s : State α): State α :=
  { s with network := { s.network with dataCell := none } }

/-- Ack 損失 -/
def dropAck (s : State α) : State α :=
  { s with network := { s.network with ackCell := none } }


end SCPModular.System
