import SCPProofs.Composition
namespace SCP.Checked

variable {α : Type}

theorem safety
  {input : List α} {s : SCPModular.System.State α}
  (h : SCPModular.System.Reachable input s) :
  ∃ rest, input = s.receiver.output ++ rest := by
  grind [SCPModular.System.reachable_invariant h]

theorem completed
  {input : List α} {s : SCPModular.System.State α}
  (h : SCPModular.System.Reachable input s)
  (hempty : s.sender.pending = []) :
  s.receiver.output = input := by
  grind [SCPModular.System.reachable_invariant h]

end SCP.Checked
