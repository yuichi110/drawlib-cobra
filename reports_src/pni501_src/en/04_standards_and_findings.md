# 4. Audit Standards, Rule Compliance & Findings

PNI501 (`v0.1.3`) evaluated Cobra `v1.10.2` across **6 deterministic audit steps** and **14 active engineering compliance rules** spanning Go module packaging, static Go AST maintainability, library API purity, table-driven `testing` hygiene, hermetic `--network=none` container execution, and Trivy supply-chain security. Every audit step achieved Grade `S` (`90/100` to `98/100`), yielding **11 `PASS` rules**, **3 advisory `WARN` rules**, **0 `FAIL` rules**, and **8 consolidated `MEDIUM`/`LOW` location findings** (`0 CRITICAL`, `0 HIGH`).

```drawlib align=center code=fold file=audit_step_scores_bar.png caption="Figure 4.1 — Executed PNI501 Audit Step Score Comparison (Weakest-First Ascending: 90 to 98) & Compliance Posture"
from drawlib.canvas import save, setup
from drawlib.charts.bar import BarChart
from drawlib.icons import phosphor
from drawlib.shapes import rectangle
from drawlib.smartarts import KpiCards
from drawlib.styles import Colors, Styles

setup(width=158, height=74, dpi=150)

rectangle(
    (56.0, 37.0),
    width=102.0,
    height=63.0,
    style=Styles.Neutral.patch(shape_r=2.0, shape_fill_color=Colors.White, shape_line_color=Colors.Gray3),
)

chart = BarChart(
    axis_line_style=Styles.MutedDashed,
    categories=[
        "go_\nast_\naudit",
        "repo_\nstructure_\naudit",
        "library_\nhygiene_\naudit",
        "go_\ntest_\naudit",
        "container_\nruntime_\naudit",
        "security_\nvuln_\naudit",
    ],
    width=96.0,
    height=51.0,
    title="Executed Audit Step Scores (/100, Sorted Weakest -> Strongest)",
    title_style=Styles.DarkBold.patch(text_size=11.5),
    orientation="vertical",
    bar_mode="group",
    bar_width_ratio=0.54,
    bar_r=0.9,
    axis_text_style=Styles.Dark.patch(text_size=9.5),
    grid_style=Styles.MutedThin,
    value_text_style=Styles.DarkBold.patch(text_size=10.0),
    value_format="{:.0f}",
)
chart.add_series(
    "Step Score",
    [90, 92, 93, 96, 96, 98],
    style=Styles.PrimaryFlat,
)
chart.configure_y_axis(min_value=0.0, max_value=105.0, tick_step=20.0, label="Score (/100)")
chart.draw(xy=(8.0, 12.5))

kpis = KpiCards(
    style=Styles.Neutral.patch(shape_fill_color=Colors.White),
    metric_style=Styles.PrimaryBold.patch(text_size=13.8),
    text_style=Styles.DarkBold.patch(text_size=10.5),
    description_style=Styles.Muted.patch(text_size=9.5),
    accent_style=Styles.PrimaryFlat,
    icon_style=Styles.PrimaryBold,
    accent_position="left_pill",
    metric_layout="left_column",
    metric_width_ratio=0.33,
    spacing=3.0,
)
kpis.add("11 PASS", "Active Rules", "Out of 14 evaluated", icon=phosphor.check_circle)
kpis.add("3 WARN", "Advisory Rules", "0 FAIL verdicts", icon=phosphor.warning_circle, accent_style=Styles.WarningFlat)
kpis.add("0 CRIT/HIGH", "Severity Profile", "2 Medium · 6 Low", icon=phosphor.shield_check, accent_style=Styles.SecondaryFlat)
kpis.draw(xy=(110.5, 8.5), width=42.5, height=58.0, columns=1)

save()
```

---

## 4.1 Complete Rule Compliance Matrix (14 Active Rules)

