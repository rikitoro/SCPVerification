# SCPVerification

SCP (a Sinple Communication Protrol) の Lean による検証

## comparator によるチェック方法

````
# モデル・課題をビルド
lake build SCPChallenge

# 課題と解答を比較
lake comparator

# 外部チェッカーも含めて検査
lake comparator --paranoid

# 証明ライブラリ全体を検証
lake check --paranoid
````

## References
1. 緒方 和博, 二木 厚吉, 中村 正樹, CafeOBJ入門(6) 通信プロトコルの検証, コンピュータソフトウェア, 2009, 26 巻, 2 号, p. 93-106