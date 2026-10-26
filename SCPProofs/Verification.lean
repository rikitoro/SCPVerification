import SCPModel.System

namespace SCP.Checked

variable {α : Type}

theorem safety
  {input : List α} {s : SCPModular.System.State α}
  (h : SCPModular.System.Reachable input s) :
  ∃ rest, input = s.receiver.output ++ rest := by
  sorry -- ここの証明をちゃんと作成する(か、LLMに生成させる)

theorem completed
  {input : List α} {s : SCPModular.System.State α}
  (h : SCPModular.System.Reachable input s)
  (hempty : s.sender.pending = []) :
  s.receiver.output = input := by
  sorry -- ここの証明をちゃんと作成する(か、LLMに生成させる)

end SCP.Checked
