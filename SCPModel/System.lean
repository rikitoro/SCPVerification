import SCPModel.Sender
import SCPModel.Receiver

namespace SCPModular.System

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


end SCPModular.System
