import Lake
open Lake DSL

package "SCPVerification" where
  version := v!"0.1.0"

-- 比較の基準となるモデル・契約
lean_lib SCPModel

-- 証明すべき命題 (証明自体は sorry )
lean_lib SCPChallenge

-- 完成した証明 (デフォルトのビルド対象)
@[default_target]
lean_lib SCPProofs
