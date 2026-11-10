# Cobra 内部アーキテクチャ

- [アーキテクチャ概要](index.md)

## 1. パッケージ構成と複合ツリー
- [Command ツリーと FlagSet 遅延初期化](01_package_and_tree/command_tree_topology.md)

## 2. パーサーとコマンド解決
- [Find / Traverse と stripFlags パーサー](02_parser_and_dispatch/find_traverse_and_stripflags.md)

## 3. ライフサイクル実行エンジン
- [ExecuteC・execute() とフック連鎖](03_execution_engine/executec_and_hook_chain.md)

## 4. 関係フラググループと引数検証
- [Annotation フラググループとバリデータ](04_flag_groups_and_args/relational_flag_engine.md)

## 5. Shell Completion V2 エンジン
- [__complete プロトコルとシェル生成](05_completion_v2_engine/complete_protocol_and_shells.md)

## 6. ドキュメント合成エンジン
- [cobra/doc の再帰ツリー直列化](06_doc_synthesis/ast_free_doc_generators.md)

## 関連ガイド & 公式リンク
- [Cobra ユーザーガイド](https://cobra.drawlib.com/)
- [Cobra API リファレンス](https://cobra.drawlib.com/api/)
- [PNI501 診断レポート](https://cobra.drawlib.com/reports/pni501/)
- [Cobra 公式サイト](https://cobra.dev/)
- [GitHub リポジトリ](https://github.com/yuichi110/drawlib-cobra)
