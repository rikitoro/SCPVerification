import SCPModel.System

namespace SPC.Checked

variable {α : Type}

theorem safety
  {input : List α} {s : SCPModular.System.State α}
  (h : SCPModular.System.Reachable input s) :
  ∃ rest, input = s.receiver.output ++ rest := by
  sorry

theorem completed
  {input : List α} {s : SCPModular.System.State α}
  (h : SCPModular.System.Reachable input s)
  (hempty : s.sender.pending = []) :
  s.receiver.output = input := by
  sorry

end SPC.Checked