| Rule ID | Verdict | Source Action | Key Deterministic Evidence |
| :--- | :---: | :--- | :--- |
| `common/architecture` | **`PASS`** | `go_ast_audit` | `internal_import_graph={'cobra': [], 'doc': []}`, `0` circular dependencies, `100.0%` import hygiene |
| `common/documentation` | **`PASS`** | `repo_structure_audit`, `library_hygiene_audit` | `98.4%` GoDoc coverage (`173/176`), `0` signature mismatches, structured multi-portal `README.md` |
| `common/git_workflow` | **`PASS`** | `repo_structure_audit` | Clean `.gitignore`, linear commit history, zero conflict markers |
| `common/library_guidelines` | **`PASS`** | `library_hygiene_audit` | Explicit exported API surface, `0` import-time I/O side effects, MVS SemVer bounds in `go.mod` |
| `common/maintainability` | **`WARN`** | `go_ast_audit`, `library_hygiene_audit` | `0` `>5`-param funcs, but `Command.getCompletions` (`cognitive=96`) and `Command.execute` (`66`) exceed `30` |
| `common/production_readiness` | **`PASS`** | `container_runtime_audit` | `0` missing I/O timeouts, `Command.ExecuteContext(ctx)` cancellation propagation |
| `common/runtime_verification` | **`PASS`** | `container_runtime_audit` | `424/424` offline tests pass (`7.03s`), `86.8%` measured statement coverage, `go build ./...` smoke pass |
| `common/security` | **`PASS`** | `repo_structure_audit`, `go_ast_audit` | `0` hardcoded/committed secrets, `0` unsafe shell/exec sinks |
| `common/security_vulnerability` | **`PASS`** | `go_ast_audit`, `security_vulnerability_audit` | `0` application CVEs (`app_vuln_counts.total = 0`), `0` IaC misconfigs, `0` CWE sinks |
| `common/supply_chain` | **`PASS`** | `repo_structure_audit`, `security_vulnerability_audit` | Cryptographic checksums in `go.sum`, `0` unpinned dependencies, `LICENSE-COBRA` + `LICENSE` |
| `go/code_quality` | **`WARN`** | `go_ast_audit` | `98.4%` GoDoc (`3` missing), `13` mutable package-level globals, fail-fast `panic()` in config helpers |
| `go/dependencies` | **`WARN`** | `repo_structure_audit` | Clean 4-package `go.mod` + `go.sum`, but conservative `go 1.15` language version directive |
| `go/testing` | **`PASS`** | `go_test_audit` | `17` `*_test.go` files (`100.0%` module coverage), `280` test funcs, table-driven subtests |
| `go/typing` | **`PASS`** | `go_ast_audit` | `94.1%` static type safety coverage, `0` `unsafe.Pointer`, `0` unscoped `//nolint` |

---

## 4.2 Consolidated Code Location Findings

```drawlib align=center code=fold file=consolidated_findings_matrix.png caption="Figure 4.2 — All 8 Consolidated Findings Mapped by Severity, File Location, Symbol & Rule"
from drawlib.canvas import save, setup
from drawlib.smartarts import Panel, Table
from drawlib.styles import Colors, Styles

setup(width=146, height=74, dpi=150)

outer = Panel(
    "Consolidated Findings Inventory (0 Crit · 0 High · 2 Med · 6 Low)",
    "Exact File, Line & Rule Mapping",
    style=Styles.Neutral,
    header_style=Styles.SecondaryNeutral.patch(shape_line_width=1.2),
    text_style=Styles.DarkBold.patch(text_size=11.0),
    description_style=Styles.Muted.patch(text_size=9.6),
    header_variant="filled",
    header_height=8.0,
)
outer.draw((4.0, 4.0), width=138.0, height=66.0, align="bottom_left")

tbl_body = Styles.Dark.patch(text_size=9.2)
tbl_hdr = Styles.WhiteBold.patch(text_size=9.6)

tbl = Table(
    cell_style=Styles.White,
    text_style=tbl_body,
    header_cell_style=Styles.PrimaryFlat,
    header_text_style=tbl_hdr,
    border_style=Styles.MutedThin,
)
tbl.set_style_cell_evenodd(
    even_color=Colors.Light,
    even_text_style=tbl_body,
    odd_color=Colors.White,
    odd_text_style=tbl_body,
)
tbl.set_style_cell_header(
    background_color=Colors.Primary,
    text_style=tbl_hdr,
)

rows = [
    ["Sev.", "File : Line", "Symbol", "Rule ID", "Finding Summary"],
    ["MED", "completions.go:316", "Command.getCompletions", "common/maintainability", "267 lines, 36 branches, cognitive=96"],
    ["MED", "command.go:905", "Command.execute", "common/maintainability", "141 lines, 36 branches, cognitive=66"],
    ["LOW", "cobra.go:55", "EnablePrefixMatching", "go/code_quality", "13 mutable package-level globals"],
    ["LOW", "args.go:22", "PositionalArgs", "go/code_quality", "3 exported symbols missing GoDoc"],
    ["LOW", "doc/yaml_docs.go:139", "GenYamlCustom", "common/library_guide.", "fmt.Println(err) before return err"],
    ["LOW", "completions_test.go:2896", "TestCompletionFuncCompat", "go/testing", "Discards RegisterFlagCompletionFunc err"],
    ["LOW", "zsh_completions.go:25", "GenZshCompletionFile", "common/runtime_verif.", "File wrappers unexercised (52.6%)"],
    ["LOW", "go.mod:3", "go 1.15", "go/dependencies", "Legacy go 1.15 toolchain directive"],
]

tbl.draw_flexible(
    xy=(7.0, 60.0),
    column_widths=[10.5, 28.5, 30.0, 26.5, 36.5],
    row_heights=[6.6] + [6.0] * 8,
    data=rows,
    align="top_left",
)

save()
```
