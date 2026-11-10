# Cobra ユーザーガイド

- [ガイド概要](index.md)

## 1. イントロ & クイックスタート
- [Cobra の設計思想と CLI 哲学](01_getting_started/overview.md)
- [クイックスタートとサブコマンド構築](01_getting_started/quickstart.md)

## 2. 大規模 CLI アーキテクチャ設計
- [ファクトリ関数・Options・DI パターン](02_enterprise_cli_architecture/factory_pattern_and_di.md)
- [マルチパッケージ構成とインメモリテスト](02_enterprise_cli_architecture/package_layout_and_testing.md)

## 3. コマンド・フラグ・引数検証
- [Persistent / Local フラグと継承機構](03_commands_flags_and_args/persistent_and_local_flags.md)
- [位置引数バリデータとフラググループ制約](03_commands_flags_and_args/positional_args_and_flag_groups.md)

## 4. 設定管理と Viper 統合
- [6階層の設定優先順位と Viper バインド](04_configuration_and_viper/viper_precedence_and_binding.md)

## 5. シェル補完 V2 と CLI UX
- [Shell Completion V2 と Directive 制御](05_completions_and_ux/shell_completions_v2.md)
- [ActiveHelp・タイポ提案・ヘルプテンプレート](05_completions_and_ux/active_help_and_suggestions.md)

## 6. 実行ライフサイクルとドキュメント生成
- [6段階フック・エラー設計・Context シグナル](06_execution_and_operations/lifecycle_hooks_and_context.md)
- [ドキュメント自動生成（MD/Man/YAML）と配布](06_execution_and_operations/doc_generation_and_release.md)

## 関連ガイド & 公式リンク
- [Cobra API リファレンス](https://cobra.drawlib.com/api/)
- [Cobra 内部アーキテクチャ解説](https://cobra.drawlib.com/architecture/)
- [PNI501 診断レポート](https://cobra.drawlib.com/reports/pni501/)
- [Cobra 公式サイト](https://cobra.dev/)
- [GitHub リポジトリ](https://github.com/yuichi110/drawlib-cobra)
